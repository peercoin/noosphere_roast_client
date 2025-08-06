import 'dart:async';
import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/api/events.dart';
import 'package:noosphere_roast_client/src/api/request_interface.dart';
import 'package:noosphere_roast_client/src/api/responses/signatures.dart';
import 'package:noosphere_roast_client/src/api/types/dkg_ack.dart';
import 'package:noosphere_roast_client/src/api/types/dkg_ack_request.dart';
import 'package:noosphere_roast_client/src/api/types/dkg_encrypted_secret.dart';
import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/api/types/new_dkg_details.dart';
import 'package:noosphere_roast_client/src/api/types/onetime_numbers.dart';
import 'package:noosphere_roast_client/src/api/types/signature_reply.dart';
import 'package:noosphere_roast_client/src/api/types/signature_round_start.dart';
import 'package:noosphere_roast_client/src/api/types/signatures_request_details.dart';
import 'package:noosphere_roast_client/src/api/types/signed.dart';
import 'package:noosphere_roast_client/src/api/types/signed_dkg_ack.dart';
import 'package:noosphere_roast_client/src/api/types/single_signature_details.dart';
import 'package:noosphere_roast_client/src/client/cached_storage.dart';
import 'package:noosphere_roast_client/src/client/dkg_in_progress.dart';
import 'package:noosphere_roast_client/src/client/frost_key_with_details.dart';
import 'package:noosphere_roast_client/src/client/state/sigs.dart';
import 'package:noosphere_roast_client/src/config/client.dart';
import 'package:frosty/frosty.dart';
import 'package:synchronized/extension.dart';
import 'events.dart';
import 'signatures_request.dart';
import 'storage_interface.dart';
import 'state/state.dart';
import 'state/dkg.dart';

typedef GetPrivateKey = Future<cl.ECPrivateKey> Function(KeyPurpose purpose);

/// An exception thrown when the server misbehaves
class ServerMisbehaviour implements Exception {

  final String message;

  ServerMisbehaviour(this.message);
  ServerMisbehaviour.noParticipant()
    : this("Participant identifier outside of group");
  ServerMisbehaviour.invalidDkgThreshold() : this("DKG threshold is too high");
  ServerMisbehaviour.duplicateDkg() : this("DKG names are not unique");
  ServerMisbehaviour.invalidSignature() : this("Invalid signature");
  ServerMisbehaviour.duplicateCommitment() : this("Duplicate commitment");
  ServerMisbehaviour.wrongParticipant() : this("Incorrect participant id");
  ServerMisbehaviour.badExpiry() : this("Expiry outside of bounds");
  ServerMisbehaviour.commitmentNotRound1()
    : this("Commitment given outside of round 1");
  ServerMisbehaviour.secretNotRound2()
    : this("Secret share given outside of round 2");
  ServerMisbehaviour.alreadyHaveSecret()
    : this("Already have DKG secret for participant");
  ServerMisbehaviour.ackNotRequested()
    : this("Gave ACK that wasn't requested");
  ServerMisbehaviour.duplicateSigsReq() : this("Duplicate signatures request");
  ServerMisbehaviour.duplicateSigsReqRounds()
    : this("Duplicate signatures request IDs for rounds");
  ServerMisbehaviour.emptySigRounds() : this("List of signing rounds is empty");
  ServerMisbehaviour.sigRoundOutOfRange()
    : this("Round signature index out of range");
  ServerMisbehaviour.duplicateSignRound()
    : this("ROAST round already requested");
  ServerMisbehaviour.wrongCommitmentNum()
    : this("Incorrect number of round commitments");
  ServerMisbehaviour.missingOurId()
    : this("Own signing commitment missing from set");
  ServerMisbehaviour.missingSigsReq()
    : this("Received signing round on login without associated request");
  ServerMisbehaviour.emptySignatures()
    : this("List of completed signatures is empty");
  ServerMisbehaviour.wrongSigNum()
    : this("Incorrect number of completed signatures");
  ServerMisbehaviour.prematureSigs()
    : this("Signatures responded before shares");
  ServerMisbehaviour.invalidCompleteSig()
    : this("Completed signature is invalid");

  @override
  String toString() => "ServerMisbehaviour: $message";

}

/// A high-level abstraction of a FROST participant client with the server API.
/// Use the [login] factory to create a client.
///
/// [ClientEvent]s are passed to the [events] stream.
///
/// An error may also passed to the [events] stream. The Client will disconnect
/// upon an error and [login] must be called again.
class Client {

  // Reasonable wait before extending session to prevent excessive requests
  static const _minWait = Duration(seconds: 10);

  // Time to extend session before expiry
  static const _extendBufferTime = Duration(seconds: 15);

  // Min TTL, under which the server will be considered misbehaving.
  static const _minExpiryTTL = Duration(minutes: -2);

  final ClientConfig config;
  final ApiRequestInterface api;
  final ClientCachedStorage _store;
  /// An asynchronous function to get the private key to allow for secure
  /// ephemeral access as needed.
  final GetPrivateKey getPrivateKey;
  final void Function() onDisconnect;

  late final ClientState _state;
  final _eventController = StreamController<ClientEvent>();
  late final StreamSubscription<Event> _eventSubscription;
  Future<void> _eventFuture = Future.value();

  final _sigReqLock = Object();
  final _dkgReqLock = Object();
  final _dkgAckLock = Object();

  static cl.ECPublicKey _getParticipantPubkeyForId(
    ClientConfig config, Identifier id,
  ) {
    final pubkey = config.group.participants[id];
    if (pubkey == null) throw ServerMisbehaviour.noParticipant();
    return pubkey;
  }

  static void _checkIdentifierSet(ClientConfig config, Set<Identifier> ids) {
    if (!config.allIds.containsAll(ids)) {
      throw ServerMisbehaviour.noParticipant();
    }
  }

  static Set<Identifier> _idsFromCommitments(DkgCommitmentList commitments) {
    final idSet = commitments.map((c) => c.$1).toSet();
    if (idSet.length != commitments.length) {
      throw ServerMisbehaviour.duplicateCommitment();
    }
    return idSet;
  }

  static void _checkSigned(
    ClientConfig config, Signed signed, Identifier signer,
  ) {
    if (!signed.verify(_getParticipantPubkeyForId(config, signer))) {
      throw ServerMisbehaviour.invalidSignature();
    }
  }

  static void _checkDetailsEvent(ClientConfig config, DetailsEvent ev) {
    _checkSigned(config, ev.details, ev.creator);
    if (ev.expiry.ttl.compareTo(_minExpiryTTL) < 0) {
      throw ServerMisbehaviour.badExpiry();
    }
  }

  static void _checkNewDkg(ClientConfig config, NewDkgEvent dkg) {

    _checkDetailsEvent(config, dkg);

    final details = dkg.details.obj;
    if (details.threshold > config.groupN) {
      throw ServerMisbehaviour.invalidDkgThreshold();
    }

    _checkIdentifierSet(config, _idsFromCommitments(dkg.commitments));

  }

  // Check round information without state context
  static void _checkRounds(
    ClientConfig config,
    List<SignatureRoundStart> rounds,
  ) {

    if (rounds.isEmpty) {
      throw ServerMisbehaviour.emptySigRounds();
    }

    if (rounds.map((round) => round.sigI).toSet().length != rounds.length) {
      throw ServerMisbehaviour.duplicateSignRound();
    }

    for (final round in rounds) {

      // Check commitments contains client id
      final ids = round.commitments.map.keys.toSet();
      if (!ids.contains(config.id)) {
        throw ServerMisbehaviour.missingOurId();
      }

      // Check identifiers exist in group
      _checkIdentifierSet(config, ids);

      // Check positive signature index, though this shouldn't happen when using
      // gRpc
      if (round.sigI < 0) {
        throw ServerMisbehaviour.sigRoundOutOfRange();
      }

    }

  }

  Client._({
    required this.config,
    required this.api,
    required ClientCachedStorage store,
    required SessionID sessionID,
    required Expiry sessionExpiry,
    required Stream<Event> events,
    required this.getPrivateKey,
    required this.onDisconnect,
  }) : _store = store {

    _state = ClientState(
      sessionID: sessionID,
      expiry: sessionExpiry,
      onDkgExpired: _onDkgExpiry,
      onSigsReqExpired: _onSigsReqExpiry,
    );

    _setSessionExtendTimer();

    _eventSubscription = events.listen(
      (ev) => _eventFuture = _handleEvent(ev),
      onDone: () => _disconnect(),
      onError: (Object e) => _sendError(e),
    );

  }

  void _onDkgExpiry(ClientDkgState dkgState) => _sendEvent(
    RejectedDkgClientEvent(
      details: dkgState.details,
      participant: null,
      fault: DkgFault.expired,
    ),
  );

  void _onSigsReqExpiry(ClientSigsState sigsState) => _sendEvent(
    SignaturesExpiryClientEvent(_sigsStateToObj(sigsState)),
  );

  ClientDkgState _addDkgToState({
    required ClientConfig config,
    required NewDkgDetails details,
    required Identifier creator,
    required DkgCommitmentList commitments,
  }) => _state.nameToDkg[details.name] = ClientDkgState(
    details: details,
    creator: creator,
    commitments: commitments,
    // Clamp TTL to max
    expiry: details.expiry.clampUpperTTL(config.maxDkgRequestTTL),
  );

  bool _sigReqExists(SignaturesRequestId id)
    => _state.sigRequests.containsKey(id);

  // If the DKG with the name exists, it shall run the criticalSection with the
  // DKG state. The sections will be run synchronously for the DKG.
  Future<void> _runDkgSyncIfExists(
    String name,
    FutureOr<void> Function(ClientDkgState) criticalSection,
  ) async {

    // Ignore non-existing DKG, in case ours expired before server's
    final dkg = _state.nameToDkg[name];

    await dkg?.synchronized(() async {
      // Check again if removed before start of async critical section
      if (!dkgExists(name)) return;
      await criticalSection(dkg);
    });

  }

  Future<void> _runSigsReqSyncIfExists(
    SignaturesRequestId reqId,
    FutureOr<void> Function(ClientSigsState) criticalSection,
  ) async {

    // Ignore non-existing request
    final sigsState = _state.sigRequests[reqId];

    await sigsState?.synchronized(() async {
      // Check again if removed before start of async critical section
      if (!_sigReqExists(reqId)) return;
      await criticalSection(sigsState);
    });

  }

  bool _dkgIsAccepted(ClientDkgState dkg)
    => dkg.round is! ClientDkgRound1State
    || dkg.round1.commitments.any((c) => c.$1 == config.id);

  void _checkParticipantId(Identifier id)
    => _getParticipantPubkeyForId(config, id);

  void _checkOtherParticipantId(Identifier id) {
    _checkParticipantId(id);
    if (id == config.id) throw ServerMisbehaviour.wrongParticipant();
  }

  void _disconnect() async {
    await logout();
    onDisconnect();
  }
  void _sendEvent(ClientEvent ev) => _eventController.add(ev);
  void _sendError(Object err) {
    if (_eventController.isClosed) return;
    _eventController.addError(err);
    _disconnect();
  }

  DkgPart1 _getDkgPart1(int threshold) => DkgPart1(
    identifier: config.id,
    threshold: threshold,
    n: config.groupN,
  );

  Future<void> _rejectDkgWithoutSync(String name) async {
    await api.rejectDkg(sid: _state.sessionID, name: name);
    _state.nameToDkg.remove(name);
  }

  Future<void> _rejectBadDkg({
    required NewDkgDetails details,
    required Identifier? culprit,
    required DkgFault fault,
  }) async {

    // Send rejection to server and remove from state
    await _rejectDkgWithoutSync(details.name);

    // Send event of the rejection
    _sendEvent(
      RejectedDkgClientEvent(
        details: details,
        participant: culprit,
        fault: fault,
      ),
    );

  }

  // Return true on rejection
  Future<bool> _doPart2IfReady(ClientDkgState dkg) async {

    final round1 = dkg.round1;

    // Not ready until all commitments received
    if (round1.commitments.length != config.groupN) return false;

    final commitmentSet = DkgCommitmentSet(round1.commitments);

    late DkgPart2 part2;
    try {
      part2 = DkgPart2(
        identifier: config.id,
        round1Secret: round1.ourSecret!,
        commitments: commitmentSet,
      );
    } on InvalidPart2ProofOfKnowledge catch(e) {
      await _rejectBadDkg(
        details: dkg.details,
        culprit: e.culprit,
        fault: DkgFault.proofOfKnowledge,
      );
      return true;
    }

    final key = await getPrivateKey(KeyPurpose.dkgPart2);

    await api.submitDkgRound2(
      sid: _state.sessionID,
      name: dkg.details.name,
      commitmentSetSignature: cl.SchnorrSignature.sign(
        key,
        dkg.details.hashWithCommitments(commitmentSet),
      ),
      secrets: part2.sharesToGive.map(
        (id, share) => MapEntry(
          id,
          DkgEncryptedSecret.encrypt(
            secretShare: share,
            recipientKey: _getParticipantPubkeyForId(config, id),
            senderKey: key,
          ),
        ),
      ),
    );

    // Move state to round 2
    dkg.round = ClientDkgRound2State(part2.secret, commitmentSet);

    return false;

  }

  Future<void> _doPart3(ClientDkgState dkg) async {

    final round2 = dkg.round2;

    late ParticipantKeyInfo keyInfo;
    try{
      keyInfo = DkgPart3(
        identifier: config.id,
        round2Secret: round2.ourSecret,
        commitments: round2.commitmentSet,
        receivedShares: round2.secretShares,
      ).participantInfo;
    } on InvalidPart3 {
      await _rejectBadDkg(
        details: dkg.details,
        // Frosty does not provide participant with invalid secret
        culprit: null,
        fault: DkgFault.secret,
      );
    }

    // Store new FROST key
    final newKey = FrostKeyWithDetails(
      keyInfo: keyInfo,
      name: dkg.details.name,
      description: dkg.details.description,
      acks: {},
    );
    await _store.addNewFrostKey(newKey);

    // Remove DKG which is complete
    _state.nameToDkg.remove(dkg.details.name);

    // Store and send our ACK
    await api.sendDkgAcks(
      sid: _state.sessionID,
      acks: {
        await _createDkgAck(keyInfo.groupKey, true),
      },
    );

  }

  Future<SignedDkgAck> _createDkgAck(
    cl.ECCompressedPublicKey groupKey,
    bool accept,
  ) async {

    final ack = SignedDkgAck(
      signer: config.id,
      signed: Signed.sign(
        obj: DkgAck(groupKey: groupKey, accepted: accept),
        key: await getPrivateKey(KeyPurpose.signAck),
      ),
    );

    // Store if we are accepting (and therefore have) the key
    if (accept) await _store.addOrReplaceAck(ack);

    return ack;

  }

  Future<void> _verifyAndAddAck(SignedDkgAck ack) async {

    // Ignore keys we do not have
    if (!_store.keys.containsKey(ack.signed.obj.groupKey)) return;

    _checkOtherParticipantId(ack.signer);
    _checkSigned(config, ack.signed, ack.signer);

    // Add/Update ACK for key
    await _store.addOrReplaceAck(ack);

  }

  Future<void> _requestAcks(
    Set<Identifier> ids,
  ) => _dkgAckLock.synchronized(() async {

    // Obtain requests for missing ACKS for ids
    final requests = _store.getAckRequestsForMissing(ids);

    // If nothing is needed, then return
    if (requests.isEmpty) return;

    // Request ACKs we need
    final acks = await api.requestDkgAcks(
      sid: _state.sessionID,
      requests: requests,
    );

    // Add received acks
    for (final ack in acks) {

      // Verify that we requested it
      if (
        !requests.any(
          (req) => req.groupPublicKey == ack.signed.obj.groupKey
          && req.ids.contains(ack.signer),
        )
      ) {
        throw ServerMisbehaviour.ackNotRequested();
      }

      // Verify signature and add if OK
      await _verifyAndAddAck(ack);

    }

  });

  Future<ClientSigsState?> _handleSigsReq({
    required Signed<SignaturesRequestDetails> signed,
    required Identifier creator,
  }) async {

    final details = signed.obj;
    if (details.expiry.isExpired) return null;

    // Reject if we do not own any one of the keys
    if (details.requiredSigs.any((sig) => !keys.keys.contains(sig.groupKey))) {
      await api.rejectSignaturesRequest(
        sid: _state.sessionID,
        reqId: details.id,
      );
      return null;
    }

    // Add to and return state
    return _state.sigRequests[details.id] = ClientSigsState(
      details: details,
      creator: creator,
      // Clamp TTL to max
      expiry: details.expiry.clampUpperTTL(config.maxSignaturesTTL),
    );

  }

  SignPart1 _getSignPart1(SingleSignatureDetails details) => SignPart1(
    privateShare: keys[details.groupKey]!.keyInfo.private.share,
  );

  List<SignPart1> _getSignPart1s(SignaturesRequestDetails details)
    => details.requiredSigs.map(_getSignPart1).toList();

  Future<void> _storeInitialSigNonces(
    SignaturesRequestDetails details,
    List<SignPart1> part1s,
  ) => _store.addSignaturesNonces(
    id: details.id,
    nonces: SignaturesNonces(
      { for (int i = 0; i < part1s.length; i++) i: part1s[i].nonces },
      details.expiry,
    ),
    capacity: part1s.length,
  );

  Future<void> _handlePossibleRoundsResponse(
    ClientSigsState sigsState,
    SignaturesResponse? resp,
  ) async {
    if (resp is SignatureNewRoundsResponse) {
      _checkRounds(config, resp.rounds);
      await _handleRounds(sigsState, resp.rounds);
    }
  }

  Future<void> _initialSigning(ClientSigsState sigsState) async {

    final details = sigsState.details;
    final numSigs = details.requiredSigs.length;
    final part1s = _getSignPart1s(details);

    // Provide commitments to server
    final resp = await api.submitSignatureReplies(
      sid: _state.sessionID,
      reqId: details.id,
      replies: List.generate(
        numSigs,
        (i) => SignatureReply(
          sigI: i,
          nextCommitment: part1s[i].commitment,
        ),
      ),
    );

    // Shouldn't have a completed signatures after providing initial commitments
    if (resp is SignaturesCompleteResponse) {
      throw ServerMisbehaviour.prematureSigs();
    }

    // Store nonce. If storage fails, then this participant will fail to
    // conduct the ROAST protocol as the server expects participants to have
    // these nonces. However only if n-t+1 participants fail, will the
    // signature fail.
    // The nonces could be stored first alongside commitments and the server
    // could receive them again if failure occurs, though the server would
    // have to ignore duplicates.
    await _storeInitialSigNonces(details, part1s);
    await _handlePossibleRoundsResponse(sigsState, resp);

  }

  HDParticipantKeyInfo _infoForSig(
    SingleSignatureDetails details,
  ) => details.derive(
    HDParticipantKeyInfo.masterFromInfo(
      keys[details.groupKey]!.keyInfo,
    ),
  );

  Future<void> _handleRounds(
    ClientSigsState sigsState,
    List<SignatureRoundStart> rounds,
  ) async {

    final sigDetails = sigsState.details;
    final requiredSigs = sigDetails.requiredSigs;
    final reqId = sigDetails.id;

    for (final round in rounds) {

      // Check signature index
      if (round.sigI >= requiredSigs.length) {
        throw ServerMisbehaviour.sigRoundOutOfRange();
      }

      // If we already have a pending round, the server shouldn't have
      // sent this event
      if (
        sigsState.pendingRounds.any(
          (pending) => round.sigI == pending.sigI,
        )
      ) {
        throw ServerMisbehaviour.duplicateSignRound();
      }

      // Check number of commitments equals threshold
      final key = keys[requiredSigs[round.sigI].groupKey]!;
      final threshold = key.keyInfo.group.threshold;
      if (round.commitments.map.length != threshold) {
        throw ServerMisbehaviour.wrongCommitmentNum();
      }

    }

    final nonces = _store.sigNonces[reqId];

    // Check we have nonces. If we don't then either the server is
    // providing an invalid round or storage of the nonces failed.
    // In this case, reject the signature.
    if (
      nonces == null
      || !rounds.every((round) => nonces.map.containsKey(round.sigI))
    ) {
      await _rejectSigsReq(sigsState);
      return;
    }

    // Add pending rounds
    sigsState.pendingRounds.addAll(rounds);

    // If the request isn't in a rejected state, continue with signing
    if (!_store.sigsRejected.containsKey(reqId)) {
      await _continueSigning(sigsState);
    }

  }

  void _checkSigsNotEmpty(List<cl.SchnorrSignature> signatures) {
    if (signatures.isEmpty) throw ServerMisbehaviour.emptySignatures();
  }

  // Continue processing ROAST, providing commitments and signature shares if
  // required.
  Future<void> _continueSigning(ClientSigsState sigsState) async {

    final details = sigsState.details;
    final reqId = details.id;
    final nonces = _store.sigNonces[reqId];

    // If no nonces have been produced yet, generate nonces and provide the
    // commitments
    if (nonces == null) {
      await _initialSigning(sigsState);
      return;
    }

    // There are nonces, so continue with rounds if there are any pending
    if (sigsState.pendingRounds.isEmpty) return;

    final Map<int, SigningNonces> newNonces = {};
    final List<SignatureReply> replies = [];

    for (final round in sigsState.pendingRounds) {

      final i = round.sigI;
      final requiredSig = details.requiredSigs[i];
      final sigNonces = nonces.map[i]!;

      late SignatureShare share;
      try {
        share = SignPart2(
          identifier: config.id,
          details: requiredSig.signDetails,
          ourNonces: sigNonces,
          commitments: round.commitments,
          info: _infoForSig(requiredSig).signing,
        ).share;
      } on InvalidSignPart2 {
        // If there is a failure, then it may be due to old nonces not having
        // been replaced due to previous network failure or client crash, so
        // reject signature.
        await _rejectSigsReq(sigsState);
        return;
      }

      // Get next part 1 including nonce
      final part1 = _getSignPart1(requiredSig);
      newNonces[i] = part1.nonces;

      replies.add(
        SignatureReply(
          sigI: i,
          nextCommitment: part1.commitment,
          share: share,
        ),
      );

    }

    final resp = await api.submitSignatureReplies(
      sid: _state.sessionID,
      reqId: reqId,
      replies: replies,
    );

    // Handled pending rounds, so remove them from the state
    sigsState.pendingRounds.clear();

    if (resp is SignaturesCompleteResponse) {
      // Signatures are complete so end here
      _checkSigsNotEmpty(resp.signatures);
      await _handleCompletedSignatures(
        details: sigsState.details,
        signatures: resp.signatures,
        creator: sigsState.creator,
      );
      return;
    }

    // Replace nonces before handling any new rounds
    await _store.addSignaturesNonces(
      id: reqId,
      nonces: SignaturesNonces(newNonces, details.expiry),
      capacity: details.requiredSigs.length,
    );

    await _handlePossibleRoundsResponse(sigsState, resp);

  }

  Future<void> _handleCompletedSignatures({
    required SignaturesRequestDetails details,
    required List<cl.SchnorrSignature> signatures,
    required Identifier creator,
  }) async {

    if (signatures.length != details.requiredSigs.length) {
      throw ServerMisbehaviour.wrongSigNum();
    }

    // Verify signatures
    for (int i = 0; i < signatures.length; i++) {

      final sigDetails = details.requiredSigs[i];
      final signDetails = sigDetails.signDetails;
      var key = _infoForSig(sigDetails).groupKey;

      if (signDetails.mastHash != null) {
        // Get tweaked BIP341 (Taproot) public key
        key = key.xonly.tweak(
          cl.Taproot.tweakHash(
            Uint8List.fromList([...key.x, ...signDetails.mastHash!]),
          ),
        )!;
      }

      if (!signatures[i].verify(key, signDetails.message)) {
        throw ServerMisbehaviour.invalidCompleteSig();
      }

    }

    // Remove signatures request state
    _state.sigRequests.remove(details.id);

    // Remove signature request details from storage
    await _store.removeSigsRequest(details.id);

    // Provide completed signatures as client event
    _sendEvent(
      SignaturesCompleteClientEvent(
        details: details,
        creator: creator,
        signatures: signatures,
      ),
    );

  }

  Future<void> _rejectSigsReq(ClientSigsState sigsState) async {
    final id = sigsState.details.id;
    if (_store.sigsRejected.containsKey(id)) return;
    await api.rejectSignaturesRequest(sid: _state.sessionID, reqId: id);
    await _store.addRejectedSigsRequest(id, sigsState.expiry);
  }

  Future<void> _handleEvent(Event ev) async {

    // After logout, the session shall be expired and no more events can be
    // processed
    if (_state.expiry.isExpired) return;

    try {
      switch (ev) {

        case ParticipantStatusEvent():

          _checkOtherParticipantId(ev.id);

          if (!ev.loggedIn) {

            _state.onlineParticipants.remove(ev.id);

            // Remove DKG commitments for logged out participant
            for (final dkg in _state.round1Dkgs) {
              dkg.round1.commitments.removeWhere((c) => c.$1 == ev.id);
            }

            // Reset round 2 DKGs to round 1
            for (final dkg in _state.round2Dkgs) {
              dkg.round = ClientDkgRound1State([], null);
            }

          } else {

            _state.onlineParticipants.add(ev.id);

            // Ask for ACKs for logged in participant plus any logged out
            // participants that the logged in participant might have.
            await _requestAcks(
              config.otherIds.where(
                (id)
                => id == ev.id
                || !_state.onlineParticipants.contains(id),
              ).toSet(),
            );

          }

          _sendEvent(
            ParticipantStatusClientEvent(id: ev.id, loggedIn: ev.loggedIn),
          );

        case NewDkgEvent():

          _checkOtherParticipantId(ev.creator);
          _checkNewDkg(config, ev);

          final details = ev.details.obj;
          if (details.expiry.isExpired) return;

          // If DKG name already exists, it will be replaced
          // Run synchronously with other code that works on an existing DKG so
          // that DKG is not removed half-way through asynchronous code

          final existing = _state.nameToDkg[ev.details.obj.name];

          ClientDkgState setNew() => _addDkgToState(
            config: config,
            details: details,
            creator: ev.creator,
            commitments: ev.commitments,
          );

          final dkg = existing == null
            ? setNew()
            : await existing.synchronized(setNew);

          _sendEvent(UpdatedDkgClientEvent(dkg.progress(config.id)));

        case DkgRejectEvent():

          _checkOtherParticipantId(ev.participant);

          await _runDkgSyncIfExists(ev.name, (dkg) {
            _state.nameToDkg.remove(ev.name);
            _sendEvent(
              RejectedDkgClientEvent(
                details: dkg.details, participant: ev.participant,
              ),
            );
          });

        case DkgCommitmentEvent():

          _checkOtherParticipantId(ev.participant);

          await _runDkgSyncIfExists(ev.name, (dkg) async {

            if (dkg.round is! ClientDkgRound1State) {
              throw ServerMisbehaviour.commitmentNotRound1();
            }

            final round1 = dkg.round1;

            if (round1.commitments.any((c) => c.$1 == ev.participant)) {
              throw ServerMisbehaviour.duplicateCommitment();
            }

            round1.commitments.add((ev.participant, ev.commitment));

            // If all commitments have been received, do part 2
            // Returns true if rejected, so do not send update event
            if (await _doPart2IfReady(dkg)) return;

            _sendEvent(UpdatedDkgClientEvent(dkg.progress(config.id)));

          });

        case DkgRound2ShareEvent():

          _checkOtherParticipantId(ev.sender);

          // Synchronise with ACKs to ensure the key is processed before
          // processing ACKs for it
          await _dkgAckLock.synchronized(
            () => _runDkgSyncIfExists(ev.name, (dkg) async {

              if (dkg.round is! ClientDkgRound2State) {
                throw ServerMisbehaviour.secretNotRound2();
              }

              final round2 = dkg.round2;

              if (round2.secretShares.containsKey(ev.sender)) {
                throw ServerMisbehaviour.alreadyHaveSecret();
              }

              final senderKey = _getParticipantPubkeyForId(config, ev.sender);

              // Verify commitment set and decrypt secret
              if (
                !ev.commitmentSetSignature.verify(
                  senderKey,
                  dkg.details.hashWithCommitments(round2.commitmentSet),
                )
              ) {
                throw ServerMisbehaviour.invalidSignature();
              }

              final key = await getPrivateKey(KeyPurpose.decryptDkgSecret);

              final secret = ev.secret.decrypt(
                recipientKey: key,
                senderKey: senderKey,
              );

              if (secret == null) {
                // Cannot decrypt share so reject DKG
                await _rejectBadDkg(
                  details: dkg.details,
                  culprit: ev.sender,
                  fault: DkgFault.secretCiphertext,
                );
                return;
              }

              // Add secret
              round2.secretShares[ev.sender] = secret;

              // Attempt to complete key if all secrets have been received
              if (round2.secretShares.length == config.groupN-1) {
                await _doPart3(dkg);
              } else {
                // If not completed, provide update event
                _sendEvent(UpdatedDkgClientEvent(dkg.progress(config.id)));
              }

            }
          ),
        );

        case DkgAckEvent():
          await _dkgAckLock.synchronized(
            () => Future.wait(ev.acks.map((ack) => _verifyAndAddAck(ack))),
          );

        case DkgAckRequestEvent():
          await _dkgAckLock.synchronized(() async {

            final Set<SignedDkgAck> toSend = {};

            for (final req in ev.requests) {

              final DkgAckRequest(:ids, :groupPublicKey) = req;

              _checkIdentifierSet(config, ids);

              if (_store.keys.containsKey(groupPublicKey)) {
                // As we have the key, send the _stored acks that we have for it
                toSend.addAll(_store.getAcksForRequest(req));
              } else if (ids.contains(config.id)) {
                // Haven't got key so send our own NACK
                toSend.add(await _createDkgAck(groupPublicKey, false));
              }

            }

            if (toSend.isNotEmpty) {
              await api.sendDkgAcks(sid: _state.sessionID, acks: toSend);
            }

          });

        case SignaturesRequestEvent():
          await _sigReqLock.synchronized(() async {

            _checkOtherParticipantId(ev.creator);
            _checkDetailsEvent(config, ev);
            if (_sigReqExists(ev.details.obj.id)) {
              throw ServerMisbehaviour.duplicateSigsReq();
            }

            final sigsState = await _handleSigsReq(
              signed: ev.details, creator: ev.creator,
            );
            if (sigsState == null) return;

            _sendEvent(
              SignaturesRequestClientEvent(
                SignaturesRequest(
                  details: ev.details.obj,
                  creator: ev.creator,
                  expiry: sigsState.expiry,
                  status: SignaturesRequestStatus.waiting,
                ),
              ),
            );

          });

        case SignaturesFailureEvent():
          await _runSigsReqSyncIfExists(ev.reqId, (sigsState) async {
            final removedState = _state.sigRequests.remove(ev.reqId);
            if (removedState != null) {
              _sendEvent(
                SignaturesFailureClientEvent(_sigsStateToObj(removedState)),
              );
            }
            await _store.removeSigsRequest(ev.reqId);
          });

        case SignatureNewRoundsEvent():
          _checkRounds(config, ev.rounds);
          await _runSigsReqSyncIfExists(
            ev.reqId,
            (sigsState) => _handleRounds(sigsState, ev.rounds),
          );

        case SignaturesCompleteEvent():
          _checkSigsNotEmpty(ev.signatures);
          await _runSigsReqSyncIfExists(
            ev.reqId,
            (sigsState) => _handleCompletedSignatures(
              details: sigsState.details,
              signatures: ev.signatures,
              creator: sigsState.creator,
            ),
          );

        case SecretShareEvent():
          // TODO: Handle this case.
          throw UnimplementedError();

        case ConstructedKeyEvent():
          // TODO: Handle this case.
          throw UnimplementedError();

        case KeepaliveEvent():
          // Do nothing, this is only to keep middleware happy

      }
    } catch(e) {
      _sendError(e);
    }

  }

  Future<void> _extendSession() async {
    try {
      _state.expiry = await api.extendSession(_state.sessionID);
      _setSessionExtendTimer();
    } catch(e) {
      // Emit error
      _sendError(e);
    }
  }

  void _setSessionExtendTimer() {

    final wait = _state.expiry.time
      .subtract(_extendBufferTime)
      .difference(DateTime.now());

    _state.sessionExtension = Timer(
      wait.compareTo(_minWait) < 0 ? _minWait : wait,
      () => _extendSession(),
    );

  }

  /// Creates a new Client session with the server.
  ///
  /// The session will automatically be extended.
  ///
  /// The client shall remain alive until [logout] is called or until the server
  /// disconnects. [onDisconnect] will be called if a disconnection is detected.
  /// After a disconnect, the [events] stream will close and all methods should
  /// produce an exception.
  ///
  /// The [events] stream should be listened to immediately as events will
  /// continuously buffer until they are handled.
  static Future<Client> login({
    required ClientConfig config,
    required ApiRequestInterface api,
    required ClientStorageInterface store,
    required GetPrivateKey getPrivateKey,
    void Function()? onDisconnect,
  }) async {

    // Get key and load storage
    final key = await getPrivateKey(KeyPurpose.login);
    final cachedStore = await ClientCachedStorage.load(store);

    // Login with server
    final resp1 = await api.login(
      groupFingerprint: config.group.fingerprint,
      participantId: config.id,
    );
    final resp2 = await api.respondToChallenge(
      Signed.sign(obj: resp1.challenge, key: key),
    );

    // Do verification of details without state processing first

    // Verify online participants
    _checkIdentifierSet(config, resp2.onlineParticipants);

    // Verify DKGs
    for (final dkg in resp2.newDkgs) {
      _checkNewDkg(config, dkg);
    }

    // Check there are no duplicates
    final names = resp2.newDkgs.map((dkg) => dkg.details.obj.name);
    if (names.length != names.toSet().length) {
      throw ServerMisbehaviour.duplicateDkg();
    }

    // Verify Signatures Requests
    for (final req in resp2.sigRequests) {
      _checkDetailsEvent(config, req);
    }

    // Check for duplicate requests
    {
      final ids = resp2.sigRequests.map((req) => req.details.obj.id);
      if (ids.length != ids.toSet().length) {
        throw ServerMisbehaviour.duplicateSigsReq();
      }
    }

    // Check duplicate signature request in rounds
    {
      final ids = resp2.sigRounds.map((rounds) => rounds.reqId);
      if (ids.length != ids.toSet().length) {
        throw ServerMisbehaviour.duplicateSigsReqRounds();
      }
    }

    // Check signature rounds
    for (final round in resp2.sigRounds) {
      _checkRounds(config, round.rounds);
      // Must have signature request for rounds
      if (!resp2.sigRequests.any((req) => req.details.obj.id == round.reqId)) {
        throw ServerMisbehaviour.missingSigsReq();
      }
    }

    // Check completed signature details
    for (final completedSig in resp2.completedSigs) {
      _checkSigned(config, completedSig.details, completedSig.creator);
    }

    final client = Client._(
      config: config,
      api: api,
      store: cachedStore,
      sessionID: resp2.id,
      sessionExpiry: resp2.expiry,
      events: resp2.events,
      getPrivateKey: getPrivateKey,
      onDisconnect: onDisconnect ?? () {},
    );

    // Add the online participants
    client._state.onlineParticipants = resp2.onlineParticipants;

    // Add DKGs to state
    for (final dkg in resp2.newDkgs) {
      final details = dkg.details.obj;
      if (details.expiry.isExpired) continue;
      client._addDkgToState(
        config: config,
        details: details,
        creator: dkg.creator,
        commitments: dkg.commitments,
      );
    }

    // Add signature requests to state
    for (final req in resp2.sigRequests) {
      await client._handleSigsReq(
        signed: req.details,
        creator: req.creator,
      );
    }

    // Handle signature rounds
    for (final round in resp2.sigRounds) {
      final sigReq = client._state.sigRequests[round.reqId];
      // It may be null if expired or otherwise rejected so ignore in those
      // cases
      if (sigReq != null) await client._handleRounds(sigReq, round.rounds);
    }

    // Handle completed signatures as immediate events
    for (final completedSig in resp2.completedSigs) {
      await client._handleCompletedSignatures(
        details: completedSig.details.obj,
        signatures: completedSig.signatures,
        creator: completedSig.creator,
      );
    }

    // Request ACKs that are needed
    // Do not await for these ACKs but capture errors as events
    () async {
      try {
        await client._requestAcks(config.otherIds);
      } catch(e) {
        client._sendError(e);
      }
    }();

    return client;

  }

  /// Request Distributed Key Generation for a proposed key with the given
  /// [details]. The DKG name must not be the same as any other in-progress DKG.
  /// [dkgExists] can be used to determine if a name already exists.
  ///
  /// The client will be assumed to have accepted the DKG.
  Future<void> requestDkg(NewDkgDetails details) async {

    // Check expiry
    if (!config.dkgExpiryAcceptable(details.expiry)) {
      throw ArgumentError.value(
        details.expiry,
        "details.expiry",
        "not in range",
      );
    }

    // Wait until request is fully handled, before handling another to avoid
    // trying to submit DKG with same name more than once.
    await _dkgReqLock.synchronized(() async {

      // Check if exists
      if (dkgExists(details.name)) {
        throw ArgumentError.value(details.name, "details.name", "exists");
      }

      // Sign details
      final key = await getPrivateKey(KeyPurpose.dkgDetails);
      final signedDetails = Signed.sign(obj: details, key: key);

      // Create commitment and part 1 secret
      final part1 = _getDkgPart1(details.threshold);

      // Submit to server
      await api.requestNewDkg(
        sid: _state.sessionID,
        signedDetails: signedDetails,
        commitment: part1.public,
      );

      // Update state
      _state.nameToDkg[details.name] = ClientDkgState(
        details: details,
        creator: config.id,
        commitments: [(config.id, part1.public)],
        ourSecret: part1.secret,
        expiry: details.expiry,
      );

    });

  }

  Future<void> rejectDkg(String name) => _runDkgSyncIfExists(
    name, (_) => _rejectDkgWithoutSync(name),
  );

  Future<void> acceptDkg(String name) => _runDkgSyncIfExists(
    name,
    (dkg) async {

      if (_dkgIsAccepted(dkg)) {
        throw ArgumentError.value(name, "name", "not an unaccepted DKG");
      }

      final part1 = _getDkgPart1(dkg.details.threshold);

      await api.submitDkgCommitment(
        sid: _state.sessionID,
        name: name,
        commitment: part1.public,
      );

      dkg.round1
        ..ourSecret = part1.secret
        ..commitments.add((config.id, part1.public));

      await _doPart2IfReady(dkg);

    },
  );

  /// Request signatures from the group
  Future<void> requestSignatures(SignaturesRequestDetails details) async {

    // Check expiry
    if (!config.signaturesExpiryAcceptable(details.expiry)) {
      throw ArgumentError.value(
        details.expiry,
        "details.expiry",
        "not in range",
      );
    }

    // Avoid race conditions, trying to submit the same request multiple times
    await _sigReqLock.synchronized(() async {

      // Check if exists
      if (_sigReqExists(details.id)) {
        throw ArgumentError.value(details.id, "details.id", "exists");
      }

      // Obtain keys, ensuring they all exist
      final requiredKeys = details.requiredSigs.map(
        (sig) => keys[sig.groupKey],
      ).toSet();
      if (requiredKeys.contains(null)) {
        throw ArgumentError("Signature requires non-existant key");
      }
      final aggregateKeys = requiredKeys
        .map((key) => key!.keyInfo.aggregate)
        .toSet();

      // Sign details
      final key = await getPrivateKey(KeyPurpose.signaturesDetails);
      final signedDetails = Signed.sign(obj: details, key: key);

      // Create commitments for signatures
      final part1s = _getSignPart1s(details);

      // Submit to server
      await api.requestSignatures(
        sid: _state.sessionID,
        keys: aggregateKeys,
        signedDetails: signedDetails,
        commitments: part1s.map((part1) => part1.commitment).toList(),
      );

      // Update state
      _state.sigRequests[details.id] = ClientSigsState(
        details: details,
        creator: config.id,
        expiry: details.expiry,
      );

      // Store our presignature commitment nonces
      await _storeInitialSigNonces(details, part1s);

    });

  }

  Future<void> rejectSignaturesRequest(
    SignaturesRequestId reqId,
  ) => _runSigsReqSyncIfExists(reqId, _rejectSigsReq);

  Future<void> acceptSignaturesRequest(
    SignaturesRequestId reqId,
  ) => _runSigsReqSyncIfExists(
    reqId,
    (sigsState) async {
      // Remove from rejected if it was
      await _store.removeRejectionOfSigsRequest(reqId);
      await _continueSigning(sigsState);
    },
  );

  /// Stops further activity of the client and waits for existing events to
  /// finish processing before completing.
  ///
  /// The client can no longer be used after this has been called
  Future<void> logout() async {
    // Ensure session is expired and that no more events shall be processed
    _state.sessionExtension?.cancel();
    _state.expiry = Expiry(Duration(days: -1));
    // Finish existing events
    await _eventFuture;
    // Cancel stream with server
    await _eventSubscription.cancel();
    await _eventController.close();
  }

  /// Determines if the in-progress DKG by [name] already exists.
  bool dkgExists(String name) => _state.nameToDkg.containsKey(name);

  /// Participants that are online according to the server
  Set<Identifier> get onlineParticipants => _state.onlineParticipants;

  List<DkgInProgress> _getDkgProgress(bool accepted) => _state.nameToDkg.values
    .where((dkg) => _dkgIsAccepted(dkg) == accepted)
    .map((dkg) => dkg.progress(config.id))
    .toList();

  /// Requests for DKGs that the client can accept or reject
  List<DkgInProgress> get dkgRequests => _getDkgProgress(false);

  /// Status of DKGs that the client has accepted
  List<DkgInProgress> get acceptedDkgs => _getDkgProgress(true);

  /// Obtains all keys, mapping the group key to the full details
  Map<cl.ECCompressedPublicKey, FrostKeyWithDetails> get keys => _store.keys;

  SignaturesRequest _sigsStateToObj(ClientSigsState sigsState)
    => SignaturesRequest(
      details: sigsState.details,
      creator: sigsState.creator,
      expiry: sigsState.expiry,
      status: _store.sigsRejected.containsKey(sigsState.details.id)
      ? SignaturesRequestStatus.rejected
      : (
        // If we have provided nonces, then we have accepted the request
        _store.sigNonces.containsKey(sigsState.details.id)
        ? SignaturesRequestStatus.accepted
        : SignaturesRequestStatus.waiting
      ),
    );

  /// A list of all outstanding signatures requests, including those already
  /// accepted or rejected by the client.
  List<SignaturesRequest> get signaturesRequests
    => _state.sigRequests.values.map(_sigsStateToObj).toList();

  /// A stream of events to keep track of state changes that occur. If an error
  /// is provided on this stream, the stream will immediately close afterwards.
  ///
  /// If there is an error, the client may have lost connection to the server,
  /// or the server may be malfunctioning. When an error is received, the client
  /// will be disconnected and [onDisconnect] shall be called. No more events or
  /// errors shall be given and this stream will close. A new login should be
  /// attempted whereby all DKG requests will need to be re-accepted.
  ///
  /// This stream should be listened to immediately and continuously from login
  /// to prevent a large number of events being buffered.
  Stream<ClientEvent> get events => _eventController.stream;

}

/// CONSUMERS OF THIS LIBRARY SHOULD AVOID THIS
///
/// Used for testing purposes only. The state is not intended as part of the
/// library interface and may break backwards compatibility.
ClientState getHiddenClientStateForTestsDoNotUse(Client client)
  => client._state;

import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';
import 'package:noosphere_roast_client/src/api/types/key_was_constructed.dart';
import 'events.dart';
import 'responses/login_complete.dart';
import 'responses/expirable_auth_challenge.dart';
import 'responses/signatures.dart';
import 'types/dkg_ack_request.dart';
import 'types/dkg_encrypted_secret.dart';
import 'types/encrypted_key_share.dart';
import 'types/expiry.dart';
import 'types/new_dkg_details.dart';
import 'types/onetime_numbers.dart';
import 'types/signature_reply.dart';
import 'types/signatures_request_details.dart';
import 'types/signed.dart';
import 'types/signed_dkg_ack.dart';

/// Errors to be thrown when an API method is called where the request cannot be
/// satisfied due to an invalid request.
class InvalidRequest implements Exception {
  final String message;
  InvalidRequest(this.message);
  InvalidRequest.invalidProtoVersion() : this("Only protocol v2 is supported");
  InvalidRequest.groupMismatch() : this("Group fingerprint does not match");
  InvalidRequest.noParticipant() : this("Participant identifier not in group");
  InvalidRequest.noChallenge() : this("Challenge doesn't exist or is expired");
  InvalidRequest.invalidChallengeSig() : this("Challenge signature is invalid");
  InvalidRequest.noSession() : this("Session ID doesn't exist");
  InvalidRequest.invalidThreshold() : this("Invalid threshold for the group");
  InvalidRequest.expiryTooSoon() : this("The expiry is too soon");
  InvalidRequest.expiryTooLate() : this("The expiry is too late");
  InvalidRequest.dkgRequestExists() : this("DKG request with same name exists");
  InvalidRequest.invalidDkgReqSig() : this("Invalid DKG request signature");
  InvalidRequest.noDkg() : this("No DKG exists by the name");
  InvalidRequest.notRound1Dkg() : this("The DKG is not at round 1");
  InvalidRequest.dkgCommitmentExists()
    : this("Participant commitment already in DKG");
  InvalidRequest.notRound2Dkg() : this("The DKG is not at round 2");
  InvalidRequest.invalidDkgCommitmentSetSignature()
    : this("Invalid DKG commitment set signature");
  InvalidRequest.dkgRound2Sent()
    : this("The round 2 DKG data was already sent");
  InvalidRequest.invalidSecretMap() : this("DKG secrets are invalid");
  InvalidRequest.invalidDkgAckSignature() : this("DKG ack signature invalid");
  InvalidRequest.cannotRequestSelfAck() : this("Cannot request own DKG ack");
  InvalidRequest.wrongCommitmentNum()
    : this("Wrong number of signing commitments");
  InvalidRequest.wrongSigKeys()
    : this("Incorrect keys provided for signatures request");
  InvalidRequest.invalidSigReqSignature()
    : this("Signatures request signature invalid");
  InvalidRequest.sigRequestExists() : this("Signatures request already exists");
  InvalidRequest.markedMalicious()
    : this("Cannot give signatures reply as considered malicious");
  InvalidRequest.emptySigReply() : this("Signature reply is empty");
  InvalidRequest.duplicateSigReply()
    : this("Duplicate reply for signature");
  InvalidRequest.invalidSigIndex() : this("Signature index is out of range");
  InvalidRequest.sigAlreadyDone() : this("Signature was already finished");
  InvalidRequest.nextCommitmentExists()
    : this("Already have commitment waiting for next round");
  InvalidRequest.unsolicitedShare()
    : this("Received share that wasn't solicited");
  InvalidRequest.missingShare() : this("Missing share for ROAST round");
  InvalidRequest.invalidShare() : this("Signature share is invalid");
  InvalidRequest.invalidKeyShareMap() : this("Encrypted key shares are invalid");
  InvalidRequest.invalidKeyConstructedSig()
    : this("Constructed key acknowledgement signature invalid");
  InvalidRequest.haveKeyConstructedAck()
    : this("Already have received acknowledgement of constructed key");
  @override
  String toString() => message;
}

abstract interface class ApiRequestInterface {

  /// Requests to login to the group for a given [participantId]. The
  /// [groupFingerprint] is provided to check that the group configuration is
  /// correct and the same as what the server has.
  ///
  /// Returns an authentication challenge that must be signed by the
  /// participant.
  Future<ExpirableAuthChallengeResponse> login({
    required Uint8List groupFingerprint,
    required Identifier participantId,
    int protocolVersion,
  });

  /// Provides the [signedChallenge] to complete a login and returns a session
  /// id for further requests.
  Future<LoginCompleteResponse> respondToChallenge(
    Signed<AuthChallenge> signedChallenge,
  );

  /// Extends the session with the ID of [sid] and returns a new [Expiry].
  Future<Expiry> extendSession(SessionID sid);

  /// Requests the start of a new DKG process. The [NewDkgDetails] must be
  /// signed by the participant and the participant must provide their
  /// [DkgPublicCommitment]. The server will send a [NewDkgEvent] to other
  /// participants.
  Future<void> requestNewDkg({
    required SessionID sid,
    required Signed<NewDkgDetails> signedDetails,
    required DkgPublicCommitment commitment,
  });

  /// Any participant can reject and cancel the DKG with the given [name]. DKGs
  /// must be unanimous so any participant can reject it. If a DKG with the
  /// [name] does not exist, no error is thrown and this does nothing.
  Future<void> rejectDkg({
    required SessionID sid,
    required String name,
  });

  /// Submits a public [commitment] for a DKG of the given [name]. This implies
  /// that the participant aggrees to generate a new key with the [name] and
  /// shall remain online throughout the DKG process or otherwise the DKG process
  /// shall be rejected.
  ///
  /// A new commitment must be provided if the participant logs in again as the
  /// commitment will be removed if the session ends.
  ///
  /// The commitment will be shared to other participants with a
  /// [DkgCommitmentEvent].
  Future<void> submitDkgCommitment({
    required SessionID sid,
    required String name,
    required DkgPublicCommitment commitment,
  });

  /// Submits a signature of the [DkgCommitmentSet] hash so that other
  /// participants can verify that it is the same, and a list of encrypted
  /// secrets to share to other participants.
  Future<void> submitDkgRound2({
    required SessionID sid,
    required String name,
    required cl.SchnorrSignature commitmentSetSignature,
    required Map<Identifier, DkgEncryptedSecret> secrets,
  });

  /// Send a signed acknowledgement of a DKG.
  ///
  /// When the DKG process has completed, each participant should send their own
  /// [SignedDkgAck].
  ///
  /// If the server sends a [DkgAckRequestEvent], then the participant can send
  /// [SignedDkgAck]s that is owns for any participant.
  ///
  /// The server will send a [DkgAckEvent] for ACKs it doesn't already own to
  /// participants except for the caller and the signer participant.
  Future<void> sendDkgAcks({
    required SessionID sid,
    required Set<SignedDkgAck> acks,
  });

  /// Sends [DkgAckRequest]s. The server will return acknowledgements that it
  /// already has, and send [DkgAckRequestEvent]s for those it does not. A
  /// [DkgAckEvent] will be sent when and if the server receives requested
  /// [SignedDkgAck]s.
  Future<Set<SignedDkgAck>> requestDkgAcks({
    required SessionID sid,
    required Set<DkgAckRequest> requests,
  });

  /// Requests signatures from the group, providing the required
  /// [AggregateKeyInfo]s to the server and [signedDetails] of all the messages
  /// to be signed.
  Future<void> requestSignatures({
    required SessionID sid,
    required Set<AggregateKeyInfo> keys,
    required Signed<SignaturesRequestDetails> signedDetails,
    required List<SigningCommitment> commitments,
  });

  /// Rejects the request given by [reqId]. If enough participants reject, or
  /// demonstrate malicious activity so that a threshold cannot be reached, the
  /// request will fail and a [SignaturesFailureEvent] will be sent to all
  /// clients.
  Future<void> rejectSignaturesRequest({
    required SessionID sid,
    required SignaturesRequestId reqId,
  });

  /// Provides [replies] for signatures in the request corresponding to [reqId].
  ///
  /// A commitment for a signature is required initially and thereafter for each
  /// ROAST round that the participant is a member of.
  ///
  /// Returns [SignatureNewRoundsResponse] when one or more ROAST rounds are
  /// initiated and the participant should then provide the new shares for these
  /// rounds.
  ///
  /// Returns [SignaturesCompleteResponse] with all signatures when a ROAST
  /// round was completed.
  Future<SignaturesResponse?> submitSignatureReplies({
    required SessionID sid,
    required SignaturesRequestId reqId,
    required List<SignatureReply> replies,
  });

  /// Provides the participant's secret shares for a FROST key given by the
  /// public [groupKey]. The participant can share the secret to any other
  /// participants via the [encryptedSecrets] map which must be encrypted by
  /// end-to-end encryption using [EncryptedKeyShare].
  ///
  /// Logged in recipients will receive a [SecretShareEvent] immediately.
  /// Otherwise, the server shall send the event when the receipients login.
  ///
  /// A list of [ConstructedKeyEvent]s for all recipients that have already
  /// constructed the private key will be returned. The sender doesn't need to
  /// resend secrets to them unless requested by some mechanism outside of the
  /// scope of this library.
  Future<List<ConstructedKeyEvent>> shareSecretShare({
    required SessionID sid,
    required cl.ECCompressedPublicKey groupKey,
    required Map<Identifier, EncryptedKeyShare> encryptedSecrets,
  });

  /// Share that the private key for the [constructedKey] was constructed so
  /// that the server will stop sending secret shares.
  ///
  /// This must only be sent once after the key was constructed or again if
  /// the server provides further shares for the key which may happen after the
  /// server is shutdown and started again.
  ///
  /// Other participants will receive [ConstructedKeyEvent]s.
  Future<void> ackKeyConstructed({
    required SessionID sid,
    required Signed<KeyWasConstructed> constructedKey,
  });

}

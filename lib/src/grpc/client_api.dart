import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:grpc/grpc.dart' as grpc;
import 'package:frosty/frosty.dart';
import 'package:noosphere_roast_client/src/api/events.dart';
import 'package:noosphere_roast_client/src/api/request_interface.dart';
import 'package:noosphere_roast_client/src/api/responses/expirable_auth_challenge.dart';
import 'package:noosphere_roast_client/src/api/responses/login_complete.dart';
import 'package:noosphere_roast_client/src/api/responses/signatures.dart';
import 'package:noosphere_roast_client/src/api/types/dkg_ack_request.dart';
import 'package:noosphere_roast_client/src/api/types/dkg_encrypted_secret.dart';
import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/api/types/new_dkg_details.dart';
import 'package:noosphere_roast_client/src/api/types/onetime_numbers.dart';
import 'package:noosphere_roast_client/src/api/types/signature_reply.dart';
import 'package:noosphere_roast_client/src/api/types/signatures_request_details.dart';
import 'package:noosphere_roast_client/src/api/types/signed.dart';
import 'package:noosphere_roast_client/src/api/types/signed_dkg_ack.dart';
import 'generated/noosphere.pbgrpc.dart' as pb;

Uint8List _bytes(List<int> li) => Uint8List.fromList(li);

/// Provides the client API via a connection to a gRPC server. A
/// [grpc.GrpcError] may be thrown if there is an connection issue with the
/// server.
class GrpcClientApi implements ApiRequestInterface {

  static const currentProtocolVersion = 1;

  final pb.NoosphereClient _grpc;

  GrpcClientApi(grpc.ClientChannel channel)
    : _grpc = pb.NoosphereClient(channel);

  Future<T> _handleExceptions<T>(Future<T> Function() f) async {
    try {
      return await f();
    } on grpc.GrpcError catch(e) {
      if (e.code != grpc.StatusCode.unknown) rethrow;
      throw InvalidRequest(e.message ?? e.toString());
    }
  }

  @override
  Future<ExpirableAuthChallengeResponse> login({
    required Uint8List groupFingerprint,
    required Identifier participantId,
    int protocolVersion = currentProtocolVersion,
  }) => _handleExceptions(() async {

    final resp = await _grpc.login(
      pb.LoginRequest(
        groupFingerprint: groupFingerprint,
        participantId: participantId.toBytes(),
        protocolVersion: protocolVersion,
      ),
    );

    return ExpirableAuthChallengeResponse.fromBytes(_bytes(resp.data));

  });

  @override
  Future<LoginCompleteResponse> respondToChallenge(
    Signed<AuthChallenge> signedChallenge,
  ) async {

    final resp = await _grpc.respondToChallenge(
      pb.SignedAuthChallenge(
        signature: signedChallenge.signature.data,
        challenge: signedChallenge.obj.n,
      ),
    );

    // Session ID bytes are first 16 bytes. Use this to obtain stream via
    // separate gRPC method
    final stream = _grpc.fetchEventStream(
      pb.Bytes(data: resp.data.sublist(0, 16)),
    );

    // Get remaining stream, mapped to events
    final newStream = stream.map(
      (ev) {
        final bytes = _bytes(ev.data);
        return switch (ev.type) {
          pb.EventType.PARTICIPANT_STATUS_EVENT
            => ParticipantStatusEvent.fromBytes(bytes),
          pb.EventType.NEW_DKG_EVENT
            => NewDkgEvent.fromBytes(bytes),
          pb.EventType.DKG_COMMITMENT_EVENT
            => DkgCommitmentEvent.fromBytes(bytes),
          pb.EventType.DKG_REJECT_EVENT
            => DkgRejectEvent.fromBytes(bytes),
          pb.EventType.DKG_ROUND2_SHARE_EVENT
            => DkgRound2ShareEvent.fromBytes(bytes),
          pb.EventType.DKG_ACK_EVENT
            => DkgAckEvent.fromBytes(bytes),
          pb.EventType.DKG_ACK_REQUEST_EVENT
            => DkgAckRequestEvent.fromBytes(bytes),
          pb.EventType.SIG_REQ_EVENT
            => SignaturesRequestEvent.fromBytes(bytes),
          pb.EventType.SIG_NEW_ROUNDS_EVENT
            => SignatureNewRoundsEvent.fromBytes(bytes),
          pb.EventType.SIG_COMPLETE_EVENT
            => SignaturesCompleteEvent.fromBytes(bytes),
          pb.EventType.SIG_FAILURE_EVENT
            => SignaturesFailureEvent.fromBytes(bytes),
          pb.EventType.KEEPALIVE_EVENT => KeepaliveEvent(),
          _ => throw UnimplementedError(),
        };
      },
    );

    return LoginCompleteResponse.fromBytes(_bytes(resp.data), newStream);

  }

  @override
  Future<Expiry> extendSession(SessionID sid) => _handleExceptions(() async {
    final resp = await _grpc.extendSession(pb.Bytes(data: sid.n));
    return Expiry.fromBytes(_bytes(resp.data));
  });

  @override
  Future<void> requestNewDkg({
    required SessionID sid,
    required Signed<NewDkgDetails> signedDetails,
    required DkgPublicCommitment commitment,
  }) => _handleExceptions(
    () => _grpc.requestNewDkg(
      pb.DkgRequest(
        sid: sid.n,
        signedDetails: signedDetails.toBytes(),
        commitment: commitment.toBytes(),
      ),
    ),
  );

  @override
  Future<void> rejectDkg({
    required SessionID sid,
    required String name,
  }) => _handleExceptions(
    () => _grpc.rejectDkg(pb.DkgToReject(sid: sid.n, name: name)),
  );

  @override
  Future<void> submitDkgCommitment({
    required SessionID sid,
    required String name,
    required DkgPublicCommitment commitment,
  }) => _handleExceptions(
    () => _grpc.submitDkgCommitment(
      pb.DkgCommitment(
        sid: sid.n,
        name: name,
        commitment: commitment.toBytes(),
      ),
    ),
  );

  @override
  Future<void> submitDkgRound2({
    required SessionID sid,
    required String name,
    required cl.SchnorrSignature commitmentSetSignature,
    required Map<Identifier, DkgEncryptedSecret> secrets,
  }) => _handleExceptions(
    () => _grpc.submitDkgRound2(
      pb.DkgRound2(
        sid: sid.n,
        name: name,
        commitmentSetSignature: commitmentSetSignature.data,
        secrets: secrets.entries.map(
          (entry) => pb.DkgSecret(
            id: entry.key.toBytes(),
            secret: entry.value.ciphertext.toBytes(),
          ),
        ),
      ),
    ),
  );

  @override
  Future<void> sendDkgAcks({
    required SessionID sid,
    required Set<SignedDkgAck> acks,
  }) => _handleExceptions(
    () => _grpc.sendDkgAcks(
      pb.DkgAcks(
        sid: sid.n,
        acks: acks.map((ack) => ack.toBytes()),
      ),
    ),
  );

  @override
  Future<Set<SignedDkgAck>> requestDkgAcks({
    required SessionID sid,
    required Set<DkgAckRequest> requests,
  }) => _handleExceptions(() async {

    final resp = await _grpc.requestDkgAcks(
      pb.DkgAckRequest(
        sid: sid.n,
        requests: requests.map((req) => req.toBytes()),
      ),
    );

    return resp.data.map(
      (bytes) => SignedDkgAck.fromBytes(_bytes(bytes)),
    ).toSet();

  });

  @override
  Future<void> requestSignatures({
    required SessionID sid,
    required Set<AggregateKeyInfo> keys,
    required Signed<SignaturesRequestDetails> signedDetails,
    required List<SigningCommitment> commitments,
  }) => _handleExceptions(
    () => _grpc.requestSignatures(
      pb.SignaturesRequest(
        sid: sid.n,
        keys: keys.map((key) => key.toBytes()),
        signedDetails: signedDetails.toBytes(),
        commitments: commitments.map((commitment) => commitment.toBytes()),
      ),
    ),
  );

  @override
  Future<void> rejectSignaturesRequest({
    required SessionID sid,
    required SignaturesRequestId reqId,
  }) => _handleExceptions(
    () => _grpc.rejectSignaturesRequest(
      pb.SignaturesRejection(
        sid: sid.n,
        reqId: reqId.toBytes(),
      ),
    ),
  );

  @override
  Future<SignaturesResponse?> submitSignatureReplies({
    required SessionID sid,
    required SignaturesRequestId reqId,
    required List<SignatureReply> replies,
  }) => _handleExceptions(() async {

    final resp = await _grpc.submitSignatureReplies(
      pb.SignaturesReplies(
        sid: sid.n,
        reqId: reqId.toBytes(),
        replies: replies.map((reply) => reply.toBytes()),
      ),
    );

    return switch (resp.type) {
      pb.SignaturesResponseType.SIGNATURES_RESPONSE_NEW_ROUND
        => SignatureNewRoundsResponse.fromBytes(_bytes(resp.data)),
      pb.SignaturesResponseType.SIGNATURES_RESPONSE_COMPLETE
        => SignaturesCompleteResponse.fromBytes(_bytes(resp.data)),
      _ => null,
    };

  });

}

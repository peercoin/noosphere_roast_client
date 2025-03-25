import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/api/types/new_dkg_details.dart';
import 'package:noosphere_roast_client/src/api/types/signatures_request_details.dart';
import 'package:noosphere_roast_client/src/client/dkg_in_progress.dart';
import 'package:frosty/frosty.dart';
import 'client.dart';
import 'signatures_request.dart';

enum DkgFault {
  /// Rejected without fault
  none,
  /// A provided proof-of-knowledge for a commitment was invalid.
  proofOfKnowledge,
  /// The ciphertext for a secret could not be decrypted
  secretCiphertext,
  /// A secret did not conform to a commitment.
  secret,
  /// The DKG expired
  expired,
}

/// Events that are specific to the high-level [Client] class.
sealed class ClientEvent {}

/// Provided when a participant logs in or logs out.
class ParticipantStatusClientEvent extends ClientEvent {
  final Identifier id;
  final bool loggedIn;
  ParticipantStatusClientEvent({ required this.id, required this.loggedIn });
}

/// Provided when a DKG has updated its progress or when there is a new DKG
/// request. The DKG may have been replaced.
class UpdatedDkgClientEvent extends ClientEvent {
  final DkgInProgress progress;
  UpdatedDkgClientEvent(this.progress);
}

/// When a DKG has been rejected and therefore removed. The DKG [details] are
/// provided as the DKG is removed from the [Client] object.
///
/// If [participant] is not null, this is the participant that supposedly
/// requested the rejection or misbehaved as according to the server. The server
/// could lie about this.
class RejectedDkgClientEvent extends ClientEvent {
  final NewDkgDetails details;
  final Identifier? participant;
  final DkgFault fault;
  RejectedDkgClientEvent({
    required this.details,
    required this.participant,
    this.fault = DkgFault.none,
  });
}

/// Provided when there is a new signatures [request].
class SignaturesRequestClientEvent extends ClientEvent {
  final SignaturesRequest request;
  SignaturesRequestClientEvent(this.request);
}

/// Provided when the signatures [request] has failed.
class SignaturesFailureClientEvent extends ClientEvent {
  /// The request that has failed and has been removed.
  final SignaturesRequest request;
  SignaturesFailureClientEvent(this.request);
}

/// Provided when the signatures [request] has expired.
class SignaturesExpiryClientEvent extends ClientEvent {
  /// The request that has expired and has been removed.
  final SignaturesRequest request;
  SignaturesExpiryClientEvent(this.request);
}

/// Provided when a signatures request was completed sucessfully. This will be
/// provided upon login for signatures the client may have missed.
class SignaturesCompleteClientEvent extends ClientEvent {
  /// Details of the signatures request that have been completed
  final SignaturesRequestDetails details;
  /// The creator of the signatures request
  final Identifier creator;
  /// All of the completed signatures
  final List<cl.SchnorrSignature> signatures;
  SignaturesCompleteClientEvent({
    required this.details,
    required this.creator,
    required this.signatures,
  });
}

import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/api/types/signatures_request_details.dart';
import 'package:noosphere_roast_client/src/api/types/signed.dart';
import 'package:noosphere_roast_client/src/common/serial.dart';
import 'package:frosty/frosty.dart';
import 'package:noosphere_roast_client/src/api/events.dart';
import 'package:noosphere_roast_client/src/api/types/expirable.dart';
import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/api/types/onetime_numbers.dart';

/// Provides details of completed signatures upon login
class CompletedSignaturesRequest with cl.Writable {

  final Signed<SignaturesRequestDetails> details;
  final List<cl.SchnorrSignature> signatures;
  final Identifier creator;
  CompletedSignaturesRequest({
    required this.details,
    required this.signatures,
    required this.creator,
  });

  CompletedSignaturesRequest.fromReader(cl.BytesReader reader) : this(
    details: Signed.fromReader(
      reader, () => SignaturesRequestDetails.fromReader(reader),
    ),
    signatures: reader.readSignatureVector(),
    creator: reader.readIdentifier(),
  );
  CompletedSignaturesRequest.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    details.write(writer);
    writer.writeSignatureVector(signatures);
    writer.writeIdentifier(creator);
  }

}

/// Provides the participant with a [SessionID] and information about the
/// current state of signing and DKG requests.
///
/// [write()] and [toBytes()] does not include any streamed events and the
/// stream must be provided when constructing from bytes.
class LoginCompleteResponse with cl.Writable implements Expirable {

  /// The session id required to communicate with authenticated methods
  final SessionID id;
  @override
  /// The expiry of the session. The session has to be extended before this or
  /// the session will be removed from the server.
  final Expiry expiry;
  /// The participants who are currently online
  final Set<Identifier> onlineParticipants;
  /// Outstanding new DKG requests that require a commitment and all commitments
  /// that have been received by online participants.
  final List<NewDkgEvent> newDkgs;
  /// Current signature requests that require a commitment
  final List<SignaturesRequestEvent> sigRequests;
  /// Details of ROAST rounds that the server is waiting on. The signing nonces
  /// must be stored between sessions so that a participant can proceed with a
  /// round.
  final List<SignatureNewRoundsEvent> sigRounds;
  /// Completed signatures that the participant may not have received whilst
  /// logged out
  final List<CompletedSignaturesRequest> completedSigs;
  /// A stream of events of type [Event] that the client should listen to for
  /// this session. The client must listen to this stream as soon as it is
  /// provided to ensure no events are missed.
  final Stream<Event> events;

  LoginCompleteResponse({
    required this.id,
    required this.expiry,
    required this.onlineParticipants,
    required this.newDkgs,
    required this.sigRequests,
    required this.sigRounds,
    required this.completedSigs,
    required this.events,
  });

  LoginCompleteResponse.fromReader(cl.BytesReader reader, Stream<Event> events)
    : this(
      id: SessionID.fromReader(reader),
      expiry: Expiry.fromReader(reader),
      onlineParticipants: reader.readIdentifierVector().toSet(),
      newDkgs: reader.readWritableVector(
        (bytes) => NewDkgEvent.fromBytes(bytes),
      ),
      sigRequests: reader.readWritableVector(
        (bytes) => SignaturesRequestEvent.fromBytes(bytes),
      ),
      sigRounds: reader.readWritableVector(
        (bytes) => SignatureNewRoundsEvent.fromBytes(bytes),
      ),
      completedSigs: reader.readWritableVector(
        (bytes) => CompletedSignaturesRequest.fromBytes(bytes),
      ),
      events: events,
    );

  LoginCompleteResponse.fromBytes(Uint8List bytes, Stream<Event> events)
    : this.fromReader(cl.BytesReader(bytes), events);

  @override
  void write(cl.Writer writer) {

    id.write(writer);
    expiry.write(writer);
    writer.writeIdentifierVector(onlineParticipants);

    for (final evList in [newDkgs, sigRequests, sigRounds, completedSigs]) {
      writer.writeWritableVector(evList);
    }

  }

}

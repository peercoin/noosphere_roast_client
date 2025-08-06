import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';
import 'package:noosphere_roast_client/src/api/types/key_was_constructed.dart';
import 'package:noosphere_roast_client/src/common/errors.dart';
import 'package:noosphere_roast_client/src/common/serial.dart';
import 'request_interface.dart';
import 'types/dkg_ack_request.dart';
import 'types/dkg_encrypted_secret.dart';
import 'types/encrypted_key_share.dart';
import 'types/expiry.dart';
import 'types/new_dkg_details.dart';
import 'types/signature_round_start.dart';
import 'types/signatures_request_details.dart';
import 'types/signed.dart';
import 'types/signed_dkg_ack.dart';

sealed class Event with cl.Writable {}

/// Gives an event when a participant logs in or logs out.
///
/// If a participant logs out, then all round 2 DKGs will be reset to round 1
/// without any commitments. Round 1 DKGs will have any commitments for the
/// participant removed.
class ParticipantStatusEvent extends Event {

  final Identifier id;
  final bool loggedIn;
  ParticipantStatusEvent({ required this.id, required this.loggedIn });

  ParticipantStatusEvent.fromReader(cl.BytesReader reader) : this(
    id: reader.readIdentifier(),
    loggedIn: reader.readBool(),
  );
  ParticipantStatusEvent.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writeIdentifier(id);
    writer.writeBool(loggedIn);
  }

}

abstract interface class DetailsEvent<T extends Signable> {
  Signed<T> get details;
  Expiry get expiry;
  Identifier get creator;
}

/// Signed details of a new DKG and the [Identifier] of the creator that signed
/// the details. Participants should send their public commitments if they
/// approve of the DKG or call [ApiRequestInterface.rejectDkg].
class NewDkgEvent extends Event implements DetailsEvent {

  @override
  final Signed<NewDkgDetails> details;
  @override
  Expiry get expiry => details.obj.expiry;
  @override
  final Identifier creator;
  /// Commitments already received for this DKG.
  final DkgCommitmentList commitments;

  NewDkgEvent({
    required this.details,
    required this.creator,
    required DkgCommitmentList commitments,
  }) : commitments = List.unmodifiable(commitments);

  NewDkgEvent.fromReader(cl.BytesReader reader) : this(
    details: Signed.fromReader(reader, () => NewDkgDetails.fromReader(reader)),
    creator: reader.readIdentifier(),
    commitments: List.generate(
      reader.readUInt16(),
      (_) => (
        reader.readIdentifier(),
        DkgPublicCommitment.fromBytes(reader.readVarSlice()),
      ),
    ),
  );
  NewDkgEvent.fromBytes(Uint8List bytes) : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {

    details.write(writer);
    writer.writeIdentifier(creator);

    writer.writeUInt16(commitments.length);
    for (final commitment in commitments) {
      writer.writeIdentifier(commitment.$1);
      writer.writeVarSlice(commitment.$2.toBytes());
    }

  }

}

/// A [commitment] from the [participant] for the DKG given by [name]. When all
/// of these have been received, a [DkgCommitmentSet] can be generated and round
/// 2 can be commenced.
class DkgCommitmentEvent extends Event {

  final String name;
  final Identifier participant;
  final DkgPublicCommitment commitment;

  DkgCommitmentEvent({
    required this.name,
    required this.participant,
    required this.commitment,
  });
  DkgCommitmentEvent.fromReader(cl.BytesReader reader) : this(
    name: reader.readString(),
    participant: reader.readIdentifier(),
    commitment: DkgPublicCommitment.fromBytes(reader.readVarSlice()),
  );
  DkgCommitmentEvent.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writeString(name);
    writer.writeIdentifier(participant);
    writer.writeVarSlice(commitment.toBytes());
  }

}

/// Event given when a [participant] rejects a DKG.
///
/// DKGs after the first round will also be rejected when a participant logs out
/// alongside a [ParticipantStatusEvent] without this event being given.
class DkgRejectEvent extends Event {

  final String name;
  final Identifier participant;
  DkgRejectEvent({ required this.name, required this.participant });
  DkgRejectEvent.fromReader(cl.BytesReader reader) : this(
    name: reader.readString(),
    participant: reader.readIdentifier(),
  );
  DkgRejectEvent.fromBytes(Uint8List bytes) : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writeString(name);
    writer.writeIdentifier(participant);
  }

}

/// The data from a given participant for the second round of the DKG.
class DkgRound2ShareEvent extends Event {

  final String name;
  final cl.SchnorrSignature commitmentSetSignature;
  final Identifier sender;
  final DkgEncryptedSecret secret;

  DkgRound2ShareEvent({
    required this.name,
    required this.commitmentSetSignature,
    required this.sender,
    required this.secret,
  });
  DkgRound2ShareEvent.fromReader(cl.BytesReader reader) : this(
    name: reader.readString(),
    commitmentSetSignature: reader.readSignature(),
    sender: reader.readIdentifier(),
    secret: DkgEncryptedSecret(ECCiphertext.fromReader(reader)),
  );
  DkgRound2ShareEvent.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writeString(name);
    writer.writeSignature(commitmentSetSignature);
    writer.writeIdentifier(sender);
    secret.ciphertext.write(writer);
  }

}

/// Sent when a participant has provided one or more [SignedDkgAck]s.
class DkgAckEvent extends Event {

  final Set<SignedDkgAck> acks;
  DkgAckEvent(this.acks) {
    checkNotEmpty(acks, "acks");
  }
  DkgAckEvent.fromReader(cl.BytesReader reader) : this(
    reader.readWritableVector((bytes) => SignedDkgAck.fromBytes(bytes)).toSet(),
  );
  DkgAckEvent.fromBytes(Uint8List bytes) : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writeWritableVector(acks);
  }

}

/// Sent when the server asks for the [SignedDkgAck] of participants by a
/// [DkgAckRequest] for one or more keys. If the receiver owns one or more of
/// these ACKs, they should be provided to the server via
/// [ApiRequestInterface.sendDkgAcks].
class DkgAckRequestEvent extends Event {

  final Set<DkgAckRequest> requests;
  DkgAckRequestEvent(this.requests) {
    checkNotEmpty(requests, "requests");
  }
  DkgAckRequestEvent.fromReader(cl.BytesReader reader) : this(
    reader.readWritableVector(
      (bytes) => DkgAckRequest.fromBytes(bytes),
    ).toSet(),
  );
  DkgAckRequestEvent.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writeWritableVector(requests);
  }

}

/// Sent when there is a new request for a signature.
class SignaturesRequestEvent extends Event implements DetailsEvent {

  @override
  final Signed<SignaturesRequestDetails> details;
  @override
  Expiry get expiry => details.obj.expiry;
  @override
  final Identifier creator;
  SignaturesRequestEvent({ required this.details, required this.creator });

  SignaturesRequestEvent.fromReader(cl.BytesReader reader) : this(
    details: Signed.fromReader(
      reader, () => SignaturesRequestDetails.fromReader(reader),
    ),
    creator: reader.readIdentifier(),
  );
  SignaturesRequestEvent.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    details.write(writer);
    writer.writeIdentifier(creator);
  }

}

/// Provides the [SigningCommitmentSet]s when new ROAST rounds are initiated.
class SignatureNewRoundsEvent extends Event {

  final SignaturesRequestId reqId;
  final List<SignatureRoundStart> rounds;

  SignatureNewRoundsEvent({
    required this.reqId,
    required this.rounds,
  });

  SignatureNewRoundsEvent.fromReader(cl.BytesReader reader) : this(
    reqId: SignaturesRequestId.fromReader(reader),
    rounds: reader.readWritableVector((b) => SignatureRoundStart.fromBytes(b)),
  );
  SignatureNewRoundsEvent.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    reqId.write(writer);
    writer.writeWritableVector(rounds);
  }

}

/// Provides the final signatures for a request once ROAST has completed for all
/// of them.
class SignaturesCompleteEvent extends Event {

  final SignaturesRequestId reqId;
  final List<cl.SchnorrSignature> signatures;
  SignaturesCompleteEvent({
    required this.reqId,
    required this.signatures,
  });

  SignaturesCompleteEvent.fromReader(cl.BytesReader reader) : this(
    reqId: SignaturesRequestId.fromReader(reader),
    signatures: reader.readSignatureVector(),
  );
  SignaturesCompleteEvent.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    reqId.write(writer);
    writer.writeSignatureVector(signatures);
  }

}

/// Produced when there are not enough signers to complete the signatures
/// request due to rejections or malicious signers.
class SignaturesFailureEvent extends Event {

  final SignaturesRequestId reqId;
  SignaturesFailureEvent(this.reqId);

  SignaturesFailureEvent.fromReader(cl.BytesReader reader) : this(
    SignaturesRequestId.fromReader(reader),
  );
  SignaturesFailureEvent.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    reqId.write(writer);
  }

}

/// Provided when a [sender] sends an encrypted [keyShare] for a FROST
/// [groupKey].
class SecretShareEvent extends Event {

  final Identifier sender;
  final EncryptedKeyShare keyShare;
  final cl.ECCompressedPublicKey groupKey;

  SecretShareEvent({
    required this.sender,
    required this.keyShare,
    required this.groupKey,
  });
  SecretShareEvent.fromReader(cl.BytesReader reader) : this(
    sender: reader.readIdentifier(),
    keyShare: EncryptedKeyShare(ECCiphertext.fromReader(reader)),
    groupKey: reader.readPubKey(),
  );
  SecretShareEvent.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writeIdentifier(sender);
    keyShare.ciphertext.write(writer);
    writer.writePubKey(groupKey);
  }

}

/// Provided when a [participant] claims to have constructed the private key for
/// a FROST key given by [constructedKey]. The receiver should no longer share
/// the secret-share for this key to this [participant].
///
/// If a participant claims to have constructed the private key, it doesn't
/// prove that it has.
class ConstructedKeyEvent extends Event {

  final Identifier participant;
  final Signed<KeyWasConstructed> constructedKey;

  ConstructedKeyEvent({
    required this.participant,
    required this.constructedKey,
  });
  ConstructedKeyEvent.fromReader(cl.BytesReader reader) : this(
    participant: reader.readIdentifier(),
    constructedKey: Signed.fromReader(
      reader, () => KeyWasConstructed.fromReader(reader),
    ),
  );
  ConstructedKeyEvent.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writeIdentifier(participant);
    constructedKey.write(writer);
  }

}

/// The only purpose of this event is to keep middleware alive, that may
/// otherwise close in the absence of frequent events.
class KeepaliveEvent extends Event {
  @override
  void write(cl.Writer writer) {}
}

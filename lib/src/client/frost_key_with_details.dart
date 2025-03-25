import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/api/types/dkg_ack.dart';
import 'package:noosphere_roast_client/src/api/types/signed.dart';
import 'package:noosphere_roast_client/src/api/types/signed_dkg_ack.dart';
import 'package:noosphere_roast_client/src/common/serial.dart';
import 'package:frosty/frosty.dart';

class FrostKeyWithDetails with cl.Writable {

  final ParticipantKeyInfo keyInfo;
  final String name;
  final String description;
  final Set<SignedDkgAck> acks;

  FrostKeyWithDetails({
    required this.keyInfo,
    required this.name,
    required this.description,
    required Set<SignedDkgAck> acks,
  }) : acks = Set.unmodifiable(acks);

  factory FrostKeyWithDetails.fromReader(cl.BytesReader reader) {

    final keyInfo = ParticipantKeyInfo.fromReader(reader);

    return FrostKeyWithDetails(

      keyInfo: keyInfo,
      name: reader.readString(),
      description: reader.readString(),

      // Read ACKs, reusing the group key that was already read to keyInfo
      acks: Iterable.generate(
        reader.readUInt16(),
        (i) => SignedDkgAck(
          signer: reader.readIdentifier(),
          signed: Signed(
            obj: DkgAck(
              groupKey: keyInfo.groupKey,
              accepted: reader.readBool(),
            ),
            signature: reader.readSignature(),
          ),
        ),
      ).toSet(),

    );

  }

  /// Convenience constructor to construct from serialised [bytes].
  factory FrostKeyWithDetails.fromBytes(Uint8List bytes)
    => FrostKeyWithDetails.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  factory FrostKeyWithDetails.fromHex(String hex)
    => FrostKeyWithDetails.fromBytes(cl.hexToBytes(hex));

  @override
  /// Equality applies to the group key only.
  bool operator==(Object other) => identical(this, other) || (
    other is FrostKeyWithDetails && groupKey == other.groupKey
  );

  @override
  int get hashCode => keyInfo.groupKey.hashCode;

  cl.ECCompressedPublicKey get groupKey => keyInfo.groupKey;

  @override
  void write(cl.Writer writer) {

    keyInfo.write(writer);
    writer.writeString(name);
    writer.writeString(description);

    // Write ACKs without including the group key as that is already included
    writer.writeUInt16(acks.length);
    for (final ack in acks) {
      writer.writeSlice(ack.signer.toBytes());
      writer.writeBool(ack.signed.obj.accepted);
      writer.writeSignature(ack.signed.signature);
    }

  }

  int get acceptedAcks => acks.where((ack) => ack.signed.obj.accepted).length;

}

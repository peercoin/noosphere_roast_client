import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/api/types/dkg_ack.dart';
import 'package:noosphere_roast_client/src/api/types/signed.dart';
import 'package:noosphere_roast_client/src/api/types/signed_dkg_ack.dart';
import 'package:noosphere_roast_client/src/common/serial.dart';
import 'package:frosty/frosty.dart';
import 'key_construction.dart';

class FrostKeyWithDetails with cl.Writable {

  final ParticipantKeyInfo keyInfo;
  final String name;
  final String description;
  final Set<SignedDkgAck> acks;

  /// A map of participant identifiers that are having the secret shared to.
  /// This maps to the last time the secret was shared. If a participant's
  /// identifier is not in this map, then the secret is not being shared with
  /// them.
  final Map<Identifier, DateTime> secretShareTimes;

  /// Identifiers of participants that have claimed to have constructed the
  /// underlying private key
  final Set<Identifier> claimedToHave;

  /// Information for constructing the underlying private key from shared
  /// secrets.
  final KeyConstruction keyConstruction;

  FrostKeyWithDetails._({
    required this.keyInfo,
    required this.name,
    required this.description,
    required Set<SignedDkgAck> acks,
    required Map<Identifier, DateTime> secretShareTimes,
    required Set<Identifier> claimedToHave,
    required this.keyConstruction,
  }) : acks = Set.unmodifiable(acks),
    secretShareTimes = Map.unmodifiable(secretShareTimes),
    claimedToHave = Set.unmodifiable(claimedToHave);

  FrostKeyWithDetails({
    required ParticipantKeyInfo keyInfo,
    required String name,
    required String description,
  }) : this._(
    keyInfo: keyInfo,
    name: name,
    description: description,
    acks: {},
    secretShareTimes: {},
    claimedToHave: {},
    keyConstruction: KeyConstructionProgress(),
  );

  factory FrostKeyWithDetails.fromReader(cl.BytesReader reader) {

    final keyInfo = ParticipantKeyInfo.fromReader(reader);

    return FrostKeyWithDetails._(

      keyInfo: keyInfo,
      name: reader.readString(),
      description: reader.readString(),

      // Read ACKs, reusing the group key that was already read to keyInfo
      acks: Iterable.generate(
        reader.readUInt16(),
        (_) => SignedDkgAck(
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

      secretShareTimes: reader.readMap(
        () => reader.readIdentifier(),
        () => reader.readTime(),
      ),

      claimedToHave: reader.readIdentifierVector().toSet(),

      keyConstruction: reader.readBool()
        ? KeyConstructionProgress.fromReader(reader)
        : KeyConstructionComplete.fromReader(reader),

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

    writer.writeMap(
      secretShareTimes,
      (id) => writer.writeIdentifier(id),
      (time) => writer.writeTime(time),
    );

    writer.writeIdentifierVector(claimedToHave);

    writer.writeBool(keyConstruction is KeyConstructionProgress);
    keyConstruction.write(writer);

  }

  FrostKeyWithDetails _mutate({
    Set<SignedDkgAck>? acks,
    Map<Identifier, DateTime>? secretShareTimes,
    Set<Identifier>? claimedToHave,
    KeyConstruction? keyConstruction,
  }) => FrostKeyWithDetails._(
    keyInfo: keyInfo,
    name: name,
    description: description,
    acks: acks ?? this.acks,
    secretShareTimes: secretShareTimes ?? this.secretShareTimes,
    claimedToHave: claimedToHave ?? this.claimedToHave,
    keyConstruction: keyConstruction ?? this.keyConstruction,
  );

  FrostKeyWithDetails addOrReplaceAck(SignedDkgAck ack) => _mutate(
    acks: { ...acks.where((other) => other != ack), ack },
  );

  FrostKeyWithDetails addOrReplaceSecretShareTimes(
    Set<Identifier> participants, DateTime time,
  ) => _mutate(
    secretShareTimes: {
      ...secretShareTimes,
      for (final id in participants) id: time,
    },
  );

  FrostKeyWithDetails addClaimedToHave(Identifier participant) => _mutate(
    claimedToHave: { ...claimedToHave, participant },
  );

  /// Will return null if the secret share is invalid
  FrostKeyWithDetails? addSecretShare(
    Identifier participant,
    cl.ECPrivateKey secret,
  ) {
    final construction = keyConstruction.addSecret(
      participant, secret, keyInfo,
    );
    return construction == null ? null : _mutate(keyConstruction: construction);
  }

  int get acceptedAcks => acks.where((ack) => ack.signed.obj.accepted).length;

}

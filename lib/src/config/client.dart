import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';
import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/common/serial.dart';
import 'group.dart';
import 'map_serial.dart';

/// The reason the private key is being requested
enum KeyPurpose {
  login, dkgDetails, dkgPart2, decryptDkgSecret, signAck, signaturesDetails,
}

class ClientConfig with cl.Writable, MapWritable {

  static const defaultMinDkgRequestTTL = Duration(minutes: 30);
  static const defaultMaxDkgRequestTTL = Duration(days: 7);
  static const defaultMinSignaturesTTL = Duration(seconds: 30);
  static const defaultMaxSignaturesTTL = Duration(days: 14);

  final GroupConfig group;
  final Identifier id;
  final Duration minDkgRequestTTL, maxDkgRequestTTL,
    minSignaturesTTL, maxSignaturesTTL;

  ClientConfig({
    required this.group,
    required this.id,
    this.minDkgRequestTTL = defaultMinDkgRequestTTL,
    this.maxDkgRequestTTL = defaultMaxDkgRequestTTL,
    this.minSignaturesTTL = defaultMinSignaturesTTL,
    this.maxSignaturesTTL = defaultMaxSignaturesTTL,
  }) {
    if (!group.participants.keys.contains(id)) {
      throw ArgumentError.value(id, "id", "client ID not in group");
    }
  }

  ClientConfig.fromReader(cl.BytesReader reader) : this(
    group: GroupConfig.fromReader(reader),
    id: reader.readIdentifier(),
    maxDkgRequestTTL: reader.readDuration(),
  );

  /// Convenience constructor to construct from serialised [bytes].
  ClientConfig.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  ClientConfig.fromHex(String hex) : this.fromBytes(cl.hexToBytes(hex));

  ClientConfig.fromMapReader(MapReader reader) : this(
    id: Identifier.fromHex(reader["id"].require()),
    group: GroupConfig.fromMapReader(reader["group"]),
    minDkgRequestTTL: reader.getTTL("min-dkg-request")
      ?? defaultMinDkgRequestTTL,
    maxDkgRequestTTL: reader.getTTL("max-dkg-request")
      ?? defaultMaxDkgRequestTTL,
    minSignaturesTTL: reader.getTTL("min-signatures")
      ?? defaultMinSignaturesTTL,
    maxSignaturesTTL: reader.getTTL("max-signatures")
      ?? defaultMaxSignaturesTTL,
  );

  ClientConfig.fromYaml(String yaml)
    : this.fromMapReader(MapReader.fromYaml(yaml));

  @override
  void write(cl.Writer writer) {
    group.write(writer);
    writer.writeIdentifier(id);
    writer.writeDuration(maxDkgRequestTTL);
  }

  bool dkgExpiryAcceptable(Expiry expiry)
    => expiry.ttl.compareTo(minDkgRequestTTL) >= 0
    && expiry.ttl.compareTo(maxDkgRequestTTL) <= 0;

  bool signaturesExpiryAcceptable(Expiry expiry)
    => expiry.ttl.compareTo(minSignaturesTTL) >= 0
    && expiry.ttl.compareTo(maxSignaturesTTL) <= 0;

  Map<Identifier, cl.ECPublicKey> get others => {
    for (final entry in group.participants.entries)
      if (entry.key != id) entry.key: entry.value,
  };
  Set<Identifier> get otherIds => others.keys.toSet();
  Set<Identifier> get allIds => group.participants.keys.toSet();
  int get groupN => group.participants.length;

  @override
  Map<Object, Object> map() => {
    "id": id.toString(),
    "ms-lifetimes": {
      "min-dkg-request": minDkgRequestTTL.inMilliseconds,
      "max-dkg-request": maxDkgRequestTTL.inMilliseconds,
      "min-signatures": minSignaturesTTL.inMilliseconds,
      "max-signatures": maxSignaturesTTL.inMilliseconds,
    },
    "group": group.map(),
  };

}

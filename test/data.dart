import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/noosphere_roast_client.dart';

final ids = List.generate(10, (i) => Identifier.fromUint16(i+1));

final _basePrivkey = cl.ECPrivateKey(Uint8List(32)..last = 1);
Uint8List _getScalar(int i) => Uint8List(32)..last = i+1;
cl.ECPrivateKey getPrivkey(int i) => _basePrivkey.tweak(_getScalar(i))!;

final groupConfig = GroupConfig(
  id: "TestGroup",
  participants: {
    for (int i = 0; i < 10; i++)
      ids[i]: cl.ECCompressedPublicKey.fromPubkey(
        _basePrivkey.pubkey.tweak(_getScalar(i))!,
      ),
  },
);

final futureExpiry = Expiry(Duration(days: 1));

NewDkgDetails getDkgDetails({
  String name = "123",
  String description = "",
  int threshold = 2,
  Expiry? expiry,
}) => NewDkgDetails.allowNegativeExpiry(
  name: name,
  description: description,
  threshold: threshold,
  expiry: expiry ?? futureExpiry,
);

ClientConfig getClientConfig(int i) => ClientConfig(
  id: ids[i],
  group: groupConfig,
);

final expiryBytes = [0, 0, 0xdc, 0xc2, 0x08, 0xb2, 0x1e, 0];
final expiryTimestamp = 8640000000000000;
final dummyHash = Uint8List(32)..last = 1;

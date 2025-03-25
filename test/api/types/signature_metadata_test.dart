import 'package:coinlib/coinlib.dart' as cl;
import 'package:test/test.dart';
import 'package:noosphere_roast_client/noosphere_roast_client.dart';

void main() {
  group("SignatureMetadata", () {

    setUpAll(loadFrosty);

    test("EmptySignatureMetadata", () {
      final hex = "00";
      final obj = SignatureMetadata.fromHex(hex) as EmptySignatureMetadata;
      expect(obj.type, 0);
      expect(obj.toHex(), hex);
    });

    test("UnknownSignatureMetadata", () {
      final hex = "ff01020304";
      final obj = SignatureMetadata.fromHex(hex) as UnknownSignatureMetadata;
      expect(obj.type, 0xff);
      expect(cl.bytesToHex(obj.data), "01020304");
      expect(obj.toHex(), hex);
    });

  });
}

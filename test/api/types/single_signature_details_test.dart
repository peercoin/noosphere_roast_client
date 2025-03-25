import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:test/test.dart';
import 'package:noosphere_roast_client/noosphere_roast_client.dart';
import '../../test_keys.dart';

void main() {
  group("SingleSignatureDetails", () {

    setUpAll(loadFrosty);

    final il32 = List<int>.filled(32, 0);

    test("can read/write", () {
      final bytes = [
        ...il32, 0,
        ...groupPublicKey.data,
        5,
        1,0,0,0,
        2,0,0,0,
        3,0,0,0,
        4,0,0,0,
        0xff,0xff,0xff,0x7f,
      ];
      final obj = SingleSignatureDetails.fromBytes(Uint8List.fromList(bytes));
      expect(obj.toBytes(), bytes);
      expect(obj.hdDerivation, [1,2,3,4,0x7fffffff]);
      expect(obj.groupKey, groupPublicKey);
    });

    SingleSignatureDetails getDetails({
      SignDetails? sd,
      cl.ECCompressedPublicKey? pk,
      List<int>? derivation,
    }) => SingleSignatureDetails(
      signDetails: sd ?? SignDetails.keySpend(message: Uint8List(32)),
      groupKey: pk ?? groupPublicKey,
      hdDerivation: derivation ?? [],
    );

    test("are unique", () {

      final v1 = getDetails();
      final v2 = getDetails(
        sd: SignDetails.keySpend(message: Uint8List(32)..last = 1),
      );
      final v3 = getDetails(
        pk: groupPublicKey.tweak(Uint8List(32)..last = 1),
      );
      final v4 = getDetails(derivation: [1, 2]);
      final v5 = getDetails(derivation: [1, 3]);

      expect({ v1, v2, v3, v4, v5, v1, v2, v3, v4, v5 }, hasLength(5));

    });

    test("fails on invalid derivation", () {
      for (final bad in [[-1], [0x80000000], List.filled(0x100, 0)]) {
        expect(() => getDetails(derivation: bad), throwsRangeError);
      }
    });

  });
}

import 'dart:typed_data';
import 'package:test/test.dart';
import 'package:noosphere_roast_client/noosphere_roast_client.dart';
import '../../data.dart';
import '../../test_keys.dart';

void main() {
  group("SignaturesRequestDetails", () {

    setUpAll(loadFrosty);

    final il32 = List<int>.filled(32, 0);

    test("can read/write", () {

      final bytes = [
        2, 0,
        ...il32, 0,
        ...groupPublicKey.data,
        0,
        ...il32, 1,
        ...groupPublicKey.data,
        0,
        0,
        ...expiryBytes,
      ];

      final obj = SignaturesRequestDetails.fromBytes(Uint8List.fromList(bytes));
      expect(obj.toBytes(), bytes);
      expect(obj.requiredSigs, hasLength(2));
      expect(obj.metadata, isA<EmptySignatureMetadata>());
      expect(obj.expiry.time.millisecondsSinceEpoch, expiryTimestamp);

    });

    test("invalid details", () {

      SingleSignatureDetails getSingleSig() => SingleSignatureDetails(
        signDetails: SignDetails.scriptSpend(message: Uint8List(32)),
        groupKey: groupPublicKey,
        hdDerivation: [],
      );

      void expectInvalid({
        List<SingleSignatureDetails>? sigs,
        Expiry? expiry,
      }) => expect(
        () => SignaturesRequestDetails(
          requiredSigs: sigs ?? [getSingleSig()],
          expiry: expiry ?? Expiry(Duration(days: 1)),
        ),
        throwsArgumentError,
      );

      // Duplicate sig
      expectInvalid(sigs: [getSingleSig(), getSingleSig()]);

      // No sigs
      expectInvalid(sigs: []);

      // Expired
      expectInvalid(expiry: Expiry(Duration(days: -1)));

    });

  });
}

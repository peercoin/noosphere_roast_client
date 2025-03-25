import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/noosphere_roast_client.dart';
import 'package:test/test.dart';
import '../../data.dart';

List<int> genRepeatUtf8(int n) => List.generate(n, (i) => 48+(i % 10));

Uint8List validBytes = Uint8List.fromList([
  // Name
  40, ...genRepeatUtf8(40),
  // Description
  0xfd, 0xe8, 0x03, ...genRepeatUtf8(1000),
  // Threshold
  2, 0,
  // Expiry
  ...expiryBytes,
]);

void main() {
  group("NewDkgDetails", () {

    setUpAll(loadFrosty);

    test("invalid details", () {

      void expectInvalid({
        String name = "123",
        String description = "",
        int threshold = 2,
        Expiry? expiry,
      }) => expect(
        () => NewDkgDetails(
          name: name,
          description: description,
          threshold: threshold,
          expiry: expiry ?? futureExpiry,
        ),
        throwsArgumentError,
      );

      expectInvalid(name: "12");
      expectInvalid(name: "01234567890123456789012345678901234567890");
      expectInvalid(
        description: String.fromCharCodes(
          List.generate(1001, (i) => 0x30),
        ),
      );
      expectInvalid(threshold: 1);
      expectInvalid(threshold: 0x10000);
      expectInvalid(expiry: Expiry(Duration(seconds: -1)));

    });

    test("can be read and written", () {

      final details = NewDkgDetails.fromReader(
        cl.BytesReader(
          NewDkgDetails.fromReader(
            cl.BytesReader(validBytes),
          ).toBytes(),
        ),
      );

      expect(details.name, "0123456789012345678901234567890123456789");
      expect(
        details.description,
        Iterable.generate(100, (_) => "0123456789").join(),
      );
      expect(details.threshold, 2);
      expect(details.expiry.time.millisecondsSinceEpoch, expiryTimestamp);

    });

    test("can be signed and verified", () {

      final privkey = getPrivkey(1);
      final details = getDkgDetails();

      final signed = Signed.sign(obj: details, key: privkey);
      expect(signed.verify(privkey.pubkey), true);
      expect(signed.verify(getPrivkey(2).pubkey), false);

      // If any details change it should be invalid
      void expectInvalidSig(NewDkgDetails details) => expect(
        Signed(
          obj: details,
          signature: signed.signature,
        ).verify(privkey.pubkey),
        false,
      );
      expectInvalidSig(getDkgDetails(name: "1234"));
      expectInvalidSig(getDkgDetails(description: "1"));
      expectInvalidSig(getDkgDetails(threshold: 3));
      expectInvalidSig(getDkgDetails(expiry: Expiry(Duration(minutes: 2))));

    });

  });
}

import 'package:noosphere_roast_client/noosphere_roast_client.dart';
import 'package:test/test.dart';
import '../data.dart';
import '../test_keys.dart';

final keyWithDetailsHex
  = "$keyInfoHex"
  // "Test Key"
  "0854657374204b6579"
  // "Description for key"
  "134465736372697074696f6e20666f72206b6579"
  // Num ACKs
  "02"
  // ID = 1
  "000000000000000000000000000000000000000000000000000000000000000001"
  // Accepted
  "01"
  // Signature
  "3eca78815f2a9708181cc62604ec8c974fbe937765bce1d5c4cb6fa238c4371cc869ad31a6c8f41e0a3ec56ff64a9482579abc53650f617b0f75ccea7f17b6df"
  // ID = 6
  "0000000000000000000000000000000000000000000000000000000000000006"
  // Not accepted
  "00"
  // Signature
  "ae925598e774d39f0adfaae1275e8aa561b4bf9166c8a68d7d510270fb080d52fcd376dda173d1b5d1f8a5b21bfc62aae0e89ce983db64ee0e2a0214b60f74d0";

void main() {
  group("FrostKeyWithDetails", () {

    setUpAll(loadFrosty);

    test("can be read and written", () {

      final details = FrostKeyWithDetails.fromHex(keyWithDetailsHex);
      expect(details.keyInfo.toHex(), keyInfoHex);
      expect(details.name, "Test Key");
      expect(details.description, "Description for key");

      void expectAck(int i, bool accepted) {
        final ack = details.acks.firstWhere(
          (ack) => ack.signer.toBytes().last == i+1,
        );
        expect(ack.signed.obj.accepted, accepted);
        expect(ack.signed.obj.groupKey, groupPublicKey);
        expect(ack.signed.verify(getPrivkey(i).pubkey), true);
      }
      expectAck(0, true);
      expectAck(5, false);

      expect(details.toHex(), keyWithDetailsHex);

    });

  });
}

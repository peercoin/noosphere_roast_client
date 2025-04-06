import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
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

    test("requires metadata hashes to match", () {

      final key = getPrivkey(0);
      final tr = cl.Taproot(internalKey: key.pubkey);
      final output = cl.Output.fromProgram(
        cl.CoinUnit.coin.toSats("1"),
        cl.P2TR.fromTaproot(tr),
      );
      final tx = cl.Transaction(
        inputs: [cl.TaprootKeyInput(prevOut: cl.OutPoint(dummyHash, 0))],
        outputs: [output],
      );
      final trDetails = cl.TaprootKeySignDetails(
        tx: tx,
        inputN: 0,
        prevOuts: [output],
      );
      final metadata = TaprootTransactionSignatureMetadata(
        transaction: tx,
        signDetails: [trDetails],
      );

      void makeDetailsWithMsg(Uint8List msg) => SignaturesRequestDetails(
        requiredSigs: [
          SingleSignatureDetails(
            signDetails: SignDetails.keySpend(message: msg),
            groupKey: cl.ECCompressedPublicKey.fromPubkey(key.pubkey),
            hdDerivation: [],
          ),
        ],
        expiry: futureExpiry,
        metadata: metadata,
      );

      expect(
        () => makeDetailsWithMsg(Uint8List(32)),
        throwsA(isA<InvalidMetaData>()),
      );
      expect(
        () => makeDetailsWithMsg(cl.TaprootSignatureHasher(trDetails).hash),
        returnsNormally,
      );

    });

  });
}

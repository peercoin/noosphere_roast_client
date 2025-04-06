import 'package:coinlib/coinlib.dart' as cl;
import 'package:test/test.dart';
import 'package:noosphere_roast_client/noosphere_roast_client.dart';
import '../../data.dart';

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

  group("TaprootTransactionSignatureMetadata", () {

    late final cl.ECPrivateKey key;
    late final cl.Taproot tr;
    late final cl.Transaction tx;
    late final List<cl.Output> trOuts;
    late final cl.TapLeafChecksig apoLeaf;
    late final cl.TaprootSignDetails keyDetails, apoDetails, apoasDetails;
    setUpAll(() async {

      await loadFrosty();

      key = getPrivkey(0);
      apoLeaf = cl.TapLeafChecksig.apo(key.pubkey);
      tr = cl.Taproot(internalKey: key.pubkey, mast: apoLeaf);

      trOuts = List.generate(
        4,
        (i) => cl.Output.fromProgram(
          BigInt.from((i+1)*1000000),
          cl.P2TR.fromTaproot(tr),
        ),
      );

      tx = cl.Transaction(
        inputs: [
          cl.TaprootKeyInput(prevOut: cl.OutPoint(dummyHash, 0)),
          cl.TaprootSingleScriptSigInput.anyPrevOut(
            taproot: tr,
            leaf: apoLeaf,
          ),
          cl.TaprootSingleScriptSigInput.anyPrevOutAnyScript(),
          cl.P2PKHInput(
            prevOut: cl.OutPoint(dummyHash, 4),
            publicKey: key.pubkey,
          ),
        ],
        outputs: [trOuts.first],
      );

      keyDetails = cl.TaprootKeySignDetails(
        tx: tx, inputN: 0, prevOuts: trOuts,
      );
      apoasDetails = cl.TaprootScriptSignDetails(
        tx: tx,
        inputN: 2,
        prevOuts: [],
        hashType: cl.SigHashType.all(
          inputs: cl.InputSigHashOption.anyPrevOutAnyScript,
        ),
      );
      apoDetails = cl.TaprootScriptSignDetails(
        tx: tx,
        inputN: 1,
        prevOuts: [trOuts[1]],
        leafHash: apoLeaf.hash,
        hashType: cl.SigHashType.all(
          inputs: cl.InputSigHashOption.anyPrevOut,
        ),
      );

    });

    void expectSignDetails(
      cl.TaprootSignDetails actual, cl.TaprootSignDetails expected,
    ) {
      expect(actual.isScript, expected.isScript);
      expect(actual.leafHash, expected.leafHash);
      expect(actual.codeSeperatorPos, expected.codeSeperatorPos);
      expect(actual.inputN, expected.inputN);
      expect(actual.hashType, expected.hashType);
      expect(
        actual.prevOuts.map((out) => out.toHex()),
        expected.prevOuts.map((out) => out.toHex()),
      );
    }

    test("retains details after write/read", () {

      for (final signDetails in [
        // Contains SIGHASH_DEFAULT with all prevouts
        [keyDetails, apoasDetails, apoDetails],
        // Contains only AOCP, APO and APOAS
        [
          apoasDetails,
          apoDetails,
          cl.TaprootKeySignDetails(
            tx: tx,
            inputN: 0,
            prevOuts: [trOuts.first],
            hashType: cl.SigHashType.all(
              inputs: cl.InputSigHashOption.anyOneCanPay,
            ),
          ),
        ],
      ]) {

        final metadata = TaprootTransactionSignatureMetadata(
          transaction: tx,
          signDetails: signDetails,
        );

        final actual = SignatureMetadata.fromBytes(metadata.toBytes())
          as TaprootTransactionSignatureMetadata;
        expect(actual.transaction.toHex(), tx.toHex());

        // All sign details share the same tx object
        expect(
          {
            actual.transaction,
            ...actual.signDetails.map((details) => details.tx),
          },
          hasLength(1),
        );

        for (int i = 0; i < metadata.signDetails.length; i++) {
          expectSignDetails(actual.signDetails[i], metadata.signDetails[i]);
        }

      }

    });

    test("invalid", () {

      void expectInvalid(List<cl.TaprootSignDetails> details) => expect(
        () => TaprootTransactionSignatureMetadata(
          transaction: tx,
          signDetails: details,
        ),
        throwsException,
      );

      // Wrong tx object
      expectInvalid(
        [
          apoDetails,
          cl.TaprootKeySignDetails(
            tx: tx.addOutput(trOuts.first),
            inputN: 0,
            prevOuts: trOuts,
          ),
        ],
      );

      // Duplicate input N
      expectInvalid(
        [
          keyDetails,
          cl.TaprootKeySignDetails(
            tx: tx,
            inputN: 0,
            prevOuts: trOuts,
            hashType: cl.SigHashType.single(),
          ),
        ],
      );

      // Input not key-path TR
      expectInvalid(
        [cl.TaprootKeySignDetails(tx: tx, inputN: 1, prevOuts: trOuts)],
      );

      // Input not script-path TR
      expectInvalid(
        [cl.TaprootScriptSignDetails(tx: tx, inputN: 0, prevOuts: trOuts)],
      );

      // Input not TR
      expectInvalid(
        [cl.TaprootKeySignDetails(tx: tx, inputN: 3, prevOuts: trOuts)],
      );

    });

    test("invalid bytes", () {

      void expectInvalid(String hex) => expect(
        () => SignatureMetadata.fromHex(hex),
        throwsA(anyOf(isA<InvalidMetaData>(), isA<cl.CannotSignInput>())),
      );

      final typeAndTxHex = "01${tx.toHex()}";
      final out1Hex = "0140420f000000000022512001bff6ce4385e42d5b5f9c3c671c7b1f854952306e912b4deca4b60b29645a37";
      final out2Hex = "0180841e000000000022512001bff6ce4385e42d5b5f9c3c671c7b1f854952306e912b4deca4b60b29645a37";
      final out3Hex = "01c0c62d000000000022512001bff6ce4385e42d5b5f9c3c671c7b1f854952306e912b4deca4b60b29645a37";
      final out4Hex = "0100093d000000000022512001bff6ce4385e42d5b5f9c3c671c7b1f854952306e912b4deca4b60b29645a37";
      final txAndAllOuts = "$typeAndTxHex$out1Hex$out2Hex$out3Hex$out4Hex";

      // Invalid inputN
      expectInvalid("${txAndAllOuts}01000400000000ffffffff");

      // Invalid sighash
      expectInvalid("${txAndAllOuts}01000000040000ffffffff");

      // Missing output for SIGHASH_DEFAULT
      expectInvalid("$typeAndTxHex$out1Hex$out2Hex${out3Hex}0001000000000000ffffffff");

      // Missing specific output for APO
      expectInvalid("${typeAndTxHex}0000${out3Hex}0001000100410000ffffffff");

    });

    test(".verifyRequiredSigs", () {

      final metadata = TaprootTransactionSignatureMetadata(
        transaction: tx,
        signDetails: [keyDetails, apoDetails],
      );

      SingleSignatureDetails getDetails(
        SignDetails signDetails,
      ) => SingleSignatureDetails(
        signDetails: signDetails,
        groupKey: cl.ECCompressedPublicKey.fromPubkey(key.pubkey),
        hdDerivation: [],
      );

      final keyPathHash = cl.TaprootSignatureHasher(keyDetails).hash;
      final scriptPathHash = cl.TaprootSignatureHasher(apoDetails).hash;

      final keyPathDetails = getDetails(
        SignDetails.keySpend(message: keyPathHash, mastHash: tr.mast!.hash),
      );

      final scriptPathDetails = getDetails(
        SignDetails.scriptSpend(message: scriptPathHash),
      );

      expect(
        metadata.verifyRequiredSigs([keyPathDetails, scriptPathDetails]),
        true,
      );

      for (final bad in [
        // Wrong size
        [keyPathDetails],
        // Key details given as script-spend
        [
          getDetails(SignDetails.scriptSpend(message: keyPathHash)),
          scriptPathDetails,
        ],
        // Script details given as key-spend
        [
          keyPathDetails,
          getDetails(SignDetails.keySpend(message: scriptPathHash)),
        ],
        // Wrong hash
        [
          keyPathDetails,
          getDetails(SignDetails.scriptSpend(message: keyPathHash)),
        ],
      ]) {
        expect(metadata.verifyRequiredSigs(bad), false);
      }

    });

  });

}

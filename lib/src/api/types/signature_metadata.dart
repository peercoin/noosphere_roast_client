import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:collection/collection.dart';
import 'package:noosphere_roast_client/src/common/serial.dart';

import 'signatures_request_details.dart';
import 'single_signature_details.dart';

/// Thrown when the metadata is invalid. Other specific exceptions may be thrown
/// for invalid metadata.
class InvalidMetaData implements Exception {
  final String message;
  InvalidMetaData(this.message);
  @override
  String toString() => "InvalidMetaData: $message";
}

const int _emptyType = 0;
const int _taprootTxType = 1;

abstract interface class SignatureMetadata with cl.Writable {

  int get type;

  /// May throw an exception other than [cl.OutOfData] if the data is invalid
  static SignatureMetadata fromReader(cl.BytesReader reader)
    => switch(reader.readUInt8()) {
      _emptyType => EmptySignatureMetadata(),
      _taprootTxType => TaprootTransactionSignatureMetadata._fromReader(reader),
      int i => UnknownSignatureMetadata(
        i, reader.bytes.buffer.asUint8List(reader.offset),
      ),
    };

  /// Convenience constructor to construct from serialised [bytes].
  /// May throw an exception other than [cl.OutOfData] if the data is invalid
  static SignatureMetadata fromBytes(Uint8List bytes)
    => SignatureMetadata.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  /// May throw an exception other than [cl.OutOfData] if the data is invalid
  static SignatureMetadata fromHex(String hex)
    => SignatureMetadata.fromBytes(cl.hexToBytes(hex));

  void _writeType(cl.Writer writer) {
    writer.writeUInt8(type);
  }

  bool verifyRequiredSigs(List<SingleSignatureDetails> requiredSigs);

}

class EmptySignatureMetadata extends SignatureMetadata {

  @override
  final int type = _emptyType;

  @override
  void write(cl.Writer writer) {
    _writeType(writer);
  }

  @override
  bool verifyRequiredSigs(List<SingleSignatureDetails> requiredSigs) => true;

}

/// Provides data of Taproot transaction inputs to be signed.
///
/// The consumer should only approve signatures requests for transactions that
/// they approve and they should check that the inputs are solveable for the
/// derived signing key.
///
/// The [SignaturesRequestDetails] class uses [verifyRequiredSigs] to verify
/// that the [SingleSignatureDetails] messages correspond to the inputs being
/// signed. The consumer should check that the key and MAST hash are correct.
class TaprootTransactionSignatureMetadata extends SignatureMetadata {

  @override
  final int type = _taprootTxType;

  /// The transaction being signed
  final cl.Transaction transaction;
  /// The details for each input to be signed
  final List<cl.TaprootSignDetails> signDetails;

  /// Takes the [transaction] to be signed and the [signDetails] for all inputs
  /// to sign which must carry the same [transaction] object.
  TaprootTransactionSignatureMetadata({
    required this.transaction,
    required this.signDetails,
  }) {

    if (signDetails.any((details) => details.tx != transaction)) {
      throw InvalidMetaData("all details should carry the transaction object");
    }

    if (
      signDetails.map((details) => details.inputN).toSet().length
      != signDetails.length
    ) {
      throw InvalidMetaData("should have unique input indicies");
    }

    for (final details in signDetails) {

      final inN = details.inputN;
      final input = transaction.inputs[inN];

      if (input is! cl.TaprootInput) {
        throw InvalidMetaData("input $inN is not a taproot type");
      }

      if (input is cl.TaprootKeyInput != details is cl.TaprootKeySignDetails) {
        throw InvalidMetaData("input type doesn't correspond to sign details");
      }

    }

  }

  // Read, not including the type byte
  factory TaprootTransactionSignatureMetadata._fromReader(
    cl.BytesReader reader,
  ) {

    final transaction = cl.Transaction.fromReader(reader);
    final inLen = transaction.inputs.length;

    final prevOuts = List<cl.Output?>.generate(
      inLen,
      (i) => reader.readBool() ? cl.Output.fromReader(reader) : null,
    );

    final List<cl.TaprootSignDetails> signDetails = [];

    final detailsLen = reader.readUInt16();
    for (int i = 0; i < detailsLen; i++) {

      final inputN = reader.readUInt16();
      if (inputN >= inLen) {
        throw InvalidMetaData("Input N doesn't exist in transaction");
      }

      final hashValue = reader.readUInt8();
      if (!cl.SigHashType.validValue(hashValue)) {
        throw InvalidMetaData("Invalid sighash value");
      }
      final hashType = cl.SigHashType.fromValue(hashValue);
      final isScript = reader.readBool();
      final leafHash = reader.readBool() ? reader.readSlice(32) : null;
      final codeSeperatorPos = reader.readUInt32();

      final inPrevOuts = (
        hashType.allInputs
        ? prevOuts
        : (hashType.anyPrevOutAnyScript ? <cl.Output>[] : [prevOuts[inputN]])
      ).nonNulls.toList();

      signDetails.add(
        isScript
        ? cl.TaprootScriptSignDetails(
          tx: transaction,
          inputN: inputN,
          prevOuts: inPrevOuts,
          leafHash: leafHash,
          codeSeperatorPos: codeSeperatorPos,
          hashType: hashType,
        )
        : cl.TaprootKeySignDetails(
          tx: transaction,
          inputN: inputN,
          prevOuts: inPrevOuts,
          hashType: hashType,
        ),
      );

    }

    return TaprootTransactionSignatureMetadata(
      transaction: transaction,
      signDetails: signDetails,
    );

  }

  // Collect previous outputs that are required for the inputs to be signed. For
  // each transaction input, either an output is provided or null is given if
  // that output is not required.
  List<cl.Output?> _collectPrevOuts() {

    // First look for input sign details that signs for all inputs and carries
    // all previous outputs.
    final allPrevouts = signDetails.firstWhereOrNull(
      (details) => details.hashType.allInputs,
    )?.prevOuts;

    if (allPrevouts != null) return allPrevouts;

    // Collect previous outputs for each sign details
    final prevOuts = List<cl.Output?>.filled(transaction.inputs.length, null);
    for (final details in signDetails) {
      if (details.prevOuts.isEmpty) continue;
      prevOuts[details.inputN] = details.prevOuts.first;
    }

    return prevOuts;

  }

  @override
  void write(cl.Writer writer) {

    _writeType(writer);
    transaction.write(writer);

    // Write all previous outputs that can be determined from the sign details
    final prevOuts = _collectPrevOuts();
    for (final out in prevOuts) {
      writer.writeBool(out != null);
      if (out != null) out.write(writer);
    }

    // Write per input sign details
    writer.writeUInt16(signDetails.length);
    for (final details in signDetails) {

      // Prevouts are not included here as they are collected and included
      // separately for the entire transaction.

      writer.writeUInt16(details.inputN);
      writer.writeUInt8(details.hashType.value);
      writer.writeBool(details.isScript);

      final leafHash = details.leafHash;
      writer.writeBool(leafHash != null);
      if (leafHash != null) writer.writeSlice(leafHash);

      writer.writeUInt32(details.codeSeperatorPos);

    }

  }

  /// Each element in [requiredSigs] must have a message that corresponds to
  /// each element in [signDetails].
  @override
  bool verifyRequiredSigs(List<SingleSignatureDetails> requiredSigs) {

    if (requiredSigs.length != signDetails.length) return false;

    for (int i = 0; i < requiredSigs.length; i++) {

      final details = signDetails[i];
      final sig = requiredSigs[i];

      if (details.isScript != (sig.signDetails.mastHash == null)) return false;

      if (
        cl.compareBytes(
          cl.TaprootSignatureHasher(details).hash,
          sig.signDetails.message,
        ) != 0
      ) {
        return false;
      }

    }

    return true;

  }

}

class UnknownSignatureMetadata extends SignatureMetadata {

  @override
  final int type;
  final Uint8List data;

  UnknownSignatureMetadata(this.type, this.data);

  @override
  void write(cl.Writer writer) {
    _writeType(writer);
    writer.writeSlice(data);
  }

  @override
  bool verifyRequiredSigs(List<SingleSignatureDetails> requiredSigs) => true;

}

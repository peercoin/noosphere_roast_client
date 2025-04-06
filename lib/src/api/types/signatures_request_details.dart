import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'expiry.dart';
import 'signature_metadata.dart';
import 'signed.dart';
import 'single_signature_details.dart';

/// 16-byte ID for a [SignaturesRequestDetails] that implements equality
/// comparison
class SignaturesRequestId with cl.Writable {

  final Uint8List _hash;
  SignaturesRequestId._(this._hash) {
    assert(_hash.length == 16);
  }

  SignaturesRequestId.fromReader(cl.BytesReader reader) : this._(
    reader.readSlice(16),
  );

  /// Convenience constructor to construct from serialised [bytes].
  SignaturesRequestId.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  bool operator ==(Object other) => identical(this, other) || (
    other is SignaturesRequestId && cl.bytesEqual(_hash, other._hash)
  );

  @override
  int get hashCode => Object.hashAll(_hash);

  @override
  void write(cl.Writer writer) {
    writer.writeSlice(_hash);
  }

}

/// Details of requested required signatures
class SignaturesRequestDetails with cl.Writable, Signable {

  /// A request can be for one or more signatures at a time
  final List<SingleSignatureDetails> requiredSigs;
  /// The metadata contains details specific to the request and can vary
  /// depending on the type of request.
  final SignatureMetadata metadata;
  final Expiry expiry;

  SignaturesRequestDetails._({
    required this.requiredSigs,
    SignatureMetadata? metadata,
    required this.expiry,
    bool allowNegativeExpiry = false,
  }) : metadata = metadata ?? EmptySignatureMetadata() {
    if (
      requiredSigs.toSet().length != requiredSigs.length
      || requiredSigs.length > 0xffff
      || requiredSigs.isEmpty
    ) {
      throw ArgumentError.value(
        requiredSigs, "requiredSigs",
        "does not contain up-to 0xffff unique values",
      );
    }
    if (!allowNegativeExpiry) {
      expiry.requireNotExpired();
    }
    if (!this.metadata.verifyRequiredSigs(requiredSigs)) {
      throw InvalidMetaData("Required signatures not valid for metadata");
    }
  }

  SignaturesRequestDetails({
    required List<SingleSignatureDetails> requiredSigs,
    SignatureMetadata? metadata,
    required Expiry expiry,
  }) : this._(requiredSigs: requiredSigs, metadata: metadata, expiry: expiry);

  SignaturesRequestDetails.allowNegativeExpiry({
    required List<SingleSignatureDetails> requiredSigs,
    SignatureMetadata? metadata,
    required Expiry expiry,
  }) : this._(
    requiredSigs: requiredSigs, metadata: metadata, expiry: expiry,
    allowNegativeExpiry: true,
  );

  SignaturesRequestDetails.fromReader(cl.BytesReader reader) : this(
    requiredSigs: List.generate(
      reader.readUInt16(),
      (_) => SingleSignatureDetails.fromReader(reader),
    ),
    metadata: SignatureMetadata.fromReader(reader),
    expiry: Expiry.fromReader(reader),
  );

  /// Convenience constructor to construct from serialised [bytes].
  SignaturesRequestDetails.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  SignaturesRequestDetails.fromHex(String hex)
    : this.fromBytes(cl.hexToBytes(hex));

  static final _hasher = cl.getTaggedHasher("SignaturesRequestDetails");

  @override
  Uint8List get uncachedSigHash => _hasher(toBytes());

  @override
  void write(cl.Writer writer) {
    writer.writeUInt16(requiredSigs.length);
    for (final sig in requiredSigs) {
      sig.write(writer);
    }
    metadata.write(writer);
    expiry.write(writer);
  }

  SignaturesRequestId get id => SignaturesRequestId._(sigHash.sublist(0, 16));

}

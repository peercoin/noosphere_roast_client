import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:collection/collection.dart';
import 'package:frosty/frosty.dart';

/// Details for a single signature in a signatures request.
///
/// Consumers should determine if they desire to make these signatures for the
/// given details.
class SingleSignatureDetails with cl.Writable {

  /// The message hash to be signed and the MAST tweak.
  final SignDetails signDetails;
  /// The master group key to use
  final cl.ECCompressedPublicKey groupKey;
  /// The unhardened-only derivation path to obtain the key necessary for
  /// signing
  final List<int> hdDerivation;

  SingleSignatureDetails({
    required this.signDetails,
    required this.groupKey,
    required this.hdDerivation,
  }) {
    RangeError.checkValueInInterval(
      hdDerivation.length, 0, 0xff, "hdDerivation", "is too long",
    );
    for (final i in hdDerivation) {
      HDKeyInfo.checkIndex(i);
    }
  }

  SingleSignatureDetails.fromReader(cl.BytesReader reader) : this(
    signDetails: SignDetails.fromReader(reader),
    groupKey: cl.ECCompressedPublicKey(reader.readSlice(33)),
    hdDerivation: List.generate(reader.readUInt8(), (_) => reader.readUInt32()),
  );

  /// Convenience constructor to construct from serialised [bytes].
  SingleSignatureDetails.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  SingleSignatureDetails.fromHex(String hex)
    : this.fromBytes(cl.hexToBytes(hex));

  @override
  void write(cl.Writer writer) {
    signDetails.write(writer);
    writer.writeSlice(groupKey.data);
    writer.writeUInt8(hdDerivation.length);
    for (final i in hdDerivation) {
      writer.writeUInt32(i);
    }
  }

  @override
  bool operator ==(Object other) => identical(this, other) || (
    other is SingleSignatureDetails
    && signDetails == other.signDetails
    && groupKey == other.groupKey
    && ListEquality<int>().equals(hdDerivation, other.hdDerivation)
  );

  @override
  int get hashCode => Object.hash(
    signDetails,
    groupKey,
    Object.hashAll(hdDerivation),
  );

  T derive<T extends HDDerivableInfo>(T info) => hdDerivation.fold(
    info, (key, i) => key.derive(i) as T,
  );

}

import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/common/serial.dart';
import 'package:frosty/frosty.dart';
import 'dkg_ack.dart';
import 'signed.dart';

/// A signed [DkgAck] and the [signer]. These are equal when the [signer] and
/// group key are the same.
class SignedDkgAck with cl.Writable {

  final Identifier signer;
  final Signed<DkgAck> signed;

  SignedDkgAck({ required this.signer, required this.signed });
  SignedDkgAck.fromReader(cl.BytesReader reader) : this(
    signer: reader.readIdentifier(),
    signed: Signed.fromReader(reader, () => DkgAck.fromReader(reader)),
  );
  SignedDkgAck.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  /// Equal when the [signer] and the [DkgAck.groupKey] are the same regardless
  /// of acceptance
  bool operator==(Object other) => identical(this, other) || (
    other is SignedDkgAck
    && signer == other.signer
    && signed.obj.groupKey == other.signed.obj.groupKey
  );

  @override
  int get hashCode => signer.hashCode | signed.obj.groupKey.hashCode;

  @override
  void write(cl.Writer writer) {
    writer.writeIdentifier(signer);
    signed.write(writer);
  }

}

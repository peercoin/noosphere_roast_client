import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/common/errors.dart';
import 'package:noosphere_roast_client/src/common/serial.dart';
import 'package:frosty/frosty.dart';

/// Request for ACKs for all participant [ids] for a single key given by the
/// [groupPublicKey]. Equal when the [groupPublicKey] is the same.
class DkgAckRequest with cl.Writable {

  final Set<Identifier> ids;
  final cl.ECCompressedPublicKey groupPublicKey;

  DkgAckRequest({ required this.ids, required this.groupPublicKey }) {
    checkNotEmpty(ids, "ids");
  }
  DkgAckRequest.fromReader(cl.BytesReader reader) : this(
    ids: reader.readIdentifierVector().toSet(),
    groupPublicKey: reader.readPubKey(),
  );
  DkgAckRequest.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  /// Equality applies to [groupPublicKey] only.
  bool operator==(Object other)
  => identical(this, other) || (
    other is DkgAckRequest && groupPublicKey == other.groupPublicKey
  );

  @override
  int get hashCode => groupPublicKey.hashCode;

  @override
  void write(cl.Writer writer) {
    writer.writeIdentifierVector(ids);
    writer.writePubKey(groupPublicKey);
  }

}

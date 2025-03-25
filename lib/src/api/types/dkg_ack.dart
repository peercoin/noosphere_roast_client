import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/common/serial.dart';
import 'signed.dart';

/// A participant acknowledges that they have details for the [groupKey] if
/// [accepted] is true.
///
/// If [accepted] is false, they claim to not have the key and the receiver
/// should no longer ask for an acknowledgement. However, a participant and
/// server can lie, so the receiver should keep key data in case the key is used
/// by other participants.
///
/// A participant should not initiate use of a key until it has received
/// unanimous accepted acknowledgements. They can provide signature shares as
/// appropriate if other participants have used the key.
class DkgAck with cl.Writable, Signable {

  static final _hasher = cl.getTaggedHasher("DkgAck");
  final cl.ECCompressedPublicKey groupKey;
  final bool accepted;

  DkgAck({ required this.groupKey, required this.accepted });
  DkgAck.fromReader(cl.BytesReader reader) : this(
    groupKey: reader.readPubKey(),
    accepted: reader.readBool(),
  );

  @override
  Uint8List get uncachedSigHash => _hasher(toBytes());

  @override
  void write(cl.Writer writer) {
    writer.writePubKey(groupKey);
    writer.writeBool(accepted);
  }

}

import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/common.dart';
import 'dart:typed_data';
import 'signed.dart';

/// Wraps a [cl.ECCompressedPublicKey] in an object that can be signed to
/// signify that a participant claims to have constructed the private key.
class KeyWasConstructed with cl.Writable, Signable {

  static final _hasher = cl.getTaggedHasher("KeyWasConstructed");

  final cl.ECCompressedPublicKey publicKey;

  @override
  Uint8List get uncachedSigHash => _hasher(publicKey.data);

  KeyWasConstructed(this.publicKey);
  KeyWasConstructed.fromReader(cl.BytesReader reader)
    : publicKey = reader.readPubKey();
  KeyWasConstructed.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writePubKey(publicKey);
  }

}

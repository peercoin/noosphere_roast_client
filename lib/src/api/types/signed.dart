import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/common/serial.dart';

mixin Signable on cl.Writable {
  Uint8List get uncachedSigHash;
  Uint8List? _hashCache;
  Uint8List get sigHash => _hashCache ??= uncachedSigHash;
}

/// A 32-byte hash used directly for a signature
class SignableHash with cl.Writable, Signable {
  final Uint8List bytes;
  SignableHash(this.bytes) {
    RangeError.checkValueInInterval(bytes.length, 32, 32);
  }
  @override
  Uint8List get uncachedSigHash => bytes;
  @override
  void write(cl.Writer writer) {
    writer.writeSlice(bytes);
  }
}

class Signed<T extends Signable> with cl.Writable {

  final T obj;
  final cl.SchnorrSignature signature;

  Signed({ required this.obj, required this.signature });
  Signed.sign({
    required T obj,
    required cl.ECPrivateKey key,
  }) : this(
    obj: obj,
    signature: cl.SchnorrSignature.sign(key, obj.sigHash),
  );
  Signed.fromReader(cl.BytesReader reader, T Function() readObj) : this(
    obj: readObj(),
    signature: reader.readSignature(),
  );
  factory Signed.fromBytes(
    Uint8List bytes,
    T Function(cl.BytesReader) readObj,
  ) {
    final reader = cl.BytesReader(bytes);
    return Signed.fromReader(reader, () => readObj(reader));
  }

  bool verify(cl.ECPublicKey publickey)
    => signature.verify(publickey, obj.sigHash);

  @override
  void write(cl.Writer writer) {
    obj.write(writer);
    writer.writeSignature(signature);
  }

}

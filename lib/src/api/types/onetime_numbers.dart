import 'package:coinlib/coinlib.dart' as cl;
import 'dart:typed_data';
import 'bytes_mappable.dart';
import 'signed.dart';

/// Cryptographically secure onetime number of 16 bytes used for ids, challenges
/// etc.
class OnetimeNumber with cl.Writable, BytesMappable<OnetimeNumber> {
  final Uint8List n;
  OnetimeNumber() : n = cl.generateRandomBytes(16);
  OnetimeNumber.fromReader(cl.BytesReader reader) : n = reader.readSlice(16);
  OnetimeNumber.fromBytes(this.n) {
    if (n.length != 16) throw ArgumentError.value(n, "n", "not 16 bytes");
  }
  @override
  Uint8List get keyBytes => n;

  @override
  void write(cl.Writer writer) {
    writer.writeSlice(n);
  }

}

class AuthChallenge extends OnetimeNumber with Signable {
  static final _hasher = cl.getTaggedHasher("AuthChallenge");
  @override
  Uint8List get uncachedSigHash => _hasher(n);
  AuthChallenge() : super();
  AuthChallenge.fromReader(super.reader) : super.fromReader();
  AuthChallenge.fromBytes(super.bytes) : super.fromBytes();
}

class SessionID extends OnetimeNumber {
  SessionID() : super();
  SessionID.fromReader(super.reader) : super.fromReader();
  SessionID.fromBytes(super.bytes) : super.fromBytes();
}

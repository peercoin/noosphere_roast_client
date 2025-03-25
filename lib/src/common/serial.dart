import 'dart:convert';
import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';

extension NoosphereWriter on cl.Writer {

  void _writeFuncVector<T>(Iterable<T> obj, void Function(T) writeFunc) {
    final li = obj.toList();
    writeUInt16(li.length);
    for (final el in li) {
      writeFunc(el);
    }
  }

  void writeString(String str) => writeVarSlice(utf8.encoder.convert(str));
  void writeBool(bool b) => writeUInt8(b ? 1 : 0);
  void writeDuration(Duration duration) => writeUInt64(
    BigInt.from(duration.inMicroseconds),
  );
  void writeIdentifier(Identifier id) => writeSlice(id.toBytes());
  void writeIdentifierVector(Iterable<Identifier> ids)
    => _writeFuncVector(ids, (id) => writeIdentifier(id));
  void writeSignature(cl.SchnorrSignature sig) => writeSlice(sig.data);
  void writeSignatureVector(Iterable<cl.SchnorrSignature> sigs)
    => _writeFuncVector(sigs, (sig) => writeSignature(sig));
  void writeWritableVector(Iterable<cl.Writable> li) => writeVector(
    li.map((el) => el.toBytes()).toList(),
  );
  void writePubKey(cl.ECCompressedPublicKey key) => writeSlice(key.data);

}

extension NoosphereReader on cl.BytesReader {
  String readString() => utf8.decoder.convert(readVarSlice());
  bool readBool() => readUInt8() == 1;
  Duration readDuration() => Duration(microseconds: readUInt64().toInt());
  Identifier readIdentifier() => Identifier.fromBytes(readSlice(32));
  List<Identifier> readIdentifierVector() => List.generate(
    readUInt16(), (_) => readIdentifier(),
  );
  cl.SchnorrSignature readSignature() => cl.SchnorrSignature(readSlice(64));
  List<cl.SchnorrSignature> readSignatureVector() => List.generate(
    readUInt16(), (_) => readSignature(),
  );
  List<T> readWritableVector<T>(T Function(Uint8List) read)
    => readVector().map(read).toList();
  cl.ECCompressedPublicKey readPubKey() => cl.ECCompressedPublicKey(readSlice(33));
}

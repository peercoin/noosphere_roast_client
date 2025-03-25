import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;

const int _emptyType = 0;

abstract interface class SignatureMetadata with cl.Writable {

  int get type;

  static SignatureMetadata fromReader(cl.BytesReader reader)
    => switch(reader.readUInt8()) {
      _emptyType => EmptySignatureMetadata(),
      int i => UnknownSignatureMetadata(
        i, reader.bytes.buffer.asUint8List(reader.offset),
      ),
    };

  /// Convenience constructor to construct from serialised [bytes].
  static SignatureMetadata fromBytes(Uint8List bytes)
    => SignatureMetadata.fromReader(cl.BytesReader(bytes));

  /// Convenience constructor to construct from encoded [hex].
  static SignatureMetadata fromHex(String hex)
    => SignatureMetadata.fromBytes(cl.hexToBytes(hex));

  void _writeType(cl.Writer writer) {
    writer.writeUInt8(type);
  }

}

class EmptySignatureMetadata extends SignatureMetadata {

  @override
  final int type = _emptyType;

  @override
  void write(cl.Writer writer) {
    _writeType(writer);
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

}

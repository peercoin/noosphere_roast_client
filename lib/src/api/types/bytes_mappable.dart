import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;

mixin BytesMappable<T> {

  Uint8List get keyBytes;

  @override
  bool operator ==(Object other)
    => (other is BytesMappable<T>)
    && cl.bytesEqual(keyBytes, other.keyBytes);

  @override
  int get hashCode
    => keyBytes[1]
    | keyBytes[2] << 8
    | keyBytes[3] << 16
    | keyBytes[4] << 24;

}

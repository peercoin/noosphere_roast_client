import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/common.dart';

class Expiry with cl.Writable {

  final DateTime time;

  Expiry(Duration ttl) : time = DateTime.now().add(ttl);
  Expiry.fromTime(this.time);
  Expiry.fromReader(cl.BytesReader reader) : time = reader.readTime();
  Expiry.fromBytes(Uint8List bytes) : this.fromReader(cl.BytesReader(bytes));

  bool get isExpired => time.isBefore(DateTime.now());

  @override
  void write(cl.Writer writer) {
    writer.writeTime(time);
  }

  Duration get ttl => time.difference(DateTime.now());

  void requireNotExpired() {
    if (isExpired) throw ArgumentError.value(time.toString());
  }

  Expiry clampUpperTTL(Duration maxTTL)
    => ttl.compareTo(maxTTL) <= 0 ? this : Expiry(maxTTL);

}

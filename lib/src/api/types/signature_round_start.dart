import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:frosty/frosty.dart';

class SignatureRoundStart with cl.Writable {

  final int sigI;
  final SigningCommitmentSet commitments;
  SignatureRoundStart({
    required this.sigI,
    required this.commitments,
  });
  SignatureRoundStart.fromReader(cl.BytesReader reader) : this(
    sigI: reader.readUInt16(),
    commitments: SigningCommitmentSet.fromReader(reader),
  );
  SignatureRoundStart.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writeUInt16(sigI);
    commitments.write(writer);
  }

}

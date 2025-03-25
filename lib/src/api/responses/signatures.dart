import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/api/types/signature_round_start.dart';
import 'package:noosphere_roast_client/src/common/serial.dart';
import 'package:frosty/frosty.dart';

sealed class SignaturesResponse with cl.Writable {}

/// Provides the [SigningCommitmentSet]s when new ROAST rounds are initiated.
class SignatureNewRoundsResponse extends SignaturesResponse {

  final List<SignatureRoundStart> rounds;
  SignatureNewRoundsResponse(this.rounds);

  SignatureNewRoundsResponse.fromReader(cl.BytesReader reader) : this(
    reader.readWritableVector(
      (bytes) => SignatureRoundStart.fromBytes(bytes),
    ),
  );

  /// Convenience constructor to construct from serialised [bytes].
  SignatureNewRoundsResponse.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writeWritableVector(rounds);
  }

}

/// Provides all of the final signatures when ROAST is complete.
class SignaturesCompleteResponse extends SignaturesResponse {

  final List<cl.SchnorrSignature> signatures;
  SignaturesCompleteResponse(this.signatures);

  SignaturesCompleteResponse.fromReader(cl.BytesReader reader) : this(
    reader.readSignatureVector(),
  );

  /// Convenience constructor to construct from serialised [bytes].
  SignaturesCompleteResponse.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    writer.writeSignatureVector(signatures);
  }

}

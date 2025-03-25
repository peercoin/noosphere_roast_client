import 'dart:typed_data';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/api/types/expirable.dart';
import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/api/types/onetime_numbers.dart';

class ExpirableAuthChallengeResponse with cl.Writable implements Expirable {

  final AuthChallenge challenge;
  @override
  final Expiry expiry;

  ExpirableAuthChallengeResponse({
    required this.challenge,
    required this.expiry,
  });

  ExpirableAuthChallengeResponse.fromReader(cl.BytesReader reader) : this(
    challenge: AuthChallenge.fromReader(reader),
    expiry: Expiry.fromReader(reader),
  );

  /// Convenience constructor to construct from serialised [bytes].
  ExpirableAuthChallengeResponse.fromBytes(Uint8List bytes)
    : this.fromReader(cl.BytesReader(bytes));

  @override
  void write(cl.Writer writer) {
    challenge.write(writer);
    expiry.write(writer);
  }

}

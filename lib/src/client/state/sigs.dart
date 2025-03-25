import 'package:noosphere_roast_client/src/api/types/expirable.dart';
import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/api/types/signature_round_start.dart';
import 'package:noosphere_roast_client/src/api/types/signatures_request_details.dart';
import 'package:frosty/frosty.dart';

class ClientSigsState implements Expirable {

  final SignaturesRequestDetails details;
  final Identifier creator;
  @override
  final Expiry expiry;
  final List<SignatureRoundStart> pendingRounds = [];

  ClientSigsState({
    required this.details,
    required this.creator,
    required this.expiry,
  });

}

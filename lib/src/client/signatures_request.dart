import 'package:noosphere_roast_client/src/api/types/expirable.dart';
import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/api/types/signatures_request_details.dart';
import 'package:frosty/frosty.dart';

/// If [waiting] the request hasn't received a response by the client, otherwise
/// it has been [accepted] or [rejected] by the client.
enum SignaturesRequestStatus { waiting, accepted, rejected }

class SignaturesRequest implements Expirable {

  final SignaturesRequestDetails details;
  final Identifier creator;
  @override
  final Expiry expiry;
  final SignaturesRequestStatus status;

  SignaturesRequest({
    required this.details,
    required this.creator,
    required this.expiry,
    required this.status,
  });

}

import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/api/types/new_dkg_details.dart';
import 'package:frosty/frosty.dart';

enum DkgStage { round1, round2 }

class DkgInProgress {

  final NewDkgDetails details;
  /// The time the DKG will be expired by the client which may be different from
  /// the requested expiry in the DKG details.
  final Expiry expiry;
  final Identifier creator;
  final DkgStage stage;
  /// List of paraticipant identifiers that have completed the stage
  final Set<Identifier> completed;

  DkgInProgress({
    required this.details,
    required this.expiry,
    required this.creator,
    required this.stage,
    required this.completed,
  });

}

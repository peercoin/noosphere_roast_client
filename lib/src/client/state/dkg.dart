import 'package:noosphere_roast_client/src/api/types/expirable.dart';
import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/api/types/new_dkg_details.dart';
import 'package:noosphere_roast_client/src/client/dkg_in_progress.dart';
import 'package:frosty/frosty.dart';

abstract class ClientDkgRoundState {}

class ClientDkgRound1State extends ClientDkgRoundState {
  DkgRound1Secret? ourSecret;
  final DkgCommitmentList commitments;
  ClientDkgRound1State(
    DkgCommitmentList commitments, this.ourSecret,
  ) : commitments = commitments.toList();
}

class ClientDkgRound2State extends ClientDkgRoundState {
  final DkgRound2Secret ourSecret;
  final DkgCommitmentSet commitmentSet;
  final Map<Identifier, DkgShareToGive> secretShares = {};
  ClientDkgRound2State(this.ourSecret, this.commitmentSet);
}

class ClientDkgState implements Expirable {

  final NewDkgDetails details;
  final Identifier creator;
  @override
  final Expiry expiry;
  ClientDkgRoundState round;

  ClientDkgState({
    required this.details,
    required this.creator,
    required this.expiry,
    DkgCommitmentList commitments = const [],
    DkgRound1Secret? ourSecret,
  }) : round = ClientDkgRound1State(commitments, ourSecret);

  ClientDkgRound1State get round1 => round as ClientDkgRound1State;
  ClientDkgRound2State get round2 => round as ClientDkgRound2State;

  DkgInProgress progress(Identifier selfId) => DkgInProgress(
    details: details,
    expiry: expiry,
    creator: creator,
    stage: round is ClientDkgRound1State ? DkgStage.round1 : DkgStage.round2,
    completed: round is ClientDkgRound1State
      ? round1.commitments.map((c) => c.$1).toSet()
      // Add self Identifier to give consistent view of completion for both
      // rounds whereby inclusion of self Identifier indicates client has sent
      // the round
      : (round2.secretShares.keys.toSet()..add(selfId)),
  );

}

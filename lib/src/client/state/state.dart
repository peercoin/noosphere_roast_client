import 'dart:async';
import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/api/types/onetime_numbers.dart';
import 'package:noosphere_roast_client/src/api/types/signatures_request_details.dart';
import 'package:noosphere_roast_client/src/common/expirable_map.dart';
import 'package:frosty/frosty.dart';
import 'dkg.dart';
import 'sigs.dart';

/// Memory state for the lifetime of a session with the server.
class ClientState {

  final SessionID sessionID;

  Expiry expiry;
  Set<Identifier> onlineParticipants = {};
  late final ExpirableMap<String, ClientDkgState> nameToDkg;
  late final ExpirableMap<SignaturesRequestId, ClientSigsState> sigRequests;
  Timer? sessionExtension;

  ClientState({
    required this.sessionID,
    required this.expiry,
    required void Function(ClientDkgState) onDkgExpired,
    required void Function(ClientSigsState) onSigsReqExpired,
  }) {
    nameToDkg = ExpirableMap(
      onExpired: (_, dkgState) => onDkgExpired(dkgState),
    );
    sigRequests = ExpirableMap(
      onExpired: (_, sigsReqState) => onSigsReqExpired(sigsReqState),
    );
  }

  Iterable<ClientDkgState> _getRoundDkgs<R>() => nameToDkg.values.where(
    (dkg) => dkg.round is R,
  );

  Iterable<ClientDkgState> get round1Dkgs
    => _getRoundDkgs<ClientDkgRound1State>();

  Iterable<ClientDkgState> get round2Dkgs
    => _getRoundDkgs<ClientDkgRound2State>();

}

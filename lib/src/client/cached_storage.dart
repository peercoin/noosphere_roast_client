import 'package:coinlib/coinlib.dart' as cl;
import 'package:noosphere_roast_client/src/api/types/dkg_ack_request.dart';
import 'package:noosphere_roast_client/src/api/types/expirable.dart';
import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/api/types/signatures_request_details.dart';
import 'package:noosphere_roast_client/src/api/types/signed_dkg_ack.dart';
import 'package:noosphere_roast_client/src/client/frost_key_with_details.dart';
import 'package:noosphere_roast_client/src/client/storage_interface.dart';
import 'package:noosphere_roast_client/src/common/expirable_map.dart';
import 'package:frosty/frosty.dart';

class ClientCachedStorage {

  final ClientStorageInterface _underlying;
  final Map<cl.ECCompressedPublicKey, FrostKeyWithDetails> keys;
  final ExpirableMap<SignaturesRequestId, SignaturesNonces> sigNonces;
  final ExpirableMap<SignaturesRequestId, FinalExpirable> sigsRejected;

  ClientCachedStorage._(
    this._underlying, this.keys, this.sigNonces, this.sigsRejected,
  );

  static Future<ClientCachedStorage> load(ClientStorageInterface store) async
    => ClientCachedStorage._(
      store,
      { for (final key in await store.loadKeys()) key.groupKey: key },
      ExpirableMap.of(await store.loadSigNonces()),
      ExpirableMap.of(await store.loadRejectedSigsRequests()),
    );

  Future<void> addOrReplaceFrostKey(FrostKeyWithDetails key) async {
    await _underlying.addOrReplaceFrostKey(key);
    keys[key.groupKey] = key;
  }

  Set<SignedDkgAck> getAcksForRequest(DkgAckRequest request)
    => keys[request.groupPublicKey]
    ?.acks.where((ack) => request.ids.contains(ack.signer)).toSet()
    ?? {};

  Set<DkgAckRequest> getAckRequestsForMissing(Set<Identifier> ids)
    // Get ids that do not already have ACKs and get the group key
    => keys.values.map(
      (key) => (
        ids.where((id) => !key.acks.any((ack) => ack.signer == id)).toSet(),
        key.groupKey,
      ),
    )
    // Ignore keys where there are no missing ids
    .where((tuple) => tuple.$1.isNotEmpty)
    // Create DkgAckRequests for IDs and group key
    .map((tuple) => DkgAckRequest(ids: tuple.$1, groupPublicKey: tuple.$2))
    .toSet();

  Future<void> addSignaturesNonces({
    required SignaturesRequestId id,
    required SignaturesNonces nonces,
    required int capacity,
  }) async {
    await _underlying.addSignaturesNonces(id, nonces, capacity);
    if (sigNonces.containsKey(id)) {
      sigNonces[id]!.map.addEntries(nonces.map.entries);
    } else {
      sigNonces[id] = nonces;
    }
  }

  Future<void> addRejectedSigsRequest(
    SignaturesRequestId id, Expiry expiry,
  ) async {
    final expirable = FinalExpirable(expiry);
    await _underlying.addRejectedSigsRequest(id, expirable);
    sigsRejected[id] = expirable;
  }

  Future<void> removeRejectionOfSigsRequest(SignaturesRequestId id) async {
    await _underlying.removeRejectionOfSigsRequest(id);
    sigsRejected.remove(id);
  }

  Future<void> removeSigsRequest(SignaturesRequestId id) async {
    await _underlying.removeSigsRequest(id);
    sigNonces.remove(id);
    sigsRejected.remove(id);
  }

}

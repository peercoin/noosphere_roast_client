import 'package:noosphere_roast_client/src/api/types/expirable.dart';
import 'package:noosphere_roast_client/src/api/types/expiry.dart';
import 'package:noosphere_roast_client/src/api/types/signatures_request_details.dart';
import 'package:noosphere_roast_client/src/api/types/signed_dkg_ack.dart';
import 'package:frosty/frosty.dart';
import 'frost_key_with_details.dart';

class SignaturesNonces implements Expirable {
  /// Maps the index of a signature in a request with the nonce to store.
  final Map<int, SigningNonces> map;
  @override
  final Expiry expiry;
  SignaturesNonces(this.map, this.expiry);
}

/// These methods need to be implemented for permanent storage of key
/// information.
abstract interface class ClientStorageInterface {

  /// Add or replace the key with details to the storage. If the
  /// [FrostKeyWithDetails.groupKey] is the same as an existing key, it must be
  /// replaced with the new details.
  Future<void> addOrReplaceFrostKey(FrostKeyWithDetails newKey);

  /// Stores the nonces for the presignatures of a request given by [id]. Each
  /// nonce is mapped by the signature index in the request.
  ///
  /// [capacity] provides the total possible number of nonces that may need to
  /// be stored, so that a list may be pre-allocated.
  ///
  /// Existing nonces for a given signature index included in the map should be
  /// replaced. Existing nonces for signature indexes that are not included in
  /// the map should not be removed.
  ///
  /// The nonces can be safely removed after they have expired.
  Future<void> addSignaturesNonces(
    SignaturesRequestId id, SignaturesNonces nonces, int capacity,
  );

  /// Add the ID of a signatures request that was rejected. This may be removed
  /// when [expirable] expires or by [removeRejectionOfSigsRequest].
  Future<void> addRejectedSigsRequest(
    SignaturesRequestId id, FinalExpirable expirable,
  );

  /// Removes the ID of a signatures request that is no longer rejected.
  Future<void> removeRejectionOfSigsRequest(SignaturesRequestId id);

  /// Remove all data (rejection and/or nonces) for a signatures request
  Future<void> removeSigsRequest(SignaturesRequestId id);

  /// Load the key details including [SignedDkgAck]s.
  Future<Set<FrostKeyWithDetails>> loadKeys();

  /// For every non-expired signature request, this should return a map from the
  // [SignaturesRequestId] to the [SignaturesNonces].
  Future<Map<SignaturesRequestId, SignaturesNonces>> loadSigNonces();

  /// Loads the IDs of all of the signatures requests that were rejected by the
  /// client
  Future<Map<SignaturesRequestId, FinalExpirable>> loadRejectedSigsRequests();

}

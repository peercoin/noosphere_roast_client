import 'dart:async';
import 'package:coinlib/coinlib.dart' as cl;
import 'package:collection/collection.dart';
import 'package:noosphere_roast_client/src/api/types/expirable.dart';
import 'package:noosphere_roast_client/src/api/types/signatures_request_details.dart';
import 'package:noosphere_roast_client/src/client/storage_interface.dart';
import 'frost_key_with_details.dart';

class KeyToComplete {
  final int expAcks;
  final completer = Completer<FrostKeyWithDetails>();
  KeyToComplete(this.expAcks);
}

/// An in-memory storage solution for the [ClientStorageInterface]. This is used
/// by the tests and example but real applications would benefit from persistant
/// storage.
class InMemoryClientStorage implements ClientStorageInterface {

  final Map<cl.ECPublicKey, FrostKeyWithDetails> keys = {};
  final Map<SignaturesRequestId, SignaturesNonces> sigNonces = {};
  final Map<SignaturesRequestId, FinalExpirable> sigsRejected = {};

  final Map<String, KeyToComplete> keyCompleters = {};

  void _maybeCompleteKey(FrostKeyWithDetails key) {

    final toComplete = keyCompleters[key.name];
    if (toComplete == null) return;

    if (key.acceptedAcks >= toComplete.expAcks) {
      toComplete.completer.complete(key);
      keyCompleters.remove(key.name);
    }

  }

  @override
  Future<void> addOrReplaceFrostKey(FrostKeyWithDetails newKey) async {
    keys[newKey.groupKey] = newKey;
    _maybeCompleteKey(newKey);
  }

  @override
  Future<Set<FrostKeyWithDetails>> loadKeys() async => keys.values.toSet();

  @override
  Future<void> addRejectedSigsRequest(
    SignaturesRequestId id,
    FinalExpirable expirable,
  ) async {
    sigsRejected[id] = expirable;
  }

  @override
  Future<void> addSignaturesNonces(
    SignaturesRequestId id,
    SignaturesNonces nonces,
    int capacity,
  ) async {
    if (sigNonces.containsKey(id)) {
      sigNonces[id]!.map.addEntries(nonces.map.entries);
    } else {
      sigNonces[id] = nonces;
    }
  }

  @override
  Future<Map<SignaturesRequestId, FinalExpirable>> loadRejectedSigsRequests(
  ) async => sigsRejected;

  @override
  Future<Map<SignaturesRequestId, SignaturesNonces>> loadSigNonces(
  ) async => sigNonces;

  @override
  Future<void> removeRejectionOfSigsRequest(SignaturesRequestId id) async {
    sigsRejected.remove(id);
  }

  @override
  Future<void> removeSigsRequest(SignaturesRequestId id) async {
    sigNonces.remove(id);
    sigsRejected.remove(id);
  }

  /// Waits for a key to be created and receive a number of ACKs. Must only be
  /// used once at a time.
  Future<FrostKeyWithDetails> waitForKeyWithName(String name, int expAcks) async {

    final key = keys.values.firstWhereOrNull((key) => key.name == name);
    if (key != null && key.acceptedAcks >= expAcks) return key;

    final toComplete = keyCompleters[name] = KeyToComplete(expAcks);
    return await toComplete.completer.future;

  }

}

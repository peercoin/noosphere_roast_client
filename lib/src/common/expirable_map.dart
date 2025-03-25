import 'dart:collection';
import 'package:noosphere_roast_client/src/api/types/expirable.dart';

/// Maps [K] to the [Expirable] [V] objects. These objects are removed when
/// expired. [K] should have [Object.operator==] and [Object.hashCode]
/// implemented.
class ExpirableMap<K, V extends Expirable> {

  final HashMap<K, V> _map;
  final void Function(K, V) _onExpired;

  ExpirableMap({ void Function(K, V)? onExpired })
    : this.of(HashMap(), onExpired: onExpired);

  ExpirableMap.of(Map<K, V> map, { void Function(K, V)? onExpired })
    : _map = HashMap.of(map),
    _onExpired = onExpired ?? ((_,__) {});

  void _removeExpired() {

    // Get entries to be expired
    final toExpire = _map.entries.where(
      (e) => e.value.expiry.isExpired,
    ).toList();

    for (final entry in toExpire) {
      _map.remove(entry.key);
      _onExpired(entry.key, entry.value);
    }

  }

  /// Adds the object to the map
  void operator[]=(K key, V value) {
    _map[key] = value;
    _removeExpired();
  }

  /// Obtain the object if it is not expired.
  V? operator[](K key) {
    _removeExpired();
    return _map[key];
  }

  bool containsKey(K key) {
    _removeExpired();
    return _map.containsKey(key);
  }

  /// Remove the entry at [key] and return the removed value. Returns null if
  /// the key was not in the map. Does not call [this.onExpired].
  V? remove(K key) => _map.remove(key);

  void removeWhere(bool Function(K key, V value) test) => _map.removeWhere(test);

  Iterable<V> get values {
    _removeExpired();
    return _map.values;
  }

  void clear() => _map.clear();

}

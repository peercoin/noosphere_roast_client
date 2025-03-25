import 'package:yaml/yaml.dart';
import 'package:yaml_edit/yaml_edit.dart';

class MapReaderException implements Exception {
  final String message;
  MapReaderException(this.message);
  @override
  String toString() => message;
}

/// Reads a map from YAML
class MapReader {

  final Object? _value;
  final List<Object> _path;

  MapReader._(this._value, this._path);
  MapReader.fromYaml(String yaml) : this._(loadYaml(yaml) as Object, []);

  String _joinedPath() => _path.join(".");

  MapReader operator[](Object key) => MapReader._(
    _value is! Map ? null : _value[key],
    [..._path, key],
  );

  T? value<T>() => _value is T ? _value : null;

  T require<T>()
    => value<T>() == null
    ? throw MapReaderException("No value of type $T at ${_joinedPath()}")
    : value<T>()!;

  Iterable<T> keysOf<T>()
    => _value == null
    ? Iterable.empty()
    : (
      _value is! Map || _value.keys.any((v) => v is! T)
      ? throw MapReaderException("${_joinedPath()} is not map with $T keys")
      : _value.keys.map((k) => k as T)
    );

  Duration? duration() {
    final ms = value<int>();
    return ms == null ? null : Duration(milliseconds: ms);
  }

  Duration? getTTL(String name) => this["ms-lifetimes"][name].duration();

}

/// Objects that use this mixin provide a [Map] via [map()] that represents the
/// object which subsequently is used to output YAML via [yaml].
mixin MapWritable {
  Map<Object, Object> map();
  String get yaml => (YamlEditor("")..update([], map())).toString();
}

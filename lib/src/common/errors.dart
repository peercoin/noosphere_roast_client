void checkNotEmpty<T>(Iterable<T> iterable, String name) {
  if (iterable.isEmpty) {
    throw ArgumentError.value(iterable, name, "must not be empty");
  }
}

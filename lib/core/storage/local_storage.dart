/// Abstract contract for key-value local persistence.
///
/// All values are stored and retrieved as nullable [String]s so that the
/// callers decide how to serialise/deserialise their domain types.
abstract class LocalStorage {
  /// Persists [value] under [key], overwriting any previous value.
  Future<void> write(String key, String value);

  /// Returns the value stored under [key], or `null` if it does not exist.
  Future<String?> read(String key);

  /// Removes the entry for [key]. No-ops if the key does not exist.
  Future<void> delete(String key);

  /// Wipes every entry in the store.
  Future<void> clearAll();
}

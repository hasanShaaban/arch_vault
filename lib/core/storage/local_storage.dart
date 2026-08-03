abstract class LocalStorage {
  Future<void> write(String key, String value);
  Future<String?> read(String key);
  Future<void> delete(String key);
}

class InMemoryStorage implements LocalStorage {
  final Map<String, String> _store = {};

  @override
  Future<void> write(String key, String value) async {
    _store[key] = value;
  }

  @override
  Future<String?> read(String key) async => _store[key];

  @override
  Future<void> delete(String key) async {
    _store.remove(key);
  }
}

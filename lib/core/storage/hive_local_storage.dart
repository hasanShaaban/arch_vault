import 'package:hive_flutter/hive_flutter.dart';

import 'local_storage.dart';

/// [LocalStorage] implementation backed by [Hive].
///
/// Call [HiveLocalStorage.init] once during app start-up (before the service
/// locator is set up) to initialise Hive and open the box.
class HiveLocalStorage implements LocalStorage {
  HiveLocalStorage._(this._box);

  static const String _boxName = 'app_storage';

  final Box<String> _box;

  /// Initialises Hive, opens the named box, and returns a ready-to-use
  /// [HiveLocalStorage] instance.
  static Future<HiveLocalStorage> init() async {
    await Hive.initFlutter();
    final box = await Hive.openBox<String>(_boxName);
    return HiveLocalStorage._(box);
  }

  @override
  Future<void> write(String key, String value) async {
    await _box.put(key, value);
  }

  @override
  Future<String?> read(String key) async {
    return _box.get(key);
  }

  @override
  Future<void> delete(String key) async {
    await _box.delete(key);
  }

  @override
  Future<void> clearAll() async {
    await _box.clear();
  }
}

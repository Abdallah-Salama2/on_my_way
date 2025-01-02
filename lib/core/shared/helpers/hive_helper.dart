import 'package:hive_flutter/adapters.dart';

class HiveHelper {
  HiveHelper._();

  static const String user = 'userData';

  static Future<void> init() async {
    await Hive.openBox(user); 
  }

  static dynamic getDataFromHive(
      {required String hiveBoxKey, required String key}) {
    final box = Hive.box(hiveBoxKey);
    return box.get(key);
  }

  static void putDataInHive({
    required String hiveBoxKey,
    required String key,
    required dynamic value,
  }) {
    final box = Hive.box(hiveBoxKey);
    box.put(key, value);
  }

  static void clearAllData() async {
    Hive.deleteFromDisk();
  }

  static void clearBox({required String hiveBoxKey}) {
    Hive.box(hiveBoxKey).clear();
  }

  static void deleteDataFromBox(
      {required String hiveBoxKey, required String key}) {
    Hive.box(hiveBoxKey).delete(key);
  }
}

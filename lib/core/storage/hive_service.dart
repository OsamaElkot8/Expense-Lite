import 'package:hive_flutter/hive_flutter.dart';

class HiveService {
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters will be done after creating models
    // await Hive.registerAdapter(ExpenseAdapter());
    // await Hive.registerAdapter(CurrencyRateAdapter());
  }

  static Future<Box> openBox(String boxName) async {
    return await Hive.openBox(boxName);
  }

  static Box? getBox(String boxName) {
    try {
      return Hive.box(boxName);
    } catch (e) {
      return null;
    }
  }

  static Future<void> closeBox(String boxName) async {
    final box = getBox(boxName);
    if (box != null && box.isOpen) {
      await box.close();
    }
  }

  static Future<void> clearBox(String boxName) async {
    final box = getBox(boxName);
    if (box != null) {
      await box.clear();
    }
  }
}

import 'package:hive_flutter/hive_flutter.dart';

abstract class LocalDatabase {
  Future<void> save<T>({
    required String boxName,
    String? key,
    required T value,
  });
  Future<T?> get<T>({
    required String boxName,
    String? key,
  });
  deleteBox({
    required String boxName,
  });
  Future<void> clearBox({
    required String boxName,
  });

  Future<void> remove({
    required String boxName,
    required String key,
  });
}

class HiveDatabase implements LocalDatabase {
  Future<Box> _openBox(String boxName) async {
    if (Hive.isBoxOpen(boxName)) {
      return Hive.box(boxName);
    }
    return await Hive.openBox(boxName);
  }

  Future<void> closeBox(Box box) async {
    if (box.isOpen) await box.close();
  }

  @override
  Future<void> save<T>({
    required String boxName,
    String? key,
    required T value,
  }) async {
    final box = await _openBox(boxName);
    if (key != null) {
      await box.put(key, value);
    } else {
      await box.add(value);
    }
    await closeBox(box);
  }

  @override
  Future<T?> get<T>({
    required String boxName,
    String? key,
  }) async {
    final box = await _openBox(boxName);
    if (key != null && box.containsKey(key)) {
      final result = box.get(key);
      await closeBox(box);
      return result;
    }
    await closeBox(box);
    return null;
  }

  @override
  Future<void> deleteBox({required String boxName}) async {
    if (Hive.isBoxOpen(boxName)) {
      await Hive.box(boxName).close();
    }
    await Hive.deleteBoxFromDisk(boxName);
  }

  @override
  Future<void> clearBox({required String boxName}) async {
    final box = await _openBox(boxName);
    await box.clear();
    await box.close();
  }

  @override
  Future<void> remove({
    required String boxName,
    required String key,
  }) async {
    final box = await _openBox(boxName);
    await box.delete(key);
  }
}

import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperMeasurements {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        measurementName TEXT,
        measurementType TEXT,
        measurementSerialNumber TEXT,
        measurementObserved TEXT,
        measurementAim TEXT,
        measurementActivityArea TEXT,
        measurementPurpose TEXT,
        measurementWebPage TEXT,
        measurementComment TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// measurementName, measurementType: name and measurementType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'measurements.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (measurement)
  static Future<int> createItem(String measurementName,
      String? measurementType,
      String? measurementSerialNumber,
      String? measurementObserved,
      String? measurementAim,
      String? measurementActivityArea,
      String? measurementPurpose,
      String? measurementWebPage,
      String? measurementComment) async {
    final db = await SQLHelperMeasurements.db();

    final data = {'measurementName': measurementName,
      'measurementType': measurementType,
      'measurementSerialNumber': measurementSerialNumber,
      'measurementObserved': measurementObserved,
      'measurementAim': measurementAim,
      'measurementActivityArea': measurementActivityArea,
      'measurementPurpose': measurementPurpose,
      'measurementWebPage': measurementWebPage,
      'measurementComment': measurementComment};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (measurements)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperMeasurements.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperMeasurements.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String measurementName,
      String? measurementType,
      String? measurementSerialNumber,
      String? measurementObserved,
      String? measurementAim,
      String? measurementActivityArea,
      String? measurementPurpose,
      String? measurementWebPage,
      String? measurementComment) async {
    final db = await SQLHelperMeasurements.db();

    final data = {
      'measurementName': measurementName,
      'measurementType': measurementType,
      'measurementObserved': measurementObserved,
      'measurementAim': measurementAim,
      'measurementSerialNumber': measurementSerialNumber,
      'measurementActivityArea': measurementActivityArea,
      'measurementPurpose': measurementPurpose,
      'measurementWebPage': measurementWebPage,
      'measurementComment': measurementComment,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperMeasurements.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
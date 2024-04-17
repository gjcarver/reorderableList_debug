import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperObservations {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        observationName TEXT,
        observationType TEXT,
        observationSerialNumber TEXT,
        observationObserved TEXT,
        observationAim TEXT,
        observationActivityArea TEXT,
        observationPurpose TEXT,
        observationWebPage TEXT,
        observationComment TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// observationName, observationType: name and observationType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'observations.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (observation)
  static Future<int> createItem(String observationName,
      String? observationType,
      String? observationSerialNumber,
      String? observationObserved,
      String? observationAim,
      String? observationActivityArea,
      String? observationPurpose,
      String? observationWebPage,
      String? observationComment) async {
    final db = await SQLHelperObservations.db();

    final data = {'observationName': observationName,
      'observationType': observationType,
      'observationSerialNumber': observationSerialNumber,
      'observationObserved': observationObserved,
      'observationAim': observationAim,
      'observationActivityArea': observationActivityArea,
      'observationPurpose': observationPurpose,
      'observationWebPage': observationWebPage,
      'observationComment': observationComment};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (observations)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperObservations.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperObservations.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String observationName,
      String? observationType,
      String? observationSerialNumber,
      String? observationObserved,
      String? observationAim,
      String? observationActivityArea,
      String? observationPurpose,
      String? observationWebPage,
      String? observationComment) async {
    final db = await SQLHelperObservations.db();

    final data = {
      'observationName': observationName,
      'observationType': observationType,
      'observationObserved': observationObserved,
      'observationAim': observationAim,
      'observationSerialNumber': observationSerialNumber,
      'observationActivityArea': observationActivityArea,
      'observationPurpose': observationPurpose,
      'observationWebPage': observationWebPage,
      'observationComment': observationComment,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperObservations.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
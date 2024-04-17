import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperReenactment {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        reenactmentName TEXT,
        reenactmentType TEXT,
        reenactmentSerialNumber TEXT,
        reenactmentObserved TEXT,
        reenactmentAim TEXT,
        reenactmentActivityArea TEXT,
        reenactmentPurpose TEXT,
        reenactmentWebPage TEXT,
        reenactmentComment TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// reenactmentName, reenactmentType: name and reenactmentType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'reenactments.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (reenactment)
  static Future<int> createItem(String reenactmentName,
      String? reenactmentType,
      String? reenactmentSerialNumber,
      String? reenactmentObserved,
      String? reenactmentAim,
      String? reenactmentActivityArea,
      String? reenactmentPurpose,
      String? reenactmentWebPage,
      String? reenactmentComment) async {
    final db = await SQLHelperReenactment.db();

    final data = {'reenactmentName': reenactmentName,
      'reenactmentType': reenactmentType,
      'reenactmentSerialNumber': reenactmentSerialNumber,
      'reenactmentObserved': reenactmentObserved,
      'reenactmentAim': reenactmentAim,
      'reenactmentActivityArea': reenactmentActivityArea,
      'reenactmentPurpose': reenactmentPurpose,
      'reenactmentWebPage': reenactmentWebPage,
      'reenactmentComment': reenactmentComment};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (reenactments)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperReenactment.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperReenactment.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String reenactmentName,
      String? reenactmentType,
      String? reenactmentSerialNumber,
      String? reenactmentObserved,
      String? reenactmentAim,
      String? reenactmentActivityArea,
      String? reenactmentPurpose,
      String? reenactmentWebPage,
      String? reenactmentComment) async {
    final db = await SQLHelperReenactment.db();

    final data = {
      'reenactmentName': reenactmentName,
      'reenactmentType': reenactmentType,
      'reenactmentObserved': reenactmentObserved,
      'reenactmentAim': reenactmentAim,
      'reenactmentSerialNumber': reenactmentSerialNumber,
      'reenactmentActivityArea': reenactmentActivityArea,
      'reenactmentPurpose': reenactmentPurpose,
      'reenactmentWebPage': reenactmentWebPage,
      'reenactmentComment': reenactmentComment,
      'createdAt': DateTime.now().toString()
    };
    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperReenactment.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
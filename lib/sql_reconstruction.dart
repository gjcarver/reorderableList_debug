import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperReconstruction {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        reconstructionName TEXT,
        reconstructionType TEXT,
        reconstructionSerialNumber TEXT,
        reconstructionReference TEXT,
        reconstructionAim TEXT,
        reconstructionActivityArea TEXT,
        reconstructionPurpose TEXT,
        reconstructionWebPage TEXT,
        reconstructionComment TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// reconstructionName, reconstructionType: name and reconstructionType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'reconstructions.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (reconstruction)
  static Future<int> createItem(String reconstructionName,
      String? reconstructionType,
      String? reconstructionSerialNumber,
      String? reconstructionReference,
      String? reconstructionAim,
      String? reconstructionActivityArea,
      String? reconstructionPurpose,
      String? reconstructionWebPage,
      String? reconstructionComment) async {
    final db = await SQLHelperReconstruction.db();

    final data = {'reconstructionName': reconstructionName,
      'reconstructionType': reconstructionType,
      'reconstructionSerialNumber': reconstructionSerialNumber,
      'reconstructionReference': reconstructionReference,
      'reconstructionAim': reconstructionAim,
      'reconstructionActivityArea': reconstructionActivityArea,
      'reconstructionPurpose': reconstructionPurpose,
      'reconstructionWebPage': reconstructionWebPage,
      'reconstructionComment': reconstructionComment};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (reconstructions)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperReconstruction.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperReconstruction.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String reconstructionName,
      String? reconstructionType,
      String? reconstructionSerialNumber,
      String? reconstructionReference,
      String? reconstructionAim,
      String? reconstructionActivityArea,
      String? reconstructionPurpose,
      String? reconstructionWebPage,
      String? reconstructionComment) async {
    final db = await SQLHelperReconstruction.db();

    final data = {
      'reconstructionName': reconstructionName,
      'reconstructionType': reconstructionType,
      'reconstructionReference': reconstructionReference,
      'reconstructionAim': reconstructionAim,
      'reconstructionSerialNumber': reconstructionSerialNumber,
      'reconstructionActivityArea': reconstructionActivityArea,
      'reconstructionPurpose': reconstructionPurpose,
      'reconstructionWebPage': reconstructionWebPage,
      'reconstructionComment': reconstructionComment,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperReconstruction.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
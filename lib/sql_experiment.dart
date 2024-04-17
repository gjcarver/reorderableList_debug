import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperExperiments {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        experimentName TEXT,
        experimentType TEXT,
        experimentSerialNumber TEXT,
        experimentActivityArea TEXT,
        experimentPurpose TEXT,
        experimentWebPage TEXT,
        experimentComment TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }



// id: the id of a item
// experimentName, experimentType: name and experimentType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'experiments.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (experiment)
  static Future<int> createItem(String experimentName,
      String? experimentType,
      String? experimentSerialNumber,
      String? experimentActivityArea,
      String? experimentPurpose,
      String? experimentWebPage,
      String? experimentComment) async {
    final db = await SQLHelperExperiments.db();

    final data = {'experimentName': experimentName,
      'experimentType': experimentType,
      'experimentSerialNumber': experimentSerialNumber,
      'experimentActivityArea': experimentActivityArea,
      'experimentPurpose': experimentPurpose,
      'experimentWebPage': experimentWebPage,
      'experimentComment': experimentComment};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (experiments)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperExperiments.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperExperiments.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String experimentName,
      String? experimentType,
      String? experimentSerialNumber,
      String? experimentActivityArea,
      String? experimentPurpose,
      String? experimentWebPage,
      String? experimentComment) async {
    final db = await SQLHelperExperiments.db();

    final data = {
      'experimentName': experimentName,
      'experimentType': experimentType,
      'experimentSerialNumber': experimentSerialNumber,
      'experimentActivityArea': experimentActivityArea,
      'experimentPurpose': experimentPurpose,
      'experimentWebPage': experimentWebPage,
      'experimentComment': experimentComment,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperExperiments.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
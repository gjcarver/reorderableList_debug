import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperReplication {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        replicationName TEXT,
        replicationType TEXT,
        replicationSerialNumber TEXT,
        replicationReference TEXT,
        replicationAim TEXT,
        replicationActivityArea TEXT,
        replicationPurpose TEXT,
        replicationWebPage TEXT,
        replicationComment TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// replicationName, replicationType: name and replicationType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'replications.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (replication)
  static Future<int> createItem(String replicationName,
      String? replicationType,
      String? replicationSerialNumber,
      String? replicationReference,
      String? replicationAim,
      String? replicationActivityArea,
      String? replicationPurpose,
      String? replicationWebPage,
      String? replicationComment) async {
    final db = await SQLHelperReplication.db();

    final data = {'replicationName': replicationName,
      'replicationType': replicationType,
      'replicationSerialNumber': replicationSerialNumber,
      'replicationReference': replicationReference,
      'replicationAim': replicationAim,
      'replicationActivityArea': replicationActivityArea,
      'replicationPurpose': replicationPurpose,
      'replicationWebPage': replicationWebPage,
      'replicationComment': replicationComment};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (replications)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperReplication.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperReplication.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String replicationName,
      String? replicationType,
      String? replicationSerialNumber,
      String? replicationReference,
      String? replicationAim,
      String? replicationActivityArea,
      String? replicationPurpose,
      String? replicationWebPage,
      String? replicationComment) async {
    final db = await SQLHelperReplication.db();

    final data = {
      'replicationName': replicationName,
      'replicationType': replicationType,
      'replicationReference': replicationReference,
      'replicationAim': replicationAim,
      'replicationSerialNumber': replicationSerialNumber,
      'replicationActivityArea': replicationActivityArea,
      'replicationPurpose': replicationPurpose,
      'replicationWebPage': replicationWebPage,
      'replicationComment': replicationComment,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperReplication.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
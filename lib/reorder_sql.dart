import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperTasks {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        oldIndex INTEGER,
        newIndex INTEGER,
        designName TEXT,
        taskName TEXT,
        taskType TEXT,
        taskActivityArea TEXT,
        taskFunction TEXT,
        taskComment TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// taskName, taskType: name and taskType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'tasks5.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (task)
  static Future<int> createItem(
      int? oldIndex,
      int? newIndex,
      String designName,
      String taskName,
      String? taskType,
      String? taskActivityArea,
      String? taskFunction,
      String? taskComment) async {
    final db = await SQLHelperTasks.db();

    final data = {
      'oldIndex': oldIndex,
      'newIndex': newIndex,
      'designName': designName,
      'taskName': taskName,
      'taskType': taskType,
      'taskActivityArea': taskActivityArea,
      'taskFunction': taskFunction,
      'taskComment': taskComment};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

// Update the oldIndex and newIndex columns when the user reorders the items
  static Future<void> reorderItems(int oldIndex, int newIndex) async {
    final db = await SQLHelperTasks.db();

    // Update the newIndex column for the item that was moved
    await db.update('items', {'newIndex': newIndex}, where: "id = ?", whereArgs: [newIndex]);

    // Update the oldIndex column for the item that was moved
    await db.update('items', {'oldIndex': oldIndex}, where: "id = ?", whereArgs: [oldIndex]);

  }

  // Read all items (tasks)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperTasks.db();
    return db.query('items', orderBy: "newIndex");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperTasks.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id,
      int? oldIndex,
      int? newIndex,
      String designName,
      String taskName,
      String? taskType,
      String? taskActivityArea,
      String? taskFunction,
      String? taskComment) async {
    final db = await SQLHelperTasks.db();

    final data = {
      'oldIndex': oldIndex,
      'newIndex': newIndex,
      'designName': designName,
      'taskName': taskName,
      'taskType': taskType,
      'taskActivityArea': taskActivityArea,
      'taskFunction': taskFunction,
      'taskComment': taskComment,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperTasks.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
//      await db.update('items', id, where: 'id' = );
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

  static Future<List<Map<String, dynamic>>?> getDataWithMaxId() async {
    final db = await getInstance();
    final result = await db.rawQuery("SELECT * FROM items WHERE id = (SELECT MAX(id) FROM items)");
    return result;
  }


//  static Future<int?> getMaxId() async {
//    final db = await getInstance();
//    final result = await db.rawQuery("SELECT MAX(id) as max_id FROM items");
//    if (result.isNotEmpty) {
//      return result.first['max_id'] as int?;
//    } else {
//      return null;
//    }
//  }

//  // Read all items (tasks)
//  static Future<List<Map<String, dynamic>>> rawQuery() async {
//    final db = await SQLHelperTasks.db();
//    return db.query('SELECT MAX(id)+1 as id FROM items');
//  }
}
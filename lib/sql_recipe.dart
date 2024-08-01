import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelperRecipe {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        recipeName TEXT,
        recipeType TEXT,
        recipeReference TEXT,
        recipeAim TEXT,
        recipeSerialNumber TEXT,
        recipeActivityArea TEXT,
        recipePurpose TEXT,
        recipeWebPage TEXT,
        recipeComment TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// recipeName, recipeType: name and recipeType of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'recipes.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new item (recipe)
  static Future<int> createItem(String recipeName,
      String? recipeType,
      String? recipeReference,
      String? recipeAim,
      String? recipeSerialNumber,
      String? recipeActivityArea,
      String? recipePurpose,
      String? recipeWebPage,
      String? recipeComment) async {
    final db = await SQLHelperRecipe.db();

    final data = {'recipeName': recipeName,
      'recipeType': recipeType,
      'recipeReference': recipeReference,
      'recipeAim': recipeAim,
      'recipeSerialNumber': recipeSerialNumber,
      'recipeActivityArea': recipeActivityArea,
      'recipePurpose': recipePurpose,
      'recipeWebPage': recipeWebPage,
      'recipeComment': recipeComment};
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (recipes)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelperRecipe.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelperRecipe.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // Update an item by id
  static Future<int> updateItem(
      int id, String recipeName,
      String? recipeType,
      String? recipeReference,
      String? recipeAim,
      String? recipeSerialNumber,
      String? recipeActivityArea,
      String? recipePurpose,
      String? recipeWebPage,
      String? recipeComment) async {
    final db = await SQLHelperRecipe.db();

    final data = {
      'recipeName': recipeName,
      'recipeType': recipeType,
      'recipeReference': recipeReference,
      'recipeAim': recipeAim,
      'recipeSerialNumber': recipeSerialNumber,
      'recipeActivityArea': recipeActivityArea,
      'recipePurpose': recipePurpose,
      'recipeWebPage': recipeWebPage,
      'recipeComment': recipeComment,
      'createdAt': DateTime.now().toString()
    };

    final result =
    await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelperRecipe.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;
import 'package:sqflite/sqlite_api.dart';

class DBHelper {
  static Future<Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'ami.db'),
        onCreate: (db, version) {
      db.execute(
          'CREATE TABLE activities(id TEXT PRIMARY KEY, name TEXT, start REAL, end REAL, color TEXT, isDone INTEGER, date TEXT, serial INTEGER, emoji TEXT)');
      db.execute(
          'CREATE TABLE night(id TEXT PRIMARY KEY, start REAL, end REAL, color TEXT)');
    }, version: 2);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  static Future<void> update(String table, Map<String, Object> data, id) async {
    final db = await DBHelper.database();
    db.update(table, data, where: 'id = ?', whereArgs: [id]);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    return db.query(table);
  }

  static Future<int> delete(String id) async {
    final db = await DBHelper.database();
    return db.delete('activities', where: 'id = ?', whereArgs: [id]);
  }
}

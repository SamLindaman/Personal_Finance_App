import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart' as sql;

class DatabaseHelper {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'transactions.db'),
        onCreate: (db, version) {
      return db.execute(
          'CREATE TABLE transactions(_id INTEGER PRIMARY KEY, title TEXT NOT NULL, amount REAL NOT NULL, expenseType INTEGER NOT NULL, date TEXT NOT NULL)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DatabaseHelper.database();
    db.insert('transactions', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
  }

  static Future<List<Map<String, Object>>> getTransactionFromDB(
      String table) async {
    final db = await DatabaseHelper.database();
    return db.query(table);
  }

  static Future<void> delete(int id) async {
    final db = await DatabaseHelper.database();
    await db.delete('transactions', where: '_id = ?', whereArgs: [id]);
  }
}

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../../main.dart';

class DBHelper{
  static const _dbName = 'todo.db';
  static const _dbVersion = 1;
  static const _table = 'todo';
  static const _todoTitle = 'todoTitle';
  static const _todo = 'todo';
  static const _todoId = 'todoId';
  static const _uuid = 'uuid';

  Database? _db;

  Future<void> init() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _dbName);
    _db = await openDatabase(
      path,
      version: _dbVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $_table (
        $_todoId INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
            $_todoTitle TEXT,
            $_todo TEXT,
            $_uuid TEXT)''');
  }

  Future<int?> insert(String? title, String? todo, String? uuid) async {
    return await _db?.insert(
      _table,
      {
        _todoTitle: title,
        _todo: todo,
        _uuid: uuid,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Map<String, dynamic>>?> queryAllRows() async {
    return await _db?.query(_table);
  }

  Future<int?> update(int? columnId, String? title, String? todo) async {
    return await _db?.update(
      _table,
      {
        _todoId: columnId,
        _todoTitle: title,
        _todo: todo,
      },
      where: '$_todoId = ?',
      whereArgs: [columnId],
    );
  }

  Future<int?> delete(int columnId) async {
    return await _db?.delete(
      _table,
      where: '$_todoId = ?',
      whereArgs: [columnId],
    );
  }

  Future fetchWordsFromDB() async {
    final List<Map<String, dynamic>>? maps = await dbHelper.queryAllRows();
    return maps?.toList();
  }
}
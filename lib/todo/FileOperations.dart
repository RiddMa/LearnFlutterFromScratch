import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Main.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:async';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  static final DBProvider _instance = new DBProvider.internal();

  factory DBProvider() => _instance;

  final String dbName = 'TodoDB.db';
  final String tableName = 'todos';

  static var _db;

  DBProvider.internal();

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDB();
    return _db;
  }

  initDB() async {
    String databasesPath = await getDatabasesPath();
    String path = join(databasesPath, dbName);
    var db = await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
      onUpgrade: _onUpgrade,
    );
    return db;
  }

  Future _onCreate(Database db, int version) async {
    return await db.execute('CREATE TABLE todos('
        'key TEXT PRIMARY KEY,'
        'title TEXT,'
        'isAllDay INTEGER,'
        'dueDate TEXT,'
        'repeat TEXT,'
        'remind TEXT,'
        'note TEXT,'
        'done INTEGER'
        ')');
  }

  Future _onUpgrade(Database db, int oldVersion, int newVersion) async {}

  Future<int> insertTodoItem(TodoItem todoItem) async {
    final _dbClient = await db;
    final result = await _dbClient.insert(
      tableName,
      todoItem.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<TodoItem>> getAllTodoItems() async {
    final _dbClient = await db;
    final List<Map<String, dynamic>> todoJson = await _dbClient.query(tableName);

    return List.generate(todoJson.length, (index) {
      return TodoItem(
        key: Key(todoJson[index]['key']),
        title: todoJson[index]['title'],
        isAllDay: (todoJson[index]['isAllDay'] == 1 ? true : false),
        dueDate: DateTime.parse(todoJson[index]['dueDate']),
        repeat: todoJson[index]['repeat'],
        remind: todoJson[index]['remind'],
        note: todoJson[index]['note'],
        done: (todoJson[index]['done'] == 1 ? true : false),
      );
    });
  }

  Future<int> updateTodoItem(TodoItem todoItem) async {
    final _dbClient = await db;
    final result = await _dbClient.update(
      tableName,
      todoItem.toJson(),
      where: 'key=?',
      whereArgs: [todoItem.key.toString().substring(3, 29)],
    );
    return result;
  }

  Future<int> deleteTodoItem(TodoItem todoItem) async {
    final _dbClient = await db;
    final result = await _dbClient.delete(
      tableName,
      where: 'key=?',
      whereArgs: [todoItem.key.toString().substring(3, 29)],
    );
    return result;
  }

// // FileOperation(){
// //   WidgetsFlutterBinding.ensureInitialized();
// // };
// // Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
//
// // void saveTodoItem(TodoItem todoItem) async {
// //   final SharedPreferences prefs = await _prefs;
// //   final List<String> entryList = [
// //     todoItem.key.toString(),
// //     todoItem.title,
// //     todoItem.isAllDay.toString(),
// //     todoItem.dueDate.toString(),
// //     todoItem.repeat,
// //     todoItem.remind,
// //     todoItem.note,
// //     todoItem.done.toString(),
// //   ];
// //   prefs.setStringList(entryList[0], entryList);
// // }
//
// // Future<Database> openDB() async {
// //   final database = openDatabase(
// //     join(await getDatabasesPath(), dbName),
// //     onCreate: (db, version) {
// //       return
// //     },
// //     version: 1,
// //   );
// //   return database;
// // }
}

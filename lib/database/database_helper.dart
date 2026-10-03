import 'package:flutter/foundation.dart';
import 'package:path/path.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';

import '../models/todo.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();

  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await _initDB('todo.db');

    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    if (kIsWeb) {
      databaseFactory = databaseFactoryFfiWebNoWebWorker;
    } else if (defaultTargetPlatform == TargetPlatform.linux ||
        defaultTargetPlatform == TargetPlatform.macOS ||
        defaultTargetPlatform == TargetPlatform.windows) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final path = kIsWeb ? filePath : join(await getDatabasesPath(), filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        nama_tugas TEXT NOT NULL,
        deskripsi TEXT NOT NULL,
        kategori TEXT NOT NULL,
        isCompleted INTEGER NOT NULL
      )
    ''');
  }

  // TAMBAH DATA
  Future<int> insertTodo(Todo todo) async {
    final db = await instance.database;

    return await db.insert('todos', todo.toMap());
  }

  // AMBIL SEMUA DATA
  Future<List<Todo>> getTodos() async {
    final db = await instance.database;

    final result = await db.query('todos', orderBy: 'id DESC');

    return result.map((map) => Todo.fromMap(map)).toList();
  }

  // UPDATE DATA
  Future<int> updateTodo(Todo todo) async {
    final db = await instance.database;

    return await db.update(
      'todos',
      todo.toMap(),
      where: 'id = ?',
      whereArgs: [todo.id],
    );
  }

  // HAPUS DATA
  Future<int> deleteTodo(int id) async {
    final db = await instance.database;

    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }
}

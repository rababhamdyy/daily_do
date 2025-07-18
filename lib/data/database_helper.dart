import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import '../models/task_model.dart';

class DatabaseHelper {
  static const _databaseName = 'tasks.db';
  static const _databaseVersion = 1;
  static const table = 'tasks';

  static const columnId = 'id';
  static const columnTitle = 'title';
  static const columnDescription = 'description';
  static const columnDueDate = 'dueDate';
  static const columnDueTime = 'dueTime';
  static const columnIsCompleted = 'isCompleted';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path = join(documentsDirectory.path, _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnTitle TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnDueDate TEXT NOT NULL,
        $columnDueTime TEXT NOT NULL,
        $columnIsCompleted INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertTask(TaskModel task) async {
    final db = await instance.database;
    return await db.insert(table, _taskToMap(task));
  }

  Future<List<TaskModel>> getAllTasks() async {
    final db = await instance.database;
    final List<Map<String, dynamic>> maps = await db.query(table);
    return List.generate(maps.length, (i) => _mapToTask(maps[i]));
  }

  Future<int> updateTask(TaskModel task) async {
    try {
      final db = await instance.database;
      return await db.update(
        table,
        _taskToMap(task),
        where: '$columnId = ?',
        whereArgs: [task.id],
      );
    } catch (e) {
      debugPrint('Error updating task: $e');
      rethrow;
    }
  }

  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }

  Map<String, dynamic> _taskToMap(TaskModel task) {
    return {
      columnTitle: task.title,
      columnDescription: task.description,
      columnDueDate: task.dueDate,
      columnDueTime: task.dueTime,
      columnIsCompleted: task.isCompleted ? 1 : 0,
    };
  }

  TaskModel _mapToTask(Map<String, dynamic> map) {
    return TaskModel(
      id: map[columnId],
      title: map[columnTitle],
      description: map[columnDescription],
      dueDate: map[columnDueDate],
      dueTime: map[columnDueTime],
      isCompleted: map[columnIsCompleted] == 1,
    );
  }
}

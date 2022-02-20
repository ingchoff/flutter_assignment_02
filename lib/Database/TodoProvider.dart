import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:todo/Model/todo.dart';

class TodoProvider {
  static final TodoProvider instance = TodoProvider._init();

  static Database? _database;

  TodoProvider._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('todos.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    final boolType = 'BOOLEAN NOT NULL';
    final textType = 'TEXT NOT NULL';

    await db.execute('''
      CREATE TABLE $tableTodo (
      ${TodoFields.id} $idType,
      ${TodoFields.title} $textType,
      ${TodoFields.done} $boolType
      )''');
  }

  Future<Todo> create(Todo todo) async {
    final db = await instance.database;

    final id = await db.insert(tableTodo, todo.toJson());
    return todo.copy(id: id);
  }

  Future<Todo> readTodo(int id) async {
    final db = await instance.database;

    final maps = await db.query(tableTodo,
        columns: TodoFields.values,
        where: '${TodoFields.id} = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return Todo.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found.');
    }
  }

  Future<List<Todo>> readAllTodos(int done) async {
    final db = await instance.database;
    final result = await db.query(tableTodo, where: '${TodoFields.done} = ?', whereArgs: [done]);

    return result.map((json) => Todo.fromJson(json)).toList();
  }

  Future<int> update(Todo todo) async {
    final db = await instance.database;

    return db.update(
      tableTodo,
      todo.toJson(),
      where: '${TodoFields.id} = ?',
      whereArgs: [todo.id]
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return db.delete(
      tableTodo,
      where: '${TodoFields.id} = ?',
      whereArgs: [id]
    );
  }

  Future<int> deleteAll(int done) async {
    final db = await instance.database;

    return db.delete(tableTodo, where: '${TodoFields.done} = ?', whereArgs: [done]);
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}

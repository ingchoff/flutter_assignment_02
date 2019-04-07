import 'dart:io' as io;
import 'package:flutter_assignment_02/Model/Todo.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

class TodoProvider{
  static Database db_instance;
  final String TABLE_NAME = 'todo';

  Future<Database> get db async{
    if(db_instance == null){
      db_instance = await initDB();
    }
    return db_instance;
  }

  initDB() async{
    io.Directory documentDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentDirectory.path, 'Todo.db');
    var db = await openDatabase(path,version: 1,onCreate: onCreate);
    return db;
  }

  void onCreate(Database db, int version) async {
    //create table
    await db.execute(
      'CREATE TABLE $TABLE_NAME(_id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, done INTERGER NOT NULL)'
      );
  }

  Future<List<Todo>> getTodo(int done) async {
    var dbConnection = await db;
    List<Map> list = await dbConnection.rawQuery(
      'SELECT * FROM $TABLE_NAME WHERE done=$done'
    );
    List<Todo> todos = new List();
    for(int i = 0;i<list.length;i++){
      Todo todo = new Todo();
      todo.id = list[i]['_id'];
      todo.title = list[i]['title'];
      todo.done = list[i]['done']==1;
      todos.add(todo);
    }
    return todos;
  }

  void addTodo(Todo todo) async {
    var dbConnection = await db;
    String query = 'INSERT INTO $TABLE_NAME(title, done) VALUES(\'${todo.title}\', ${todo.done==true?1:0})';
    print(query);
    await dbConnection.transaction((transaction) async {
      return await transaction.rawInsert(query);
    });
  }

  void updateTodo(Todo todo) async {
    var dbConnection = await db;
    String query = 'UPDATE $TABLE_NAME SET title=\'${todo.title}\',done=\'${todo.done==true?1:0}\' WHERE _id=${todo.id}';
    print(query);
    await dbConnection.transaction((transaction) async {
      return await transaction.rawUpdate(query);
    });
  }

  void deleteTodo() async {
    var dbConnection = await db;
    String query = 'DELETE FROM $TABLE_NAME WHERE done=1';
    print(query);
    await dbConnection.transaction((transaction) async {
      return await transaction.rawQuery(query);
    });
  }

}
import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/Database/TodoProvider.dart';
import 'package:flutter_assignment_02/Model/Todo.dart';
import 'package:flutter_assignment_02/NewTodo.dart';

class TaskPage extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _TaskPageState();
  }
}

class _TaskPageState extends State<TaskPage> {

  TodoProvider todoProvider = TodoProvider();
  Future<List<Todo>> todoList;
  int count = 0;
  List<bool> inputs = new List<bool>();
  
  @override
  void initState() {
    setState(() {
        for(int i=0;i<20;i++){
          inputs.add(false);
        }
      });
    super.initState();
  }
 
  void ItemChange(bool val,int index){
    setState(() {
      inputs[index] = val;
    });
  }

  Future<List<Todo>> getTodoFromDB() async {
    var todoProvider = TodoProvider();
    Future<List<Todo>> todos = todoProvider.getTodo(0);
    return todos;
  }

  Widget setUpLayoutChild() {
    return new Container(
      padding: EdgeInsets.all(10.0),
      child: FutureBuilder<List<Todo>>(
        future: updateListView(),
        builder: (context, snapshot){
          if(snapshot.data != null){
            if(snapshot.data.length != 0){
              return ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (context,index) {
                  return Card(
                    color: Colors.white,
                    elevation: 2.0,
                    child: CheckboxListTile(
                      title: Text(snapshot.data[index].title,style: TextStyle(fontWeight: FontWeight.bold)),
                      value: inputs[index],
                      onChanged: (bool value) {
                        ItemChange(value, index);
                        Todo todo = new Todo();
                        todo.id = snapshot.data[index].id;
                        todo.title = snapshot.data[index].title;
                        todo.done = inputs[index];
                        todoProvider.updateTodo(todo);
                        ItemChange(false, index);
                        getTodoFromDB();
                      },
                    ),
                  );
                },
              );
            }else{
              return Center(child: Text('No data found..', style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)));
            }
          }else{
            return Center(child: Text(''));
          }
        },
      ),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Todo'),
        actions: <Widget>[
          new IconButton(
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context) => NewTodo()));
            },
            icon: Icon(Icons.add),
          )
        ],
      ),
      body: setUpLayoutChild()
    );
  }
  Future<List<Todo>> updateListView() {
    setState(() {
      todoList = todoProvider.getTodo(0);
    });
    return todoList;
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/Database/TodoProvider.dart';
import 'package:flutter_assignment_02/Model/Todo.dart';

class CompPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _CompPageState();
  }
}

class _CompPageState extends State<CompPage> {
  TodoProvider todoProvider = TodoProvider();
  bool valChange;
  Future<List<Todo>> todoList;
  int count = 0;
  List<bool> inputs = new List<bool>();
  
  @override
  void initState() {
    updateListView();
    updateListView().then((list){
      setState(() {
        for(int i=0;i<list.length;i++){
          inputs.add(list[i].done);
        }
      });
    });
    super.initState();
  }
 
  void ItemChange(bool val,int index){
    setState(() {
      inputs[index] = val;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (todoList == null){
      updateListView();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('To Do'),
        actions: <Widget>[
          new IconButton(
            onPressed: (){
              todoProvider.deleteTodo();
              updateListView();
            },
            icon: Icon(Icons.delete),
          )
        ],
      ),
      body: new Container(
        padding: EdgeInsets.all(10.0),
        child: FutureBuilder<List<Todo>>(
          future: todoList,
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
                          ItemChange(true, index);
                          updateListView();
                        },
                      )
                    );
                        },
                );
              }else{
                return Center(
                  child: Text("No data found..", style: TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                );
              }
            }else{
              return Center(
                child: Text(""),
              );
            }
          },
        ),
      )
    );
  }

  Future<List<Todo>> updateListView() {
    setState(() {
      todoList = todoProvider.getTodo(1);
    });
    return todoList;
  }
}
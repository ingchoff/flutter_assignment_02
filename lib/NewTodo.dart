import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/Database/TodoProvider.dart';
import 'package:flutter_assignment_02/Model/Todo.dart';

class NewTodo extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _NewTodoState();
  }
}

class _NewTodoState extends State<NewTodo> {
  
  TodoProvider todoProvider = TodoProvider();

  final scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  final textValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Subject'),
      ),
      body: Form(
        key: _formkey,
        child: ListView(
          padding: EdgeInsets.only(left: 10.0,right: 10.0,top: 10.0),
          children: <Widget>[
            TextFormField(
              controller: textValue,
              validator: (String value){
                if (value.isEmpty) {
                  return 'Please fill subject';
                }
              },
              keyboardType: TextInputType.text,
              decoration: InputDecoration(
                labelText: 'Subject'
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 15),
              child: SizedBox(
                height: 40,
                child: RaisedButton(
                  onPressed: saveTask,
                  child: Text('Save', style: TextStyle(fontSize: 16)),
                ),
              ),
            ) 
          ],
        ) 
      )
    );
  }

  void saveTask() {
    final formState = _formkey.currentState;
    if (formState.validate()){
      formState.save();
      var todo = Todo();
      todo.title = textValue.text;
      todo.done = false;
      todoProvider.addTodo(todo);
      Navigator.pop(context);
    }
  }

}
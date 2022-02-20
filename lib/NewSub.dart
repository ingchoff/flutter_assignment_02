import 'package:flutter/material.dart';
import 'package:todo/Database/TodoProvider.dart';
import 'package:todo/Model/todo.dart';
import 'package:todo/MyHomePage.dart';
import 'package:todo/TaskPage.dart';

class NewSub extends StatefulWidget {
  const NewSub({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _NewSubState();
  }
}

class _NewSubState extends State<NewSub> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final _formkey = GlobalKey<FormState>();
  final textValue = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Subject'),
        ),
        body: Form(
            key: _formkey,
            child: ListView(
              padding:
                  const EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
              children: <Widget>[
                TextFormField(
                  controller: textValue,
                  validator: (String? value) {
                    if (value!.isEmpty) {
                      return 'Please fill subject';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.text,
                  decoration: const InputDecoration(labelText: 'Subject'),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: SizedBox(
                    height: 40,
                    child: ElevatedButton(
                      onPressed: saveTask,
                      child: const Text('Save'),
                    ),
                  ),
                )
              ],
            )));
  }

  void saveTask() async {
    final formState = _formkey.currentState;
    if (formState!.validate()) {
      formState.save();
      final todo = Todo(title: textValue.text, done: false);
      await TodoProvider.instance.create(todo);
      Navigator.of(context).pop();
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const MyHomePage()),
      // );
    }
  }
}

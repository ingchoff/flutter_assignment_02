import 'package:flutter/material.dart';
import 'package:todo/Database/TodoProvider.dart';
import 'package:todo/Model/todo.dart';

class CompPage extends StatefulWidget {
  const CompPage({Key? key}) : super(key: key);
  
  @override
  State<StatefulWidget> createState() => _CompPageState();
}

class _CompPageState extends State<CompPage> {
  late List<Todo> todos;
  bool isLoading = false;
  late List<bool> listDone;

  @override
  void initState() {
    super.initState();
    getTodoFromDB();
  }

  Future getTodoFromDB() async {
    setState(() => isLoading = true);
    this.todos = await TodoProvider.instance.readAllTodos(1);
    this.listDone = [];
    for (int i=0;i<this.todos.length;i++) {
      this.listDone.add(this.todos[i].done);
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('To Do'),
          actions: <Widget>[
            IconButton(
              onPressed: () {
                TodoProvider.instance.deleteAll(1);
                getTodoFromDB();
              },
              icon: const Icon(Icons.delete),
            )
          ],
        ),
        body: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : todos.isEmpty
                    ? const Text(
                        'No Completed Todo',
                        style: TextStyle(fontSize: 24),
                      )
                    : Container(
                        padding: const EdgeInsets.all(16.0),
                        child: ListView.builder(
                            itemCount: todos.length,
                            itemBuilder: (context, index) {
                              final todo = todos[index];
                              return Card(
                                color: Colors.white,
                                elevation: 2.0,
                                child: CheckboxListTile(
                                  title: Text(todo.title, style: const TextStyle(fontWeight: FontWeight.bold)),
                                  value: listDone[index],
                                  onChanged: (bool? value) {
                                    setState(() {
                                      listDone[index] = value!;
                                    });
                                    Todo newTodo = Todo(id: todo.id, title: todo.title, done: listDone[index]);
                                    TodoProvider.instance.update(newTodo);
                                    getTodoFromDB();
                                  },
                                )
                              );
                            }))));
  }
}
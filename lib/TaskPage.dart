import 'package:flutter/material.dart';
import 'package:todo/Database/TodoProvider.dart';
import 'package:todo/Model/todo.dart';
import 'package:todo/NewSub.dart';

class TaskPage extends StatefulWidget {
  const TaskPage({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return _TaskPageState();
  }
}

class _TaskPageState extends State<TaskPage> {
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
    this.todos = await TodoProvider.instance.readAllTodos(0);
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
                MaterialPageRoute materialPageRoute = MaterialPageRoute(builder: (BuildContext buuldContext) {
                  return NewSub();
                });
                Navigator.of(context).push(materialPageRoute).then((value) {
                  getTodoFromDB();
                });
              },
              icon: const Icon(Icons.add),
            )
          ],
        ),
        body: Center(
            child: isLoading
                ? const CircularProgressIndicator()
                : todos.isEmpty
                    ? const Text(
                        'No Todo',
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
                                      // print(value);
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
  // void createListDone(List<Todo> todo) async {
  //   for (int i=0;i<todo.length;i++) {
  //     listDone.add(false);
  //   }
  // }
}

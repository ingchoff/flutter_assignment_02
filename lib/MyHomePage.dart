import 'package:flutter/material.dart';
import 'package:todo/CompPage.dart';
import 'package:todo/TaskPage.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final List<Widget> _list = [const TaskPage(), const CompPage()];
    return Scaffold(
      bottomNavigationBar: Theme(
        data: ThemeData(backgroundColor: Colors.cyan),
        child: BottomNavigationBar(
          currentIndex: selectedIndex,
          items: [
            BottomNavigationBarItem(
                // ignore: prefer_const_constructors
                icon: Icon(Icons.list),
                label: 'Task'),
            BottomNavigationBarItem(
                icon: Icon(Icons.done_all), label: 'Complete')
          ],
          onTap: (index) => setState(() {
            selectedIndex = index;
          }),
        ),
      ),
      body: _list[selectedIndex],
    );
  }
}

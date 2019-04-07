import 'package:flutter/material.dart';
import 'package:flutter_assignment_02/CompPage.dart';
import 'package:flutter_assignment_02/TaskPage.dart';

class MainPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MainPageState();
  }
}

class _MainPageState extends State<MainPage> {
  int index = 0;
  List<Widget> _list = [
    TaskPage(),
    CompPage()
  ];

  void _navHandler(int index) {
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: Theme(
        data: ThemeData(
          backgroundColor: Colors.cyan
        ),
        child: BottomNavigationBar(
          currentIndex: index,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Task')
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.done_all),
              title: Text('Complete')
            )
          ],
          onTap: _navHandler,
        ),
      ),
      body: _list[index],
    );
  }
}
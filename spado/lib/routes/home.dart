import 'package:flutter/material.dart';
import '../header.dart';
import '../todo_add_page.dart';
import "../service.dart";

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String screenName = 'ホーム'; // headerに表示される名前
  List<String> toDoList = []; // タスクのリスト

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(headerTitle: screenName),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(toDoList[index]),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () {
                setState(() {
                  toDoList.removeAt(index);
                });
              },
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return ToDoAddPage();
            }),
          );
          if (newListText != null) {
            setState(() {
              final db = FirestoreService();
              final test = db.getTasksByUsername("tanaka");
              print(test);
            });
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

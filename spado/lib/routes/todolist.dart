import 'package:flutter/material.dart';
import '../header.dart';
import '../todo_add_page.dart';
import "../service.dart";
import 'package:carousel_slider/carousel_slider.dart';

class Todo extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Todo> {
  final String screenName = 'todoリスト';
  List<Map<String, String>> toDoList = [];
  List<String> friendList = [
    "Tanaka",
    "Suzuki",
    "Yamada",
    "Kobayashi"
  ]; // 友達リスト

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  Future<void> _loadToDoList() async {
    // Firestoreからタスクをロードする処理を追加
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(headerTitle: screenName),
      body: Column(
        children: [
          // カルーセルで友達リストを表示
          CarouselSlider(
            options: CarouselOptions(
              height: 50,
              autoPlay: true,
              autoPlayInterval: Duration(seconds: 3),
              viewportFraction: 0.3,
              enlargeCenterPage: true,
            ),
            items: friendList.map((friend) {
              return Builder(
                builder: (BuildContext context) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    margin: EdgeInsets.symmetric(horizontal: 5.0),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Center(
                      child: Text(
                        friend,
                        style: TextStyle(fontSize: 16.0, color: Colors.white),
                      ),
                    ),
                  );
                },
              );
            }).toList(),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(toDoList[index]['taskName']!),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      final taskId = toDoList[index]['taskId']!;
                      final db = FirestoreService();
                      await db.deleteTaskFromCurrentUser(taskId);

                      setState(() {
                        toDoList.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newListText = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return ToDoAddPage();
            }),
          );
          if (newListText != null) {
            final db = FirestoreService();
            await db.addTaskToCurrentUser(newListText);
            _loadToDoList();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

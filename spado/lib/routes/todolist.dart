import 'package:flutter/material.dart';
import '../header.dart';
import '../todo_add_page.dart';
import "../service.dart";
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
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
    final db = FirestoreService();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        // Get the current user's username
        String? username = await db.getUsernameFromUserId(currentUser.uid);

        if (username != null) {
          // Fetch the tasks using the username
          final tasks = await db.getTasksByUsername(username);
          setState(() {
            toDoList = tasks;
          });
        } else {
          // Handle case where username is not found
          print('Username not found for current user.');
        }
      } catch (e) {
        // Handle any errors that occur during the process
        print('Error loading to-do list: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
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
              height: 60, // 高さを調整
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
                        style: TextStyle(
                            fontSize: 18.0, color: Colors.white), // サイズを調整
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
                  title: Text(toDoList[index]['task_name'] ?? ''),
                  trailing: IconButton(
                    icon: Icon(Icons.delete),
                    onPressed: () async {
                      final taskId = toDoList[index]['id']!;
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

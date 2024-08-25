import 'package:flutter/material.dart';
import '../header.dart';
import '../todo_add_page.dart';
import '../service.dart'; // FirestoreService をインポート
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Todo extends StatefulWidget {
  @override
  _TodoState createState() => _TodoState();
}

class _TodoState extends State<Todo> {
  final String screenName = 'todoリスト';
  List<Map<String, dynamic>> toDoList = [];
  List<Map<String, String>> friendList = []; // 友達リストのデータ構造を変更

  @override
  void initState() {
    super.initState();
    _loadToDoList();
    _loadFriendList(); // 友達リストをロード
  }

  Future<void> _loadToDoList() async {
    final db = FirestoreService();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        String? username = await db.getUsernameFromUserId(currentUser.uid);

        if (username != null) {
          final tasks = await db.getTasksByUsername(username);
          setState(() {
            toDoList = tasks;
          });
        } else {
          print('Username not found for current user.');
        }
      } catch (e) {
        print('Error loading to-do list: $e');
      }
    } else {
      print('No user is currently signed in.');
    }
  }

  Future<void> _loadFriendList() async {
    final db = FirestoreService();

    try {
      final friends = await db.getFriendsList();
      setState(() {
        friendList = friends;
      });
    } catch (e) {
      print('Error loading friend list: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(headerTitle: screenName),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // カルーセルで友達リストを表示
            CarouselSlider(
              options: CarouselOptions(
                height: 100,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 3),
                viewportFraction: 0.7,
                enlargeCenterPage: true,
              ),
              items: friendList.map((friend) {
                return Builder(
                  builder: (BuildContext context) {
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(horizontal: 5.0),
                      decoration: BoxDecoration(
                        color: Colors.blueAccent,
                        borderRadius: BorderRadius.circular(10),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 2,
                            blurRadius: 7,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          Positioned(
                            bottom: -10,
                            left: 20,
                            child: CustomPaint(
                              painter: TrianglePainter(),
                            ),
                          ),
                          Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    friend['username'] ?? 'Unknown',
                                    style: TextStyle(
                                      fontSize: 16.0,
                                      color: Colors.white,
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "頑張って!",
                                    style: TextStyle(
                                      fontSize: 20.0,
                                      color: Colors.white.withOpacity(0.8),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
              }).toList(),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: toDoList.length,
              itemBuilder: (context, index) {
                final task = toDoList[index];

                String dueDateText = '';
                if (task['dueDate'] != null) {
                  try {
                    dueDateText =
                        '期限: ${DateTime.parse(task['dueDate']).toLocal().toString().split(' ')[0]}';
                  } catch (e) {
                    dueDateText = '期限: 不明';
                    print('Invalid date format: ${task['dueDate']}');
                  }
                }

                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12.0),
                    title: Text(
                      task['title'] ?? 'タイトル未設定',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24.0,
                      ),
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (task['description'] != null &&
                            task['description'] != '')
                          Text(
                            task['description']!,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        if (dueDateText.isNotEmpty)
                          Text(
                            dueDateText,
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          ),
                        if (task['priority'] != null)
                          Text(
                            '優先度: ${task['priority']}',
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[700]),
                          ),
                      ],
                    ),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () async {
                        final taskId = task['id']!;
                        final db = FirestoreService();
                        await db.deleteTaskFromCurrentUser(taskId);

                        setState(() {
                          toDoList.removeAt(index);
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newTask = await Navigator.of(context).push(
            MaterialPageRoute(builder: (context) {
              return ToDoAddPage();
            }),
          );
          if (newTask != null) {
            final db = FirestoreService();
            await db.addTaskToCurrentUser(
              title: newTask['title'],
              description: newTask['description'],
              dueDate: newTask['dueDate'] != null
                  ? DateTime.parse(newTask['dueDate'])
                  : null,
              priority: newTask['priority'],
            );
            _loadToDoList();
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class TrianglePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = Colors.blueAccent
      ..style = PaintingStyle.fill;

    final Path path = Path()
      ..moveTo(0, 0)
      ..lineTo(10, -10)
      ..lineTo(20, 0)
      ..close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

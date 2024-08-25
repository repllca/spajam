import 'package:flutter/material.dart';
import '../service.dart'; // FirestoreService をインポート
import 'package:firebase_auth/firebase_auth.dart';

class TodoMessageScreen extends StatefulWidget {
  final String friendName;

  TodoMessageScreen({required this.friendName});

  @override
  _TodoMessageScreenState createState() => _TodoMessageScreenState();
}

class _TodoMessageScreenState extends State<TodoMessageScreen> {
  late Future<List<Map<String, dynamic>>> _tasksFuture;

  @override
  void initState() {
    super.initState();
    _tasksFuture = _loadTasks();
  }

  Future<List<Map<String, dynamic>>> _loadTasks() async {
    final db = FirestoreService();
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      try {
        // Fetch the tasks using the friend's name
        final tasks = await db.getTasksByUsername(widget.friendName);
        return tasks;
      } catch (e) {
        print('Error loading tasks: $e');
        return [];
      }
    } else {
      print('No user is currently signed in.');
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.friendName}のTODOリスト'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _tasksFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('エラーが発生しました: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('TODOリストはありません。'));
          } else {
            final tasks = snapshot.data!;
            return ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return Container(
                  margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent, // ToDoの背景色
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3), // 影の位置
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: EdgeInsets.all(12.0),
                    title: Text(
                      task['task_name'] ?? 'タイトル未設定',
                      style: TextStyle(fontWeight: FontWeight.bold),
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
                        if (task['dueDate'] != null)
                          Text(
                            '期限: ${DateTime.parse(task['dueDate']).toLocal().toString().split(' ')[0]}',
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
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

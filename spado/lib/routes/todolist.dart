import 'package:flutter/material.dart';
import '../header.dart';
import '../todo_add_page.dart';
import "../service.dart";

class Todo extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Todo> {
  final String screenName = 'todoリスト'; // headerに表示される名前
  List<Map<String, String>> toDoList = []; // タスク名とドキュメントIDのリスト

  @override
  void initState() {
    super.initState();
    _loadToDoList(); // 初期化時にタスクリストをロード
  }

  Future<void> _loadToDoList() async {
    try {
      final db = FirestoreService();
      // 現在のユーザーのUIDを取得
      final userId = db.auth.currentUser?.uid;

      if (userId != null) {
        // UIDからユーザーネームを取得
        final username = await db.getUsernameFromUserId(userId);

        if (username != null) {
          // ユーザーネームでタスクを取得
          final tasks = await db.getTasksByUsername(username);
          setState(() {
            toDoList = tasks
                .map((task) {
                  if (task.containsKey('id') && task.containsKey('task_name')) {
                    return {
                      "taskId": task['id']!,
                      "taskName": task['task_name']!
                    };
                  } else {
                    print("タスクに必要なデータが含まれていません: $task");
                    return null;
                  }
                })
                .where((task) => task != null)
                .cast<Map<String, String>>()
                .toList();
          });
        } else {
          print("ユーザーネームが取得できませんでした。");
        }
      } else {
        print("ユーザーがサインインしていません。");
      }
    } catch (e) {
      print("タスクリストの読み込み中にエラーが発生しました: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(headerTitle: screenName),
      body: ListView.builder(
        itemCount: toDoList.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(toDoList[index]['taskName']!),
            trailing: IconButton(
              icon: Icon(Icons.delete),
              onPressed: () async {
                final taskId = toDoList[index]['taskId']!;
                final db = FirestoreService();
                await db.deleteTaskFromCurrentUser(taskId); // Firestoreから削除

                setState(() {
                  toDoList.removeAt(index); // UIからも削除
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
            final db = FirestoreService();
            await db.addTaskToCurrentUser(newListText);
            _loadToDoList(); // タスクリストを再読み込みして表示を更新
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

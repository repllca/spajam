import 'package:flutter/material.dart';
import '../todo_message.dart';

class TodoMessageScreen extends StatelessWidget {
  final String friendName;

  // コンストラクタで友達の名前を受け取る
  TodoMessageScreen({required this.friendName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('$friendNameのTODOリスト'),
      ),
      body: Center(
        child: Text(
          '$friendName のTODOリストを表示します。',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}

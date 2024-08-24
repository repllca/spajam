import 'package:flutter/material.dart';
import '../header.dart';
import '../todo_detail.dart'; // todo_detail.dart.dartをインポート

class Profile extends StatelessWidget {
  final String screenName = '友達リスト'; // headerに表示される名前
  final List<String> items = [
    '友達1',
    '友達2',
    '友達3',
    '友達4',
    '友達5', // DBから友達のTODOを取得、表示を行いたい
  ]; // 表示するリスト

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(headerTitle: screenName),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(items[index]),
            onTap: () {
              // タップしたらtodo_detail.dartに遷移
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => TodoMessageScreen(friendName: items[index]),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

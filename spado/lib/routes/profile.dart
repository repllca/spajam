import 'package:flutter/material.dart';
import '../header.dart';
import '../todo_detail.dart'; // todo_detail.dart をインポート
import '../service.dart'; // FirestoreService をインポート

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String screenName = '友達リスト'; // headerに表示される名前
  List<String> friends = []; // 友達リスト

  @override
  void initState() {
    super.initState();
    _loadFriendsList(); // 初期化時に友達リストをロード
  }

  Future<void> _loadFriendsList() async {
    try {
      final db = FirestoreService();
      final friendsList = await db.getFriendsList(); // 友達リストを取得
      setState(() {
        friends = friendsList
            .map((friend) => friend['username']!)
            .toList(); // ユーザーネームのリストに変換
      });
    } catch (e) {
      print("友達リストの読み込み中にエラーが発生しました: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: Header(headerTitle: screenName),
      body: ListView.builder(
        itemCount: friends.length,
        itemBuilder: (context, index) {
          return Container(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: Colors.blueGrey[50], // 背景色
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  spreadRadius: 1,
                  blurRadius: 5,
                  offset: Offset(0, 2), // 影の位置
                ),
              ],
            ),
            child: ListTile(
              contentPadding:
                  EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              title: Text(
                friends[index],
                style: TextStyle(fontSize: 18, color: Colors.black87),
              ),
              onTap: () {
                // タップしたら todo_detail.dart に遷移
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        TodoMessageScreen(friendName: friends[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}

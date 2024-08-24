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
          return ListTile(
            title: Text(friends[index]),
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
          );
        },
      ),
    );
  }
}

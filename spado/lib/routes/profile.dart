import 'package:flutter/material.dart';
import '../header.dart';
import '../todo_detail.dart';
import '../service.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final String screenName = '友達リスト';
  List<String> friends = [];

  @override
  void initState() {
    super.initState();
    _loadFriendsList();
  }

  Future<void> _loadFriendsList() async {
    try {
      final db = FirestoreService();
      final friendsList = await db.getFriendsList();
      setState(() {
        friends = friendsList.map((friend) => friend['username']!).toList();
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
            margin: EdgeInsets.symmetric(vertical: 5.0, horizontal: 10.0),
            decoration: BoxDecoration(
              color: Colors.lightBlueAccent, // 背景色を設定
              borderRadius: BorderRadius.circular(10), // 角を丸くする
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 7,
                  offset: Offset(0, 3), // 影を追加
                ),
              ],
            ),
            child: ListTile(
              title: Text(
                friends[index],
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
              onTap: () {
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

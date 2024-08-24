import 'package:flutter/material.dart';
import '../header.dart';

class Profile extends StatelessWidget {
  final String screenName = 'プロフィール'; // headerに表示される名前
  final List<String> items = [
    'アイテム1',
    'アイテム2',
    'アイテム3',
    'アイテム4',
    'アイテム5',
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
          );
        },
      ),
    );
  }
}

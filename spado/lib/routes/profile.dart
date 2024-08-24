import 'package:flutter/material.dart';

class Profile extends StatelessWidget {
  final String screenName = '友達リスト'; // headerに表示される名前

  final Map<String, List<String>> friendTasks = {
    '友達1': ['宿題を終わらせる', '研究を行う'],
    '友達2': ['会議に参加する', 'レポートを書く'],
    '友達3': ['ジムに行く', '夕食を作る'],
    '友達4': ['プレゼンの準備', '買い物をする'],
    '友達5': ['メールをチェックする', '映画を見る'],
  }; // 友達とそのタスクのリスト

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(screenName),
      ),
      body: ListView.builder(
        itemCount: friendTasks.length,
        itemBuilder: (context, index) {
          String friendName = friendTasks.keys.elementAt(index);
          List<String> tasks = friendTasks[friendName]!;

          return Card(
            margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    friendName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: tasks.map((task) {
                      return Text('- $task');
                    }).toList(),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: Profile(),
  ));
}

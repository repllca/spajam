import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/bottom_navigation_model.dart';
import 'routes/profile.dart';
import 'routes/home.dart';
import 'routes/settings.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List _pageList = [
    Profile(),
    Home(),
    Settings(),
  ];
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutterの練習', //アプリの名前
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: ChangeNotifierProvider<BottomNavigationModel>(
        create: (_) => BottomNavigationModel(),
        child:
            Consumer<BottomNavigationModel>(builder: (context, model, child) {
          return Scaffold(
            // appBar: Header(), //各ファイルでHeader()を実行するのでいらない
            body: _pageList[model.currentIndex], //中身を描画
            //footer部分
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'プロフィール',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'ホーム',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: '友達',
                ),
              ],
              currentIndex: model.currentIndex,
              onTap: (index) {
                model.currentIndex = index;
              },
              selectedItemColor: Colors.pinkAccent, //選んだ物の色
              unselectedItemColor: Colors.black45, //選んでない物の色
            ),
          );
        }),
      ),
    );
  }
}

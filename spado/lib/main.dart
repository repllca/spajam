import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/bottom_navigation_model.dart';
import 'routes/profile.dart';
import 'routes/home.dart';
import 'routes/settings.dart';
import 'routes/register.dart'; // Register.dart をインポート
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final List<Widget> _pageList = [
    Profile(),
    Home(),
    Settings(),
    RegisterPage(), // RegisterPage を追加
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutterの練習', // アプリの名前
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: ChangeNotifierProvider<BottomNavigationModel>(
        create: (_) => BottomNavigationModel(),
        child: Consumer<BottomNavigationModel>(
          builder: (context, model, child) {
            return Scaffold(
              // appBar: Header(), // 各ファイルでHeader()を実行するのでいらない
              body: _pageList[model.currentIndex], // 中身を描画
              // footer部分
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const <BottomNavigationBarItem>[
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
                    label: '設定',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.app_registration),
                    label: '登録',
                  ),
                ],
                currentIndex: model.currentIndex,
                onTap: (index) {
                  model.currentIndex = index;
                },
                selectedItemColor: Colors.pinkAccent, // 選んだ物の色
                unselectedItemColor: Colors.black45, // 選んでない物の色
              ),
            );
          },
        ),
      ),
    );
  }
}

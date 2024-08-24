import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/bottom_navigation_model.dart';
import 'routes/profile.dart';
import 'routes/home.dart';
import 'routes/settings.dart';
import 'routes/register.dart';
import 'routes/sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutterの練習',
      theme: ThemeData(
        primaryColor: Colors.green,
      ),
      home: AuthCheck(),
    );
  }
}

class AuthCheck extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        // ユーザーがログインしているか確認
        if (snapshot.connectionState == ConnectionState.waiting) {
          // ローディング中の表示
          return CircularProgressIndicator();
        } else if (snapshot.hasData) {
          // ログイン済みの場合
          return HomePage(); // ログイン済みの場合は通常のホーム画面に遷移
        } else {
          // 未ログインの場合
          return RegisterPage(); // 未ログインの場合は登録ページに遷移
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Widget> _pageList = [
    Profile(),
    Home(),
    Settings(),
    RegisterPage(),
    SignInPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BottomNavigationModel>(
      create: (_) => BottomNavigationModel(),
      child: Consumer<BottomNavigationModel>(
        builder: (context, model, child) {
          return Scaffold(
            body: _pageList[model.currentIndex],
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
                BottomNavigationBarItem(
                  icon: Icon(Icons.login),
                  label: 'サインイン',
                ),
              ],
              currentIndex: model.currentIndex,
              onTap: (index) {
                model.currentIndex = index;
              },
              selectedItemColor: Colors.pinkAccent,
              unselectedItemColor: Colors.black45,
            ),
          );
        },
      ),
    );
  }
}

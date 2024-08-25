import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/bottom_navigation_model.dart';
import 'routes/profile.dart';
import 'routes/todolist.dart';
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
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        // textTheme: TextTheme(
        //   headline6:
        //       TextStyle(color: Colors.black87, fontSize: 20), // アプリ全体の見出し6のサイズ
        //   bodyText1: TextStyle(
        //       color: Colors.black87, fontSize: 18), // デフォルトのボディテキスト1のサイズ
        //   bodyText2: TextStyle(
        //       color: Colors.black54, fontSize: 16), // デフォルトのボディテキスト2のサイズ
        // ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 24, // アプリバーのタイトルの文字サイズ
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 16), // ナビゲーションバーの選択ラベルのサイズ
          unselectedLabelStyle: TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 14), // ナビゲーションバーの非選択ラベルのサイズ
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.green,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // primary -> backgroundColor
            foregroundColor: Colors.white, // onPrimary -> foregroundColor
            textStyle: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 16), // ボタンのテキストサイズ
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
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
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasData) {
          return HomePage();
        } else {
          return RegisterPage();
        }
      },
    );
  }
}

class HomePage extends StatelessWidget {
  final List<Widget> _pageList = [
    Profile(),
    Todo(),
    SignInPage(), // 残りのページのみ
  ];

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<BottomNavigationModel>(
      create: (_) => BottomNavigationModel(),
      child: Consumer<BottomNavigationModel>(
        builder: (context, model, child) {
          return Scaffold(
            // appBar: AppBar(
            //   title: Text('todoリスト'),
            // ),
            body: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _pageList[model.currentIndex],
            ),
            bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: '応援ともだち',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'todoリスト',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.login),
                  label: 'サインアウト',
                ),
              ],
              currentIndex: model.currentIndex,
              onTap: (index) {
                model.currentIndex = index;
              },
            ),
          );
        },
      ),
    );
  }
}

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
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.white,
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Colors.black87),
          bodyMedium: TextStyle(color: Colors.black54),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Colors.green,
          elevation: 0,
          iconTheme: IconThemeData(color: Colors.white),
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Colors.white,
          selectedItemColor: Colors.green,
          unselectedItemColor: Colors.grey,
          selectedLabelStyle: TextStyle(fontWeight: FontWeight.bold),
          unselectedLabelStyle: TextStyle(fontWeight: FontWeight.normal),
        ),
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.green,
          textTheme: ButtonTextTheme.primary,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green, // primary -> backgroundColor
            foregroundColor: Colors.white, // onPrimary -> foregroundColor
            textStyle: TextStyle(fontWeight: FontWeight.bold),
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
            appBar: AppBar(
              title: Text('ホーム'),
            ),
            body: AnimatedSwitcher(
              duration: Duration(milliseconds: 300),
              child: _pageList[model.currentIndex],
            ),
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
            ),
          );
        },
      ),
    );
  }
}

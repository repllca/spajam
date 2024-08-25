import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void> _signIn() async {
    try {
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      );
      print("ログイン成功: ${userCredential.user!.uid}");
      // ログイン成功後の処理を追加
    } catch (e) {
      print("ログインエラー: $e");
    }
  }

  Future<void> _signOut() async {
    try {
      await _auth.signOut();
      print("サインアウト成功");
      // サインアウト後の処理を追加
    } catch (e) {
      print("サインアウトエラー: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('サインアウト'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // TextField(
            //   controller: _emailController,
            //   decoration: InputDecoration(labelText: 'Email'),
            // ),
            // TextField(
            //   controller: _passwordController,
            //   decoration: InputDecoration(labelText: 'Password'),
            //   obscureText: true,
            // ),
            SizedBox(height: 20),
            //
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _signOut,
              child: Text('サインアウト'),
            ),
          ],
        ),
      ),
    );
  }
}

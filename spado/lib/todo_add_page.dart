import 'package:flutter/material.dart';

class ToDoAddPage extends StatefulWidget {
  @override
  _ToDoAddPageState createState() => _ToDoAddPageState();
}

class _ToDoAddPageState extends State<ToDoAddPage> {
  String _text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('リスト追加'),
      ),
      body: Container(
        padding: EdgeInsets.all(64),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              _text,
              style: TextStyle(color: Colors.black),
            ),
            TextField(
              onChanged: (String value) {
                setState(() {
                  _text = value;
                });
              },
            ),
            const SizedBox(
              height: 8,
            ),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.greenAccent)),
                onPressed: () {
                  Navigator.of(context).pop(_text);
                },
                child: Text(
                  'リスト追加',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              child: TextButton(
                child: Text(
                  'キャンセル',
                  style: TextStyle(color: Colors.black),
                ),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

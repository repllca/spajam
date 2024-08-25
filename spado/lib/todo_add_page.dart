import 'package:flutter/material.dart';

class ToDoAddPage extends StatefulWidget {
  @override
  _ToDoAddPageState createState() => _ToDoAddPageState();
}

class _ToDoAddPageState extends State<ToDoAddPage> {
  String _title = '';
  String _description = '';
  DateTime? _dueDate;
  String _priority = 'Low';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('リスト追加'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              'タイトル',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (String value) {
                setState(() {
                  _title = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'タイトルを入力',
              ),
            ),
            const SizedBox(height: 16),
            Text(
              '説明',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (String value) {
                setState(() {
                  _description = value;
                });
              },
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: '説明を入力',
              ),
              maxLines: 3,
            ),
            const SizedBox(height: 16),
            Text(
              '期限',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            ListTile(
              title: Text(_dueDate == null
                  ? '日付を選択'
                  : '${_dueDate!.toLocal()}'.split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: () async {
                DateTime? selectedDate = await showDatePicker(
                  context: context,
                  initialDate: _dueDate ?? DateTime.now(),
                  firstDate: DateTime(2000),
                  lastDate: DateTime(2101),
                );
                if (selectedDate != null && selectedDate != _dueDate) {
                  setState(() {
                    _dueDate = selectedDate;
                  });
                }
              },
            ),
            const SizedBox(height: 16),
            Text(
              '優先度',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            DropdownButton<String>(
              value: _priority,
              onChanged: (String? newValue) {
                setState(() {
                  _priority = newValue!;
                });
              },
              items: <String>['Low', 'Medium', 'High']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              child: ElevatedButton(
                style: ButtonStyle(
                    backgroundColor:
                        MaterialStatePropertyAll(Colors.greenAccent)),
                onPressed: () {
                  Navigator.of(context).pop({
                    'title': _title,
                    'description': _description,
                    'dueDate': _dueDate?.toIso8601String(),
                    'priority': _priority,
                  });
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

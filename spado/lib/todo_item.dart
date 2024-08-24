import 'package:flutter/material.dart';

class ToDoItem extends StatelessWidget {
  final String item;
  final VoidCallback onDelete;

  ToDoItem({required this.item, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(item),
        trailing: IconButton(
          icon: Icon(Icons.delete),
          onPressed: onDelete,
        ),
      ),
    );
  }
}

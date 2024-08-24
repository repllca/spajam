import 'package:flutter/material.dart';

import 'service.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  final String headerTitle;

  Header({Key? key, required this.headerTitle}) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(headerTitle),
      actions: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: IconButton(
            icon: const Icon(Icons.qr_code),
            onPressed: () {
              // 押したときの処理
              final db = Firestoreservice();
              db.addTaskToUser("a", "a");
              //QR押したときの処理
            },
          ),
        )
      ],
    );
  }
}

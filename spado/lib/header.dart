import 'package:flutter/material.dart';
import 'qrcode.dart';

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
            icon: Icon(Icons.qr_code),
            iconSize: 35,
            onPressed: () {
              // 押したときの処理
              //QR押したときの処理
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const QRCodeScreen()),
              );
            },
          ),
        )
      ],
    );
  }
}

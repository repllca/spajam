import 'package:flutter/material.dart';
import 'qrcode.dart';

class Header extends StatelessWidget implements PreferredSizeWidget {
  const Header({super.key, required this.headerTitle});

  final String headerTitle;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

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

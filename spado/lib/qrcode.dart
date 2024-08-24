import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'routes/profile.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// QRコードの表示
class QRCodeScreen extends StatefulWidget {
  const QRCodeScreen({super.key});

  @override
  _QRCodeScreenState createState() => _QRCodeScreenState();
}

class _QRCodeScreenState extends State<QRCodeScreen> {
  String? _selectedQRCode; // State variable to track selected QR code
  final FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  String? userId; // ユーザーIDを格納する変数

  @override
  void initState() {
    super.initState();
    // 現在ログインしているユーザーを取得
    user = auth.currentUser;
    if (user != null) {
      userId = user!.uid; // UIDを取得して変数に格納
      print('User ID: $userId'); // デバッグ用: ユーザーIDをコンソールに出力
    } else {
      print('No user is currently logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Conditionally display QR code based on selected icon
            if (_selectedQRCode != null)
              QrImageView(
                data: _selectedQRCode!,
                version: QrVersions.auto,
                size: 200.0,
              ),
            // Add spacing between QR code and icons
            const SizedBox(height: 20.0),
            // Row to arrange IconButtons horizontally
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  icon: const Icon(Icons.car_crash),
                  onPressed: () {
                    setState(() {
                      _selectedQRCode = '珈琲,' + (userId ?? ''); // ユーザーIDを結合
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_home),
                  onPressed: () {
                    setState(() {
                      _selectedQRCode = 'チョコレート,' + (userId ?? ''); // ユーザーIDを結合
                    });
                  },
                ),
                IconButton(
                  icon: const Icon(Icons.add_alarm_sharp),
                  onPressed: () {
                    setState(() {
                      _selectedQRCode = 'おにぎり,' + (userId ?? ''); // ユーザーIDを結合
                    });
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.camera_alt),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const CameraScreen()),
          );
        },
      ),
    );
  }
}

// カメラ機能
class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  State<CameraScreen> createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  String readBarcode = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mobile Scanner Demo'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              width: 400,
              height: 700,
              child: MobileScanner(
                onDetect: (capture) {
                  final List<Barcode> barcodes = capture.barcodes;
                  final value = barcodes.first.rawValue;
                  if (value != null) {
                    setState(() {
                      readBarcode = value;
                    });
                  } else {
                    setState(() {
                      readBarcode = 'コードが読み取れません';
                    });
                  }
                },
              ),
            ),
            ElevatedButton(
              onPressed: readBarcode.isNotEmpty
                  ? () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Profile(),
                        ),
                      );
                    }
                  : null, // readBarcodeが空の場合、ボタンは無効になります
              child: Text(
                readBarcode.isNotEmpty
                    ? 'バーコードを確認する'
                    : 'スキャン結果を待っています',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

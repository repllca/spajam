import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'routes/profile.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'service.dart';

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
                  iconSize: 48.0, // アイコンサイズを48ピクセルに設定
                  icon:
                      const Icon(Icons.coffee, color: Colors.brown), // コーヒーアイコン
                  onPressed: () {
                    setState(() {
                      _selectedQRCode = '珈琲,' + (userId ?? ''); // ユーザーIDを結合
                    });
                  },
                ),
                IconButton(
                  iconSize: 48.0, // アイコンサイズを48ピクセルに設定
                  icon: const Icon(Icons.donut_large,
                      color: Colors.pink), // ドーナツアイコン
                  onPressed: () {
                    setState(() {
                      _selectedQRCode = 'ドーナッツ,' + (userId ?? ''); // ユーザーIDを結合
                    });
                  },
                ),
                IconButton(
                  iconSize: 48.0, // アイコンサイズを48ピクセルに設定
                  icon: const Icon(Icons.fastfood,
                      color: Colors.orange), // 食べ物アイコン（例: ハンバーガー）
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
                  ? () async {
                      final db = FirestoreService();
                      List<String> fruits = readBarcode.split(",");

                      // Await the result of the asynchronous call
                      final String? userName =
                          await db.getUsernameFromUserId(fruits[1]);

                      if (userName != null) {
                        // Ensure the userName is not null before using it
                        db.addFriend(userName);

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Profile(),
                          ),
                        );
                      } else {
                        // Handle the case where userName is null
                        print('Username could not be retrieved.');
                      }
                    }
                  : null, // readBarcodeが空の場合、ボタンは無効になります
              child: Text(
                readBarcode.isNotEmpty ? '友達を追加する' : 'スキャン結果を待っています',
              ),
            )
          ],
        ),
      ),
    );
  }
}

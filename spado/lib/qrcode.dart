import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'routes/profile.dart';

// QRコードの表示
class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key});  // keyを追加

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QR Code'),
      ),
      body: Center(
        child: QrImageView(
          data: '1234567890',
          version: QrVersions.auto,
          size: 200.0,
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

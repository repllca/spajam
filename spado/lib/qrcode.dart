import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeScreen extends StatelessWidget {
  const QRCodeScreen({super.key}) ;  // keyを追加
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
            MaterialPageRoute(builder: (context) => const QRViewExample()),
          );
        },
      ),
    );
  }
}

class QRViewExample extends StatefulWidget {
  const QRViewExample({super.key}) ;  // keyを追加
  @override
  State<StatefulWidget> createState() => _QRViewExampleState();
}

class _QRViewExampleState extends State<QRViewExample> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
      ),
      body: QRView(
        key: qrKey,
        onQRViewCreated: _onQRViewCreated,
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      print(scanData.code);
      // QRコードのデータを処理する
    });
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
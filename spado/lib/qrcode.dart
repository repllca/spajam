import 'package:qr_flutter/qr_flutter.dart';

QrImage(
  embeddedImage: const NetworkImage(
    'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
  ),
  data: _textEditingController.text,
  gapless: true,
)
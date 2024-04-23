import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class QRImage extends StatelessWidget {
  const QRImage(this.qrGenerationData, {super.key});

  final String qrGenerationData;

  @override
  Widget build(BuildContext context) {
    return QrImageView(
      data: qrGenerationData,
      size: 280,
      embeddedImageStyle: const QrEmbeddedImageStyle(
        size: Size(
          100,
          100,
        ),
      ),
    );
  }
}

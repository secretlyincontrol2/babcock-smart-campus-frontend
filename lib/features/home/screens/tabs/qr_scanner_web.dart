// Web QR Scanner implementation
import 'package:flutter/material.dart';
import 'dart:async';

// Web-compatible QR scanner classes
class QRViewController {
  StreamController<String>? _scannedDataController;
  
  QRViewController() {
    _scannedDataController = StreamController<String>.broadcast();
  }

  Stream<String> get scannedDataStream => _scannedDataController?.stream ?? Stream.empty();
  
  void dispose() {
    _scannedDataController?.close();
  }
  
  void resumeCamera() {}
  void pauseCamera() {}
  
  // Method to simulate QR scan for demo
  void simulateScan(String data) {
    _scannedDataController?.add(data);
  }
}

class QrScannerOverlayShape extends CustomPainter {
  final Color borderColor;
  final double borderWidth;
  final Color overlayColor;
  final double borderRadius;
  final double borderLength;
  final double cutOutSize;

  QrScannerOverlayShape({
    this.borderColor = Colors.white,
    this.borderWidth = 3.0,
    this.overlayColor = const Color.fromRGBO(0, 0, 0, 80),
    this.borderRadius = 0,
    this.borderLength = 30,
    this.cutOutSize = 300,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    final scanAreaSize = cutOutSize;

    final scanAreaRect = Rect.fromLTWH(
      (width - scanAreaSize) / 2,
      (height - scanAreaSize) / 2,
      scanAreaSize,
      scanAreaSize,
    );

    // Draw overlay
    final overlayPath = Path()
      ..addRect(Rect.fromLTWH(0, 0, width, height))
      ..addRRect(RRect.fromRectAndRadius(scanAreaRect, Radius.circular(borderRadius)))
      ..fillType = PathFillType.evenOdd;

    canvas.drawPath(overlayPath, Paint()..color = overlayColor);

    // Draw border
    canvas.drawRRect(
      RRect.fromRectAndRadius(scanAreaRect, Radius.circular(borderRadius)),
      Paint()
        ..color = borderColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = borderWidth,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class QRView extends StatelessWidget {
  final GlobalKey key;
  final void Function(QRViewController)? onQRViewCreated;
  final OverlayEntry? overlay;

  const QRView({
    required this.key,
    this.onQRViewCreated,
    this.overlay,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: 300,
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.qr_code_scanner,
              size: 64,
              color: Colors.grey[600],
            ),
            const SizedBox(height: 16),
            Text(
              'QR Scanner',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Camera access not available on web',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[500],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Simulate QR scan for demo purposes
                if (onQRViewCreated != null) {
                  // Create a mock QR controller
                  final mockController = QRViewController();
                  onQRViewCreated!(mockController);
                  
                  // Simulate a scan after a short delay
                  Future.delayed(const Duration(seconds: 1), () {
                    mockController.simulateScan('DEMO_QR_CODE_${DateTime.now().millisecondsSinceEpoch}');
                  });
                }
              },
              child: const Text('Demo QR Scan'),
            ),
          ],
        ),
      ),
    );
  }
}

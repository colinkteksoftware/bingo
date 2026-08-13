import 'package:bingo/ui/commons/scanner_overlay_widget.dart';
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class QRScannerScreen extends StatefulWidget {
  const QRScannerScreen({super.key});

  @override
  State<QRScannerScreen> createState() => _QRScannerScreenState();
}

class _QRScannerScreenState extends State<QRScannerScreen> {
  final MobileScannerController controller = MobileScannerController();
  bool _hasScanned = false;

  @override
  void initState() {
    super.initState();
    _requestCameraPermission();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  Future<void> _requestCameraPermission() async {
    final status = await Permission.camera.status;
    if (!status.isGranted) {
      await Permission.camera.request();
    }
  }

  Future<void> _toggleCamera() async {
    await controller.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Escanear QR'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: _toggleCamera,
          ),
        ],
      ),
      body: Stack(
        children: [
          MobileScanner(
            controller: controller,
            fit: BoxFit.cover,
            onDetect: (BarcodeCapture capture) {
              final barcode = capture.barcodes.first;
              final String? code = barcode.rawValue;

              if (!_hasScanned && code != null && code.isNotEmpty) {
                _hasScanned = true;
                Navigator.of(context).pop(code);
              }
            },
          ),
          const ScannerOverlay(),
        ],
      ),
    );
  }
}

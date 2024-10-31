import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:testproject/found_code_screen.dart';

class QrCodeScanner extends StatefulWidget {
  const QrCodeScanner({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<QrCodeScanner> createState() => _QrCodeScannerState();
}

class _QrCodeScannerState extends State<QrCodeScanner> {
  final MobileScannerController controller = MobileScannerController(
    // detectionSpeed: DetectionSpeed.noDuplicates,
    formats: const<BarcodeFormat>[BarcodeFormat.qrCode],
  );
  bool _screenOpened = false;

  @override
  Widget build(BuildContext context) {
    return MobileScanner(
      controller: controller,
      onDetect: _foundBarcode,
    );
  }

  void _foundBarcode(BarcodeCapture capture) {
    if (!_screenOpened) {
      final List<Barcode> barcodes = capture.barcodes;

      for (final barcode in barcodes) {
        print(barcode.rawValue);

        _screenOpened = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FoundCodeScreen(
                screenClosed: _screenWasClosed,
                value: barcode.rawValue.toString()),
          ),
        );
      }
    }
  }

  void _screenWasClosed() {
    _screenOpened = false;
  }
}
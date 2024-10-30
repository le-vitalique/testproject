import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: HomePage(title: 'Стажировка'),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key, required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              child: const Text('Scan QR code'),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) =>
                      const QrCodeScanner(title: 'test title'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
  final MobileScannerController controller = MobileScannerController();
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

// Screen with scanned code value
class FoundCodeScreen extends StatefulWidget {
  final String value;
  final Function() screenClosed;

  const FoundCodeScreen({
    super.key,
    required this.value,
    required this.screenClosed,
  });

  @override
  State<StatefulWidget> createState() => _FoundCodeScreenState();
}

class _FoundCodeScreenState extends State<FoundCodeScreen> {
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (bool didPop, Object? result) {
        if (didPop) {
          print('PopScope called');
          widget.screenClosed();
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Found Code'),
          centerTitle: true,
          leading: IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.arrow_back),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text('Scanned Code:'),
                Text(widget.value),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

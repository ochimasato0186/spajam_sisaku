import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String result = 'まだ読み取っていません';
  String type = '-';

  final MobileScannerController controller = MobileScannerController();

  void _onDetect(BarcodeCapture capture) {
    if (capture.barcodes.isEmpty) return;

    final Barcode barcode = capture.barcodes.first;

    final String? value = barcode.rawValue;

    if (value == null) return;

    setState(() {
      result = value;
      type = barcode.format.name;
    });

    debugPrint('読み取り結果: $value');
    debugPrint('種類: ${barcode.format.name}');
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: AppBar(
        title: const Text('QR / バーコード'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),

      body: Column(
        children: [
          // ==========================
          // カメラ
          // ==========================
          Expanded(
            flex: 3,
            child: MobileScanner(
              controller: controller,
              onDetect: _onDetect,
            ),
          ),

          // ==========================
          // 読み取り結果
          // ==========================
          Expanded(
            flex: 2,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '読み取り結果',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    result,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'コードの種類',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),

                  const SizedBox(height: 8),

                  Text(
                    type,
                    style: const TextStyle(
                      fontSize: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
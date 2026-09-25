import 'dart:convert';

import 'package:barcode_widget/barcode_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qr_flutter/qr_flutter.dart';

class DatePage extends StatefulWidget {
  const DatePage({super.key});

  @override
  State<DatePage> createState() => _DatePageState();
}

class _DatePageState extends State<DatePage> {
  Map<String, dynamic>? data;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // ============================================================
  // JSON読み込み
  // ============================================================

  Future<void> loadData() async {
    final String jsonString =
        await rootBundle.loadString('assets/date/date.json');

    final Map<String, dynamic> jsonData =
        json.decode(jsonString);

    setState(() {
      data = jsonData;
    });
  }

  // ============================================================
  // QRコード画面
  // ============================================================

  void openQrCode() {
    if (data == null) return;

    final String title = data!['qr']['title'];
    final String value = data!['qr']['value'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CodeDisplayPage(
          title: title,
          value: value,
          type: CodeType.qr,
        ),
      ),
    );
  }

  // ============================================================
  // バーコード画面
  // ============================================================

  void openBarcode() {
    if (data == null) return;

    final String title = data!['barcode']['title'];
    final String value = data!['barcode']['value'];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CodeDisplayPage(
          title: title,
          value: value,
          type: CodeType.barcode,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (data == null) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('コード表示'),
      ),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // ==================================================
            // QRコード
            // ==================================================

            SizedBox(
              width: 250,
              height: 70,
              child: ElevatedButton.icon(
                onPressed: openQrCode,
                icon: const Icon(
                  Icons.qr_code,
                  size: 30,
                ),
                label: const Text(
                  'QRコード',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // ==================================================
            // バーコード
            // ==================================================

            SizedBox(
              width: 250,
              height: 70,
              child: ElevatedButton.icon(
                onPressed: openBarcode,
                icon: const Icon(
                  Icons.barcode_reader,
                  size: 30,
                ),
                label: const Text(
                  'バーコード',
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// コード種類
// ============================================================

enum CodeType {
  qr,
  barcode,
}

// ============================================================
// QR / バーコード表示画面
// ============================================================

class CodeDisplayPage extends StatelessWidget {
  final String title;
  final String value;
  final CodeType type;

  const CodeDisplayPage({
    super.key,
    required this.title,
    required this.value,
    required this.type,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.white,
      ),

      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [

              // ==================================================
              // QRコード
              // ==================================================

              if (type == CodeType.qr)
                QrImageView(
                  data: value,
                  version: QrVersions.auto,
                  size: 280,
                ),

              // ==================================================
              // バーコード
              // ==================================================

              if (type == CodeType.barcode)
                BarcodeWidget(
                  barcode: Barcode.code128(),
                  data: value,
                  width: 320,
                  height: 130,
                  drawText: true,
                ),

              const SizedBox(height: 40),

              // ==================================================
              // 中身
              // ==================================================

              const Text(
                'データ',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 8),

              SelectableText(
                value,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
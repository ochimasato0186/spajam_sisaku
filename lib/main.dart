import 'package:flutter/material.dart';
import 'ai_talk/main.dart' as ai_talk;
import 'camera/main.dart' as camera;
import 'camera2/main.dart' as camera2;
import 'map/main.dart' as map;
import 'shake/main.dart' as shake;
import 'scanner/main.dart' as scanner;
import 'date/main.dart' as date;

// アプリを起動する場所
void main() {
  runApp(const MyApp());
}

// アプリ全体の設定
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'わかりやすいFlutterアプリ',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const HomePage(),
    );
  }
}

// 最初に表示する画面
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('ホーム画面')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const ai_talk.AiChatPage(),
                  ),
                );
              },
              child: const Text('AIと会話する'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const camera.CameraPage(),
                  ),
                );
              },
              child: const Text('カメラを使う'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const camera2.Camera2Page(),
                  ),
                );
              },
              child: const Text('カメラ２'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const map.MapPage(),
                  ),
                );
              },
              child: const Text('地図を表示'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const shake.ShakeSensorPage(),
                  ),
                );
              },
              child: const Text('加速度センサーを使う'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const scanner.ScannerPage(),
                  ),
                );
              },
              child: const Text('QR / バーコードを読み取る'),
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const date.DatePage(),
                  ),
                );
              },
              child: const Text('コードを表示する'),
            ),
          ],
        ),
      ),
    );
  }
}

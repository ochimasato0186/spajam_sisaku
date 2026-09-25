import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

class ShakeSensorPage extends StatefulWidget {
  const ShakeSensorPage({super.key});

  @override
  State<ShakeSensorPage> createState() => _ShakeSensorPageState();
}

class _ShakeSensorPageState extends State<ShakeSensorPage> {
  StreamSubscription<AccelerometerEvent>? _subscription;

  // ============================================================
  // 調整する場所
  // ============================================================

  // 小さいほど軽い振りでも反応
  // 大きいほど強く振らないと反応しない
  static const double shakeThreshold = 18.0;

  // 1回振ったあと、次の振りを受け付けるまでの時間
  static const int shakeCooldownMs = 350;

  // ============================================================

  int _shakeCount = 0;

  double _x = 0;
  double _y = 0;
  double _z = 0;

  double _strength = 0;

  DateTime? _lastShakeTime;

  @override
  void initState() {
    super.initState();
    _startSensor();
  }

  void _startSensor() {
    _subscription = accelerometerEventStream().listen(
      (AccelerometerEvent event) {
        final double x = event.x;
        final double y = event.y;
        final double z = event.z;

        // 3軸の加速度から全体の強さを計算
        final double magnitude = sqrt(
          x * x + y * y + z * z,
        );

        // 重力加速度（約9.8）を取り除く
        final double shakeStrength = (magnitude - 9.8).abs();

        if (!mounted) return;

        setState(() {
          _x = x;
          _y = y;
          _z = z;
          _strength = shakeStrength;
        });

        _checkShake(shakeStrength);
      },
    );
  }

  void _checkShake(double strength) {
    if (strength < shakeThreshold) {
      return;
    }

    final now = DateTime.now();

    // 1回の振動を複数回カウントしないようにする
    if (_lastShakeTime != null) {
      final difference =
          now.difference(_lastShakeTime!).inMilliseconds;

      if (difference < shakeCooldownMs) {
        return;
      }
    }

    _lastShakeTime = now;

    setState(() {
      _shakeCount++;
    });

    debugPrint('振った！ $_shakeCount 回');
  }

  void _reset() {
    setState(() {
      _shakeCount = 0;
    });
  }

  @override
  void dispose() {
    _subscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('加速度センサー'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'スマホを振ってください',
              style: TextStyle(
                color: Colors.white,
                fontSize: 22,
              ),
            ),

            const SizedBox(height: 30),

            const Text(
              'SHAKE COUNT',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
              ),
            ),

            Text(
              '$_shakeCount',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 100,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 30),

            Text(
              '強さ：${_strength.toStringAsFixed(1)}',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
              ),
            ),

            const SizedBox(height: 20),

            Text(
              'X : ${_x.toStringAsFixed(2)}\n'
              'Y : ${_y.toStringAsFixed(2)}\n'
              'Z : ${_z.toStringAsFixed(2)}',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 40),

            ElevatedButton(
              onPressed: _reset,
              child: const Text('リセット'),
            ),
          ],
        ),
      ),
    );
  }
}
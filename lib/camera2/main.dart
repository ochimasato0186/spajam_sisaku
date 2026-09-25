import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class Camera2Page extends StatefulWidget {
  const Camera2Page({super.key});

  @override
  State<Camera2Page> createState() => _Camera2PageState();
}

class _Camera2PageState extends State<Camera2Page> {
  CameraController? _controller;

  bool _isCameraReady = false;
  bool _isTakingPicture = false;

  List<CameraDescription> _cameras = [];
  int _selectedCameraIndex = 0;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
  }

  // ============================================================
  // カメラ初期化
  // ============================================================

  Future<void> _initializeCamera() async {
    try {
      _cameras = await availableCameras();

      if (_cameras.isEmpty) {
        debugPrint('利用できるカメラがありません');
        return;
      }

      await _startCamera(_selectedCameraIndex);
    } catch (e) {
      debugPrint('カメラ初期化エラー: $e');
    }
  }

  Future<void> _startCamera(int cameraIndex) async {
    setState(() {
      _isCameraReady = false;
    });

    await _controller?.dispose();

    final controller = CameraController(
      _cameras[cameraIndex],
      ResolutionPreset.high,
      enableAudio: false,
    );

    _controller = controller;

    try {
      await controller.initialize();

      if (!mounted) return;

      setState(() {
        _isCameraReady = true;
      });
    } catch (e) {
      debugPrint('カメラ起動エラー: $e');
    }
  }

  // ============================================================
  // 写真撮影
  // ============================================================

  Future<void> _takePicture() async {
    if (_controller == null ||
        !_controller!.value.isInitialized ||
        _isTakingPicture) {
      return;
    }

    try {
      setState(() {
        _isTakingPicture = true;
      });

      final XFile photo = await _controller!.takePicture();

      debugPrint('撮影成功');
      debugPrint(photo.path);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('撮影しました'),
        ),
      );

      // TODO:
      // photo.path を使って
      // ・画像プレビュー
      // ・AIへ送信
      // ・APIへアップロード
      // などができる

    } catch (e) {
      debugPrint('撮影エラー: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isTakingPicture = false;
        });
      }
    }
  }

  // ============================================================
  // インカメラ / 外カメラ切り替え
  // ============================================================

  Future<void> _switchCamera() async {
    if (_cameras.length < 2) return;

    _selectedCameraIndex =
        (_selectedCameraIndex + 1) % _cameras.length;

    await _startCamera(_selectedCameraIndex);
  }

  // ============================================================
  // 終了処理
  // ============================================================

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  // ============================================================
  // UI
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: !_isCameraReady || _controller == null
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Stack(
                fit: StackFit.expand,
                children: [

                  // ==========================================
                  // カメラ映像
                  // ==========================================

                  CameraPreview(_controller!),

                  // ==========================================
                  // 戻るボタン
                  // ==========================================

                  Positioned(
                    top: 16,
                    left: 16,
                    child: _circleButton(
                      icon: Icons.arrow_back,
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),

                  // ==========================================
                  // 下部操作エリア
                  // ==========================================

                  Positioned(
                    bottom: 30,
                    left: 0,
                    right: 0,
                    child: Row(
                      mainAxisAlignment:
                          MainAxisAlignment.spaceEvenly,
                      children: [

                        // ----------------------------------
                        // 左側ボタン
                        // 好きな機能を追加できる
                        // ----------------------------------

                        _circleButton(
                          icon: Icons.photo_library_outlined,
                          onPressed: () {
                            debugPrint('左ボタン');
                          },
                        ),

                        // ----------------------------------
                        // 撮影ボタン
                        // ----------------------------------

                        GestureDetector(
                          onTap:
                              _isTakingPicture ? null : _takePicture,
                          child: Container(
                            width: 78,
                            height: 78,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Colors.white,
                              border: Border.all(
                                color: Colors.white70,
                                width: 5,
                              ),
                            ),
                            child: Center(
                              child: Container(
                                width: 62,
                                height: 62,
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: _isTakingPicture
                                      ? Colors.grey
                                      : Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),

                        // ----------------------------------
                        // カメラ切り替え
                        // ----------------------------------

                        _circleButton(
                          icon: Icons.cameraswitch,
                          onPressed: _switchCamera,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ============================================================
  // 共通丸ボタン
  // ============================================================

  Widget _circleButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      width: 52,
      height: 52,
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.45),
        shape: BoxShape.circle,
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: Colors.white,
          size: 27,
        ),
      ),
    );
  }
}
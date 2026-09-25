import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  // 初期位置：博多駅
  static const LatLng _initialPosition = LatLng(
    33.5898,
    130.4206,
  );

  GoogleMapController? _mapController;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GoogleMap(
        initialCameraPosition: const CameraPosition(
          target: _initialPosition,
          zoom: 15,
        ),

        // 地図タイプ
        mapType: MapType.normal,

        // 現在地ボタン
        myLocationButtonEnabled: true,

        // ズーム操作
        zoomControlsEnabled: true,

        // 回転
        rotateGesturesEnabled: true,

        // スクロール
        scrollGesturesEnabled: true,

        // ズーム
        zoomGesturesEnabled: true,

        onMapCreated: (GoogleMapController controller) {
          _mapController = controller;
        },

        // 地図をタップ
        onTap: (LatLng position) {
          debugPrint(
            '緯度: ${position.latitude}, '
            '経度: ${position.longitude}',
          );
        },
      ),
    );
  }
}
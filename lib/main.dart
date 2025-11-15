import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:sensors_plus/sensors_plus.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Compass App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const CompassScreen(),
    );
  }
}

class CompassScreen extends StatefulWidget {
  const CompassScreen({super.key});

  @override
  State<CompassScreen> createState() => _CompassScreenState();
}

class _CompassScreenState extends State<CompassScreen> {
  // Lưu trữ góc xoay cho la bàn (tính bằng radian).
  double _rotationAngle = 0.0;

  @override
  void initState() {
    super.initState();
    // Lắng nghe dữ liệu từ cảm biến từ kế.
    magnetometerEventStream().listen((MagnetometerEvent event) {
      setState(() {
        // Tính góc của từ trường so với trục x của thiết bị.
        // Sử dụng atan2(y, x) là chính xác hơn cho việc này.
        double angle = math.atan2(event.y, event.x);

        // Góc xoay của la bàn cần được điều chỉnh.
        // Chúng ta muốn hướng Bắc của la bàn (thường ở trên cùng của ảnh)
        // chỉ về hướng Bắc của Trái Đất.
        // Công thức (pi / 2) - angle thực hiện việc điều chỉnh này.
        _rotationAngle = (math.pi / 2) - angle;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Compass'),
      ),
      body: Center(
        child: Transform.rotate(
          angle: _rotationAngle,
          child: Image.asset('assets/compass.png'),
        ),
      ),
    );
  }
}

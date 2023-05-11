import 'package:flutter/material.dart';

class TrianglePainter extends CustomPainter {
  Color? color;
  final Paint _paint = Paint()
    ..strokeWidth = 5.0
    ..color = Colors.purple
    ..isAntiAlias = true
    ..strokeJoin = StrokeJoin.round;
  final Path _path = Path();
  double left, right, top;

  TrianglePainter({
    required this.left,
    required this.right,
    required this.top,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final width = size.width;
    final height = size.height;
    _path.moveTo(left * width, 0.85 * height);
    _path.lineTo(right * width, 0.85 * height);
    _path.lineTo(0.5 * width, top * height);
    _path.close();
    canvas.drawPath(_path, _paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}

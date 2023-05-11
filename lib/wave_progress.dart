import 'dart:math' as math;
import 'package:flutter/material.dart';

class WaveProgress extends StatefulWidget {
  final double size, progress, offsetY, borderWidth;
  final Color backgroundColor, waveColor, borderColor;

  const WaveProgress({
    super.key,
    this.size = 200.0,
    this.backgroundColor = Colors.blue,
    this.waveColor = Colors.white,
    this.borderColor = Colors.white,
    this.borderWidth = 10.0,
    this.progress = 50.0,
    this.offsetY = 0.0,
  })  : assert(progress >= 0 && progress <= 100,
            'Valid range of progress value is [0.0, 100.0]'),
        assert(offsetY >= -15 && offsetY <= 0,
            'This value offsetY mast [-10.0, 0.0]');

  @override
  State<WaveProgress> createState() => _WaveWidgetState();
}

class _WaveWidgetState extends State<WaveProgress>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(
        seconds: 1,
      ),
    );
    _animationController.repeat();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.size,
      height: widget.size,
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (BuildContext context, Widget? child) {
          return (widget.progress > 0 && widget.progress < 100)
              ? CustomPaint(
                  painter: WaveWidgetPainter(
                      animation: _animationController,
                      backgroundColor: widget.backgroundColor,
                      waveColor: widget.waveColor,
                      borderColor: widget.borderColor,
                      borderWidth: widget.borderWidth,
                      progress: widget.progress),
                )
              : Transform.translate(
                  offset: Offset(0, widget.offsetY),
                  child: Container(
                    color: widget.progress == 100
                        ? widget.waveColor
                        : Colors.transparent,
                    width: widget.progress == 100 ? widget.size : 0,
                    height: widget.progress == 100 ? widget.size : 0,
                  ),
                );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}

class WaveWidgetPainter extends CustomPainter {
  Animation<double> animation;
  Color backgroundColor, waveColor, borderColor;
  double borderWidth, progress;

  WaveWidgetPainter({
    required this.animation,
    required this.backgroundColor,
    required this.waveColor,
    required this.borderColor,
    required this.borderWidth,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    Paint backgroundPaint = Paint()
      ..color = backgroundColor
      ..style = PaintingStyle.fill;

    Offset center = Offset(size.width / 2, size.height / 2 - 15);
    double radius = math.min(size.width / 2 - 5, size.height / 2 - 5);

    canvas.drawRect(
      Rect.fromCircle(center: center, radius: radius),
      backgroundPaint,
    );

    Paint wavePaint = Paint()..color = waveColor;

    double amp = 2.0;
    double p = progress / 100.0;
    double baseHeight = (1 - p) * size.height;

    Path path = Path();
    path.moveTo(0.0, baseHeight);
    for (double i = 0.0; i < size.width; i++) {
      path.lineTo(
          i,
          baseHeight +
              math.sin((i / size.width * 2 * math.pi) +
                      (animation.value * 2 * math.pi)) *
                  amp -
              15);
    }

    path.lineTo(size.width, size.height - 15);
    path.lineTo(0.0, size.height - 15);
    path.close();
    canvas.drawPath(path, wavePaint);

    Paint borderPaint = Paint()
      ..color = Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = borderWidth;

    canvas.drawRect(
        Rect.fromCircle(center: center, radius: radius), borderPaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

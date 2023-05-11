import 'dart:math' as math;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'animation_config.dart';
import 'square_painter.dart';
import 'wave_progress.dart';
import 'triangle_painter.dart';

void main() {
  runApp(
    const AnimatedSplash(),
  );
}

class AnimatedSplash extends StatelessWidget {
  const AnimatedSplash({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(),
      debugShowCheckedModeBanner: false,
      home: const Scaffold(
        body: HomeScreen(),
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation _circleWidthTween;
  late Animation _circleHeightTween;
  late Animation _triangleSizeTween;
  late Animation _triangleLeftTween;
  late Animation _triangleRightTween;
  late Animation _triangleTopTween;
  late Animation _rotationTween;
  late Animation _rect1Tween;
  late Animation _rect2Tween;
  late Animation _waveProgressTween;
  late Animation _waveOffsetYTween;
  late Animation _waveWidthTween;
  late Animation _waveHeightTween;
  late Animation _textSizeTween;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(
        milliseconds: 3000,
      ),
    )..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          if (kDebugMode) {
            print('Animate completed');
          }
        }
      });

    CurvedAnimation curvedAnimation =
        CurvedAnimation(parent: _controller, curve: Curves.linear);

    _circleWidthTween =
        HWAnimationConfig.circleWidthTweenSequence.animate(curvedAnimation);
    _circleHeightTween =
        HWAnimationConfig.circleHeightTweenSequence.animate(curvedAnimation);
    _triangleSizeTween =
        HWAnimationConfig.triangleSizeTweenSequence.animate(curvedAnimation);
    _triangleLeftTween =
        HWAnimationConfig.triangleLeftTweenSequence.animate(curvedAnimation);
    _triangleRightTween =
        HWAnimationConfig.triangleRightTweenSequence.animate(curvedAnimation);
    _triangleTopTween =
        HWAnimationConfig.triangleTopTweenSequence.animate(curvedAnimation);
    _rotationTween =
        HWAnimationConfig.rotationTweenSequence.animate(curvedAnimation);
    _rect1Tween = HWAnimationConfig.rectTweenSequence1.animate(curvedAnimation);
    _rect2Tween = HWAnimationConfig.rectTweenSequence2.animate(curvedAnimation);
    _waveProgressTween =
        HWAnimationConfig.waveTweenSequence.animate(curvedAnimation);
    _waveOffsetYTween =
        HWAnimationConfig.waveOffsetYTweenSequence.animate(curvedAnimation);
    _waveWidthTween = HWAnimationConfig.waveWidthTweenSequence
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _waveHeightTween = HWAnimationConfig.waveHeightTweenSequence
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _textSizeTween = HWAnimationConfig.textSizeTweenSequence
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Center(
          child: Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationZ(math.pi * _rotationTween.value),
            child: Stack(
              alignment: Alignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(60),
                  child: Container(
                    color: Colors.purple,
                    height: _circleHeightTween.value,
                    width: _circleWidthTween.value,
                  ),
                ),
                SizedBox(
                  height: _triangleSizeTween.value,
                  width: _triangleSizeTween.value,
                  child: CustomPaint(
                    painter: TrianglePainter(
                      left: _triangleLeftTween.value,
                      right: _triangleRightTween.value,
                      top: _triangleTopTween.value,
                    ),
                  ),
                ),
                SizedBox(
                  height: _triangleSizeTween.value,
                  width: _triangleSizeTween.value,
                  child: CustomPaint(
                    painter: SquarePainter(progress: _rect1Tween.value),
                  ),
                ),
                SizedBox(
                  height: _triangleSizeTween.value,
                  width: _triangleSizeTween.value,
                  child: CustomPaint(
                    painter: SquarePainter(
                      progress: _rect2Tween.value,
                      color: Colors.purple,
                    ),
                  ),
                ),
                SizedBox(
                  height: _waveHeightTween.value,
                  width: _waveWidthTween.value,
                  child: WaveProgress(
                    size: 120,
                    borderWidth: 0.0,
                    backgroundColor: Colors.transparent,
                    borderColor: Colors.transparent,
                    waveColor: Colors.purple,
                    progress: 100.0 * _waveProgressTween.value,
                    offsetY: _waveOffsetYTween.value,
                  ),
                ),
                Text(
                  'Welcome',
                  style: TextStyle(
                    fontSize: _textSizeTween.value,
                    color: Colors.white,
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    super.dispose();
    _controller.stop();
    _controller.dispose();
  }
}

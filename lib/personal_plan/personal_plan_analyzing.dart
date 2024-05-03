import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';

class FloatingTextData {
  final int initX;
  final int initY;
  final String text;

  FloatingTextData(this.initX, this.initY, this.text);
}

class StudyPlanAnalyzingScreen extends StatefulWidget {
  final Color backgroundColor;
  final Color mainColor;
  final String? loadingImage;
  final String? finishImage;
  final int loadingTime;
  final int floatingTextAnimationTime;
  final void Function() onFinish;

  const StudyPlanAnalyzingScreen({
    super.key,
    this.backgroundColor = const Color(0xFFEEFFFA),
    this.mainColor = const Color(0xFF579E89),
    this.loadingImage,
    this.finishImage,
    this.loadingTime = 2000,
    this.floatingTextAnimationTime = 3000,
    required this.onFinish,
  });

  @override
  State<StudyPlanAnalyzingScreen> createState() =>
      _StudyPlanAnalyzingScreenState();
}

class _StudyPlanAnalyzingScreenState extends State<StudyPlanAnalyzingScreen>
    with TickerProviderStateMixin {
  late ValueNotifier _progressValue;
  late Timer _timer;

  late List<AnimationController> _animControllers;
  final List<Animation<double>> _translateAnimations = [];
  final List<Animation<double>> _fadeAnimations = [];

  final floatingTextList = [
    FloatingTextData(80, -80, 'Diagnostic Test'),
    FloatingTextData(-80, -80, 'Exam Date'),
    FloatingTextData(-80, 80, 'Reminders'),
  ];

  double opacityValue = 0;

  @override
  void initState() {
    _progressValue = ValueNotifier<int>(0);
    _startLoadingTimer();

    _animControllers = List.generate(
        3,
        (index) => AnimationController(
            vsync: this,
            duration:
                Duration(milliseconds: widget.floatingTextAnimationTime)));

    int startTime = 0;
    for (AnimationController animController in _animControllers) {
      // Add animations
      _translateAnimations.add(Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeInOut)));
      _fadeAnimations.add(Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(parent: animController, curve: Curves.easeInOut)));

      animController.addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          Future.delayed(const Duration(seconds: 1),
              () => animController.forward(from: 0));
        }
      });

      Future.delayed(
          Duration(milliseconds: startTime), () => animController.forward());

      startTime += 500;
    }

    super.initState();
  }

  void _startLoadingTimer() {
    _timer = Timer.periodic(
        Duration(milliseconds: (widget.loadingTime / 100).round()),
        (Timer timer) {
      if (_progressValue.value < 100) {
        _progressValue.value = _progressValue.value + 1;
      } else {
        _timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    _progressValue.dispose();
    _timer.cancel();

    for (AnimationController animController in _animControllers) {
      animController.dispose();
    }

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Scaffold(
        backgroundColor: widget.backgroundColor,
        body: SafeArea(
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Title
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20),
                  child: Text(
                    'Generating Your Personalized Study Plan...',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 28),
                  ),
                ),

                _buildCircularLoadingProgress(),

                // Progress number
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: ValueListenableBuilder(
                    valueListenable: _progressValue,
                    builder: (_, value, __) => Text('$value%',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: widget.mainColor,
                            fontSize: 40)),
                  ),
                ),

                const Text(
                  'Analyzing Your Data ...',
                  style: TextStyle(fontSize: 18),
                )
              ],
            ),
          ),
        ),
      ),

      // Debug
      if (kDebugMode)
        SafeArea(
            child: IconButton(
                onPressed: () => Navigator.of(context).pop(context),
                icon: const Icon(
                  Icons.chevron_left,
                  color: Colors.red,
                )))
    ]);
  }

  Widget _buildCircularLoadingProgress() {
    const outerRadius = 140.0;
    const lineWidth = 20.0;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: CircleAvatar(
        backgroundColor: widget.mainColor.withOpacity(0.3),
        radius: outerRadius,
        child: CircularPercentIndicator(
            radius: outerRadius - lineWidth,
            circularStrokeCap: CircularStrokeCap.round,
            lineWidth: lineWidth,
            backgroundColor: widget.mainColor.withOpacity(0.4),
            progressColor: widget.mainColor,
            percent: 1,
            animation: true,
            animationDuration: widget.loadingTime,
            onAnimationEnd: () => Future.delayed(
                const Duration(milliseconds: 200), () => widget.onFinish()),
            center: CircleAvatar(
                radius: outerRadius - 2 * lineWidth,
                backgroundColor: Colors.white.withOpacity(0.4),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    ValueListenableBuilder(
                        valueListenable: _progressValue,
                        builder: (_, value, __) => Transform.scale(
                            scale: 1.2,
                            child: Image.asset(_getImagePath(value)))),
                    Stack(
                        children: List.generate(
                            3,
                            (index) => AnimatedBuilder(
                                animation: _animControllers[index],
                                builder: (_, __) => Transform.translate(
                                    offset: Offset(
                                      _calculateOffsetX(index),
                                      _calculateOffsetY(index),
                                    ),
                                    child: Opacity(
                                      opacity: _calculateFadeOpacity(index),
                                      child: Text(floatingTextList[index].text,
                                          style: const TextStyle(
                                              color: Colors.black)),
                                    )))))
                  ],
                ))),
      ),
    );
  }

  String _getImagePath(int value) {
    if (value < 100) {
      return widget.loadingImage ?? 'assets/images/analyzing.png';
    }
    return widget.finishImage ?? 'assets/images/analyzing_done.png';
  }

  double _calculateOffsetX(int index) =>
      floatingTextList[index].initX * (1 - _translateAnimations[index].value);

  double _calculateOffsetY(int index) =>
      floatingTextList[index].initY * (1 - _translateAnimations[index].value) -
      50; // Move up to match the figure's head

  double _calculateFadeOpacity(int index) => _fadeAnimations[index].value <= 0.5
      ? (_fadeAnimations[index].value * 20).clamp(0, 1)
      : 2 - _fadeAnimations[index].value * 2;
}

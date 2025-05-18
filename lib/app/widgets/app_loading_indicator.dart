import 'package:bouldee/app/constants/app_media_resources.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class AppLoadingIndicator extends StatefulWidget {
  const AppLoadingIndicator({super.key});

  @override
  State<AppLoadingIndicator> createState() => AppLoadingIndicatorState();
}

class AppLoadingIndicatorState extends State<AppLoadingIndicator>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return RotatingLogo(animation: _controller);
  }
}

class RotatingLogo extends AnimatedWidget {
  const RotatingLogo({
    required Animation<double> animation,
    super.key,
  }) : super(listenable: animation);

  @override
  Widget build(BuildContext context) {
    final animation = listenable as Animation<double>;
    return Transform.rotate(
      angle: animation.value * 3 * 3.14,
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        child: SvgPicture.asset(
          AppMediaRes.appLogo,
          width: 48,
          height: 48,
          fit: BoxFit.scaleDown,
        ),
      ),
    );
  }
}

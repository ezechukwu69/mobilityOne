import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mobility_one/util/my_images.dart';

class MyCircularProgressIndicator extends StatefulWidget {
  MyCircularProgressIndicator({Key? key}) : super(key: key);

  @override
  _MyCircularProgressIndicatorState createState() => _MyCircularProgressIndicatorState();
}

class _MyCircularProgressIndicatorState extends State<MyCircularProgressIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> sizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(vsync: this, duration: Duration(milliseconds: 700));
    sizeAnimation = Tween<double>(begin: 200, end: 250).animate(_animationController);
    _animationController.forward();
    sizeAnimation.addStatusListener(_controlAnimationDirection);
  }

  void _controlAnimationDirection(AnimationStatus status) {
    if (status == AnimationStatus.completed) {
      _animationController.reverse();
    };
    if (status == AnimationStatus.dismissed) {
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.removeListener(() {});
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      builder: (_, __) {
        return Center(
          child: SvgPicture.asset(
            MyImages.mobilityOneLogo,
            width: sizeAnimation.value,
          ),
        );
      },
      animation: sizeAnimation,
    );
  }
}

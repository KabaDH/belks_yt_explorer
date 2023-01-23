import 'package:flutter/material.dart';

class ShowBelksProgressIndicator extends AnimatedWidget {
  const ShowBelksProgressIndicator(
      {Key? key, required AnimationController animationController})
      : super(
            key: key,
            listenable:
                animationController); //тут можно прописать Tween и далее импортировать анимацию

  @override
  Widget build(BuildContext context) {
    AnimationController animation = listenable as AnimationController;

    return Stack(
      children: [
        Image.asset(
          'assets/nut-256.png',
          height: 48,
          width: 48,
        ),
        Image.asset(
          'assets/nut-256green.png',
          height: 48 - 48 * animation.value,
          width: 48,
          fit: BoxFit.fitWidth,
          alignment: Alignment.topCenter,
        ),
      ],
    );
  }
}

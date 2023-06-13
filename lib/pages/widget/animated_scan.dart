import 'package:flutter/material.dart';

class ScannerAnimation extends StatefulWidget {
  final Function()? callback;

  const ScannerAnimation({
    Key? key,
    required this.callback,
  }) : super(key: key);

  @override
  ScannerAnimationState createState() => ScannerAnimationState();
}

class ScannerAnimationState extends State<ScannerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> opacity;
  late Animation<double> moveDown;
  late Animation<double> moveUp;
  late Animation<double> staticAnimation;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    opacity = Tween(begin: 0.6, end: 0.1).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInExpo)));

    moveDown = Tween(begin: -8.0, end: 52.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInSine));

    moveUp = Tween(begin: -12.0, end: -72.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInSine));
    staticAnimation = Tween(begin: -4.0, end: -4.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInSine));

    controller.addListener(() {
      if (controller.status == AnimationStatus.completed) {
        controller.reverse();
      } else if (controller.status == AnimationStatus.dismissed) {
        controller.forward();
      }
    });

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    controller.forward();

    return AnimatedBuilder(
      animation: controller,
      child: _Rectangle(),
      builder: (BuildContext context, Widget? childRectangulo) {
        return Stack(
          children: [
            SizedBox(
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Line(),
                  Transform.translate(
                    offset: Offset(0, 0 + staticAnimation.value),
                    child: Opacity(
                      opacity: 1.0,
                      child: Transform.scale(
                        scale: 1.0,
                        child: _Rectangle(),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 0 + moveDown.value),
                    child: Opacity(
                      opacity: opacity.value,
                      child: Transform.scale(
                        scale: 1.0,
                        child: _Rectangle(),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 0 + moveUp.value),
                    child: Opacity(
                      opacity: opacity.value,
                      child: Transform.scale(
                        scale: 1.0,
                        child: _Rectangle(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              alignment: const Alignment(1.0, 0.5),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  const SizedBox.shrink(),
                  const SizedBox.shrink(),
                  MaterialButton(
                      onPressed: () => widget.callback!(),
                      child: const Text(
                        'SCANNER',
                        style: TextStyle(color: Colors.white, fontSize: 12),
                      ))
                ],
              ),
            )
          ],
        );
      },
    );
  }
}

class _Rectangle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 4,
      color: Colors.white,
    );
  }
}

class _Line extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      height: 4,
      width: size.width * 0.80,
      color: Colors.grey.shade400,
    );
  }
}

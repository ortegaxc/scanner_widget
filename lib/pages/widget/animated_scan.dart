import 'package:flutter/material.dart';

class ScannerAnimation extends StatefulWidget {
  void Function()? callback;

  ScannerAnimation({Key? key, required this.callback}) : super(key: key);

  @override
  _CuadradoAnimadoState createState() => _CuadradoAnimadoState();
}

class _CuadradoAnimadoState extends State<ScannerAnimation>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late Animation<double> opacidad;

  late Animation<double> moverAbajo;
  late Animation<double> moverArriba;
  late Animation<double> estatico;

  @override
  void initState() {
    controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));

    opacidad = Tween(begin: 0.6, end: 0.1).animate(CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 1.0, curve: Curves.easeInExpo)));

    moverAbajo = Tween(begin: -8.0, end: 52.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInSine));

    moverArriba = Tween(begin: -12.0, end: -72.0)
        .animate(CurvedAnimation(parent: controller, curve: Curves.easeInSine));
    estatico = Tween(begin: -4.0, end: -4.0)
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
      child: _Rectangulo(),
      builder: (BuildContext context, Widget? childRectangulo) {
        return Stack(
          children: [
            SizedBox(
              width: 500,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Linea(),
                  Transform.translate(
                    offset: Offset(0, 0 + estatico.value),
                    child: Opacity(
                      opacity: 1.0,
                      child: Transform.scale(
                        scale: 1.0,
                        child: _Rectangulo(),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 0 + moverAbajo.value),
                    child: Opacity(
                      opacity: opacidad.value,
                      child: Transform.scale(
                        scale: 1.0,
                        child: _Rectangulo(),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, 0 + moverArriba.value),
                    child: Opacity(
                      opacity: opacidad.value,
                      child: Transform.scale(
                        scale: 1.0,
                        child: _Rectangulo(),
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
                        'INACAP',
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

class _Rectangulo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 70,
      height: 4,
      color: Colors.white,
    );
  }
}

class _Linea extends StatelessWidget {
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

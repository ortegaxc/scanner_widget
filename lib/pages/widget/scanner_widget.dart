import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner_widget/pages/widget/animated_scan.dart';

class ScannerWidget extends StatefulWidget {
  final Function(Barcode, MobileScannerArguments?) onScanner;

  bool? isOpenScanner;
  bool? onDoubleTapClose;
  bool? torchEnabled;
  bool? timerEnabled;

  ScannerWidget({
    Key? key,
    this.isOpenScanner = true,
    this.onDoubleTapClose = false,
    this.torchEnabled = true,
    this.timerEnabled = true,
    required this.onScanner,
  }) : super(key: key);
  @override
  _ScanditWidgetState createState() => _ScanditWidgetState();
}

class _ScanditWidgetState extends State<ScannerWidget> {
  MobileScannerController? scannerController;

  late Timer _timer = Timer(const Duration(seconds: 20), () {});

  // TODO: MODIFICAR LIBRERIA SCANNER
  final Barcode barcodeR = Barcode(rawValue: '');
  final MobileScannerArguments argumentR =
      MobileScannerArguments(size: const Size(0, 0), hasTorch: false);

  @override
  void initState() {
    super.initState();
    activateScanner();
  }

  void activateScanner() {
    if (widget.isOpenScanner!) {
      scannerController =
          MobileScannerController(torchEnabled: widget.torchEnabled);
      if (widget.timerEnabled!) {
        resetPauseCameraTimer();
      }
    } else {
      deactivate();
    }
  }

  @override
  void deactivate() {
    widget.isOpenScanner = false;
    _timer.cancel();
    scannerController?.dispose();
    super.deactivate();
  }

  @override
  void dispose() {
    deactivate();
    super.dispose();
  }

  void callBackScanner() {
    widget.onScanner(barcodeR, argumentR);
  }

  void resetPauseCameraTimer() {
    _timer.cancel();
    _timer = Timer(const Duration(seconds: 20), () {
      deactivate();
      callBackScanner();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedSize(
      duration: const Duration(milliseconds: 1500),
      curve: Curves.decelerate,
      child: GestureDetector(
        onDoubleTap: () async {
          if (widget.onDoubleTapClose!) {
            deactivate();
            callBackScanner();
            setState(() {});
          }
        },
        child: SizedBox(
          height: widget.isOpenScanner! ? 200 : 0,
          child: _scannerRCollect(),
        ),
      ),
    );
  }

  Widget _scannerRCollect() {
    if (widget.isOpenScanner!) {
      activateScanner();

      return Stack(
        children: [
          MobileScanner(
              allowDuplicates: false,
              controller: scannerController,
              onDetect: widget.onScanner),
          Container(
              alignment: Alignment.topRight,
              child:
                  ScannerAnimation(callback: scannerController?.toggleTorch)),
        ],
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}

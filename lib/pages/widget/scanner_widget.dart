import 'dart:async';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:scanner_widget/pages/widget/animated_scan.dart';

class ScannerWidget extends StatefulWidget {
  final Function(Barcode, MobileScannerArguments?) onScannerRcollect;

  bool? isScandit;
  bool? isOpenScanner;
  bool? onDoubleTapClose;
  bool? torchEnabled;
  bool? timerEnabled;

  ScannerWidget({
    Key? key,
    this.isScandit = false,
    this.isOpenScanner = true,
    this.onDoubleTapClose = false,
    this.torchEnabled = true,
    this.timerEnabled = true,
    required this.onScannerRcollect,
  }) : super(key: key);
  @override
  _ScanditWidgetState createState() => _ScanditWidgetState();
}

class _ScanditWidgetState extends State<ScannerWidget> {
  MobileScannerController? scannerController;

  late Timer _timer = Timer(const Duration(seconds: 20), () {});

  @override
  void initState() {
    super.initState();
    activateScanner();
  }

  void activateScanner() {
    if (widget.isOpenScanner!) {
      if (widget.isOpenScanner! && !widget.isScandit!) {
        scannerController =
            MobileScannerController(torchEnabled: widget.torchEnabled);
      }
      if (widget.timerEnabled!) {
        resetPauseCameraTimer();
      }
    }
  }

  @override
  void deactivate() {
    widget.isOpenScanner = false;
    _timer.cancel();
    scannerController?.dispose();
    super.deactivate();
  }

  void resetPauseCameraTimer() {
    _timer.cancel();
    _timer = Timer(const Duration(seconds: 20), () {
      deactivate();
      widget.isOpenScanner = false;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    activateScanner();
    return AnimatedSize(
      duration: const Duration(milliseconds: 1500),
      curve: Curves.decelerate,
      child: GestureDetector(
        onDoubleTap: () async {
          if (widget.onDoubleTapClose!) {
            _timer.cancel();
            widget.isOpenScanner = false;
            setState(() {});
          }
        },
        child: SizedBox(
            height: widget.isOpenScanner! ? 200 : 0,
            child: Stack(
              children: [
                widget.isOpenScanner!
                    ? MobileScanner(
                        allowDuplicates: false,
                        controller: scannerController,
                        onDetect: widget.onScannerRcollect)
                    : const SizedBox.shrink(),
                ScannerAnimation(callback: scannerController?.toggleTorch),
              ],
            )),
      ),
    );
  }
}

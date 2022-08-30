import 'package:flutter/material.dart';

class ScannerProvider extends ChangeNotifier {
  bool _isOpenScanner = false;

  bool get isOpenScanner => _isOpenScanner;

  set isOpenScanner(bool value) {
    _isOpenScanner = value;
    notifyListeners();
  }
}

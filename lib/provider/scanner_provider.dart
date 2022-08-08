import 'package:flutter/material.dart';

class ScannerProvider extends ChangeNotifier {
  bool _isOpenScanner = false;

  bool get isOpenScanner => _isOpenScanner;

  set isOpenScanner(bool value) {
    _isOpenScanner = value;
    notifyListeners();
  }

  getProduct() async {
    // isLoading = true;
    await Future.delayed(const Duration(milliseconds: 3000));
    // isLoading = false;
    await Future.delayed(const Duration(milliseconds: 4000));
  }
}

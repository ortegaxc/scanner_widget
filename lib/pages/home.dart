import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_widget/pages/widget/scanner_widget.dart';
import 'package:scanner_widget/provider/scanner_provider.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  TextEditingController codeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final scannerProvider = Provider.of<ScannerProvider>(context);
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 30),
                    child: Image.asset('assets/logo.png')),
                ScannerWidget(
                    onDoubleTapClose: true,
                    isOpenScanner: scannerProvider.isOpenScanner,
                    onScannerRcollect: (barcode, _) {
                      scannerProvider.isOpenScanner = false;
                      codeController.text = barcode.rawValue!;
                    }),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Resultado scanner',
                    ),
                    controller: codeController,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 30),
            child: SizedBox(
              width: double.infinity,
              child: MaterialButton(
                color: Colors.grey.shade800,
                onPressed: () {
                  codeController.clear();
                  scannerProvider.isOpenScanner = true;
                },
                child: const Text('ESCANEAR'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

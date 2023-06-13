import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scanner_widget/pages/widget/scanner_widget.dart';
import 'package:scanner_widget/provider/scanner_provider.dart';

class HomeView extends StatelessWidget {
  HomeView({Key? key}) : super(key: key);

  final TextEditingController codeController = TextEditingController();

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
                const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
                    child: FlutterLogo(size: 120)),
                if (scannerProvider.isOpenScanner)
                  ScannerWidget(
                      onDoubleTapClose: true,
                      isOpenScanner: scannerProvider.isOpenScanner,
                      onScanner: (barcode, _) {
                        scannerProvider.isOpenScanner = false;
                        codeController.text = barcode.rawValue!;
                      }),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
                  child: TextField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      hintText: 'Scan result',
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
                  scannerProvider.isOpenScanner =
                      !scannerProvider.isOpenScanner;
                },
                child: const Text('SCAN'),
              ),
            ),
          )
        ],
      ),
    );
  }
}

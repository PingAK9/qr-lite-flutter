import 'package:flutter/material.dart';
import 'package:qr_app/core.dart';
import 'package:qr_app/focus_scan.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanView extends StatefulWidget {
  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onScan('');
        return false;
      },
      child: Scaffold(
        body: Stack(children: [
          QRView(
            key: qrKey,
            onQRViewCreated: _onQRViewCreated,
          ),
          Container(
            margin: EdgeInsets.only(top: kToolbarHeight),
            alignment: Alignment.center,
            child: ScanFocus(),
          ),
          AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: const CloseButton(),
            centerTitle: true,
            title: const Text('SCAN LITE'),
            actions: <Widget>[
              IconButton(
                icon: Icon(isFlash ? Icons.flash_off : Icons.flash_on),
                onPressed: () {
                  controller.toggleFlash();
                  setState(() {
                    isFlash = !isFlash;
                  });
                },
              )
            ],
          ),
        ]),
      ),
    );
  }

  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController controller;
  bool isFlash = false;

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen(onScan);
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void onScan(String data) {
    if (data != null && data.isNotEmpty) {
      Core.instance.currentCode = HistoryUnit.createNew(data);
      Core.instance.addNewHistoryUnit(data);
    } else {
      Core.instance.currentCode = null;
    }
    if (Navigator.canPop(context)) {
      Navigator.pop(context, data);
    } else {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }
}

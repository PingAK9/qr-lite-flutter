import 'package:flutter/material.dart';
import 'package:qr_app/core.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class ScanView extends StatefulWidget {
  @override
  _ScanViewState createState() => _ScanViewState();
}

class _ScanViewState extends State<ScanView> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery
        .of(context)
        .size
        .width;
    double size = width < 300 ? (width - 50) : 250;
    return WillPopScope(
      onWillPop: () async {
        onScan('');
        return false;
      },
      child: new Scaffold(
        body: Container(
          child: Stack(children: [
            QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
            ),
            SafeArea(
              child: Container(
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    CloseButton(),
                    Text('SCAN LITE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18),),
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
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Container(
                width: size,
                height: size,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    border: Border.all(
                      color: Colors.white,
                      width: 1,
                      style: BorderStyle.solid,
                    )),
              ),
            )
          ]),
        ),
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

  onScan(String data) {
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

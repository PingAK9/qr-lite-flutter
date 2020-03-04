/**
import 'package:firebase_ml_vision/firebase_ml_vision.dart';
import 'package:flutter/material.dart';
import 'package:flutter_camera_ml_vision/flutter_camera_ml_vision.dart';
import 'package:qr_app/core.dart';
import 'package:qr_app/focus_scan.dart';

class ScanMLView extends StatefulWidget {
  @override
  _ScanMLViewState createState() => _ScanMLViewState();
}

class _ScanMLViewState extends State<ScanMLView> {
  bool resultSent = false;
  bool isFlash = false;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        _onClose(null);
        return false;
      },
      child: Scaffold(
        body: Stack(children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: CameraMlVision<List<Barcode>>(
              detector: FirebaseVision.instance.barcodeDetector().detectInImage,
              onResult: _onResult,
              resolution: ResolutionPreset.max,
            ),
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

  void _onResult(List<Barcode> codes) {
    if (codes != null && codes.isNotEmpty) {
      if (!mounted || resultSent) {
        return;
      }
      resultSent = true;
      _onClose(codes.first);
    }
  }

  void _onClose(Barcode barcode) {
    final String data = barcode?.displayValue;
    if (barcode != null) {
      final String data = barcode.displayValue;
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
*/
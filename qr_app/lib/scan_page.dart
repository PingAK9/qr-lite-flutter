import 'dart:async';

import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:qr_app/history_data.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class ScanPage extends StatefulWidget {
  @override
  _ScanPageState createState() => new _ScanPageState();
}

class _ScanPageState extends State<ScanPage> {
  String barcode;
  bool isScan;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    barcode = '';
    scan();
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new WillPopScope(
          onWillPop: _onBack,
          child: new Scaffold(
            appBar: new AppBar(
              elevation: 0,
              backgroundColor: Colors.white10,
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black,),
                onPressed: () {
                  scan();
                },
              ),
              actions: <Widget>[
                FlatButton(
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.history),
                        const Text('History')
                      ],
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, '/history').then((Object result) {
                        print(result);
                        if (result == null) return;
                        setState(() {
                          barcode = result.toString();
                        });
                      });
                    }
                ),
              ],
            ),
            body: _buildBody(),
            bottomNavigationBar: BottomAppBar(
              child: new Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: _buildChildrenBottom(),
              ),
            ),
          ),
        )
    );
  }

  Widget _buildBody() {
    if (barcode?.isEmpty) {
      return new Center(
        child: Text('Empty'),
      );
    }
    else {
      return new Container(
        child: new Column(
          children: <Widget>[
            new Text(barcode),
          ],
        ),
        padding: const EdgeInsets.all(20.0),
      );
    }
  }

  List<Widget> _buildChildrenBottom() {
    List<Widget> _list = new List();
    if (barcode?.isEmpty) {
      _list.addAll(<Widget>[
        Text(''),
        FlatButton(
            child: Row(
              children: <Widget>[
                const Icon(Icons.crop_free),
                const Text('Scan new')
              ],
            ),
            onPressed: () {
              scan();
            }
        ),
        Text(''),
      ]);
    } else {
      if (barcode?.contains('http')) {
        _list.add(FlatButton(
            child: Row(
              children: <Widget>[
                const Icon(Icons.insert_link),
                const Text('Open')
              ],
            ),
            onPressed: _launchURL
        ));
      }

      _list.addAll(<Widget>[
        FlatButton(
            child: Row(
              children: <Widget>[
                const Icon(Icons.content_copy),
                const Text('Copy')
              ],
            ),
            onPressed: () {
              Clipboard.setData(new ClipboardData(text: barcode));
            }
        ),
        FlatButton(
            child: Row(
              children: <Widget>[
                const Icon(Icons.share),
                const Text('Share')
              ],
            ),
            onPressed: () {
              Share.share(barcode);
            }
        ),
        FlatButton(
            child: Row(
              children: <Widget>[
                const Icon(Icons.crop_free),
                const Text('Scan')
              ],
            ),
            onPressed: () {
              scan();
            }
        ),
      ]);
    }
    return _list;
  }

  Future<bool> _onBack() {
    return new Future.value(false);
  }
  _launchURL() async {
    print('launch $barcode');
    if (await canLaunch(barcode)) {
      await launch(barcode);
    }else {
      throw 'Could not launch $barcode';
    }
  }
  Future scan() async {
    String _code = "";
    isScan = true;
    try {
      _code = await BarcodeScanner.scan();
      addNewHistoryUnit(_code);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        _code = 'The user did not grant the camera permission!';
      } else {
        _code = 'Unknown error: $e';
      }
    } on FormatException {
      _code = '';
    } catch (e) {
      _code = 'Unknown error: $e';
    }
    isScan = false;
    setState(() {
      barcode = _code;
    });
  }
}
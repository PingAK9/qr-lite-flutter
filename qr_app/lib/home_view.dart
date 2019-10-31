import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:majascan/majascan.dart';
import 'package:qr_app/app_styles.dart';
import 'package:qr_app/core.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => new _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    onScan();
  }

  bool _canLaunch = false;

  checkCanLaunch() async {
    if (Core.instance.currentCode != null) {
      _canLaunch = await canLaunch(Core.instance.currentCode.barcode);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    checkCanLaunch();

    return new MaterialApp(
      home: new WillPopScope(
        onWillPop: ()async{

          return false;
        },
        child: new Scaffold(
          backgroundColor: AppStyles.colorBackground,
          appBar: new AppBar(
            elevation: 0,
            backgroundColor: AppStyles.colorSurface,
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                onScan();
              },
            ),
            actions: <Widget>[
              FlatButton(
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.history,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text('History', style: AppStyles.h3())
                    ],
                  ),
                  onPressed: () {
                    Navigator.pushNamed(context, '/history').then((value) {
                      setState(() {});
                    });
                  }),
            ],
          ),
          body: _buildBody(),
          bottomNavigationBar: Core.instance.currentCode == null
              ? null
              : BottomAppBar(
                  color: AppStyles.colorSurface,
                  child: Container(
                    child: new Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: _buildChildrenBottom(),
                    ),
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              onScan();
            },
            child: Icon(
              Icons.crop_free,
              color: Colors.white,
            ),
            backgroundColor: AppStyles.colorPrimary,
          ),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (Core.instance.currentCode == null) {
      return new Center(
        child: RaisedButton(
          padding: EdgeInsets.fromLTRB(30, 15, 30, 15),
          child: Text(
            'SCAN NOW',
            style: AppStyles.h3(color: Colors.white),
          ),
          color: Colors.white12,
          onPressed: () {
            onScan();
          },
        ),
      );
    } else {
      return new Container(
        child: Center(
          child: Text(
            Core.instance.currentCode.barcode,
            style: AppStyles.h3(),
          ),
        ),
        padding: const EdgeInsets.all(20.0),
      );
    }
  }

  List<Widget> _buildChildrenBottom() {
    List<Widget> _list = new List();

    if (_canLaunch) {
      _list.add(
        buildBottomButton(
          'Open',
          icon: Icons.insert_link,
          onPressed: () {
            launch(Core.instance.currentCode.barcode);
          },
        ),
      );
    }

    _list.addAll(
      <Widget>[
        buildBottomButton('Copy', icon: Icons.content_copy, onPressed: () {
          Clipboard.setData(
              new ClipboardData(text: Core.instance.currentCode.barcode));
        }),
        buildBottomButton('Share', icon: Icons.share, onPressed: () {
          Share.share(Core.instance.currentCode.barcode);
        }),
      ],
    );
    return _list;
  }

  Widget buildBottomButton(title, {icon, onPressed}) {
    return FlatButton(
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              color: Colors.white,
            ),
            Text(title, style: AppStyles.body2())
          ],
        ),
        onPressed: onPressed);
  }

  Future onScan() async {
    Future<String> futureString = MajaScan.startScan(
        title: "Scan Lite",
        barColor: Colors.transparent,
        titleColor: Colors.white,
        qRCornerColor: AppStyles.colorSurface,
        qRScannerColor: AppStyles.colorPrimary,
        flashlightEnable: true);
    futureString.then((value) {
      setState(() {
        Core.instance.currentCode = HistoryUnit.createNew(value);
        Core.instance.addNewHistoryUnit(value);
      });
    });
  }
}

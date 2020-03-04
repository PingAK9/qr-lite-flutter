import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:qr_app/core.dart';
import 'package:qr_app/focus_scan.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share/share.dart';

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  bool _canLaunch = false;

  Future checkCanLaunch() async {
    if (Core.instance.currentCode != null) {
      _canLaunch = await canLaunch(Core.instance.currentCode.barcode);
      setState(() {});
    }
  }

  final Color mainColor = const Color(0xFF07C5CE);

  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    checkCanLaunch();
    return WillPopScope(
      onWillPop: () async {
        onScan();
        return false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: mainColor,
          title: const Text('SCAN LITE'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: onScan,
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(
                  Icons.history,
                  color: Colors.white,
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/history').then((value) {
                    setState(() {});
                  });
                }),
          ],
        ),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0, 1],
                colors: [
                  mainColor,
                  const Color(0xFFF0F5FC).withAlpha(50),
                ],
              ),
            ),
            child: _buildBody()),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: Container(
          margin: const EdgeInsets.only(bottom: 45),
          child: _scanNowButton(),
        ),
      ),
    );
  }

  Widget _scanNowButton() {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        color: mainColor,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10),
          topRight: Radius.circular(10),
          bottomLeft: Radius.circular(10),
        ),
      ),
      child: FlatButton(
        onPressed: onScan,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.crop_free,
              color: Colors.white,
            ),
            const SizedBox(width: 5),
            Text(
              'Scan now',
              style: TextStyle(color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (Core.instance.currentCode == null) {
      return Container(
        alignment: Alignment.center,
        child: ScanFocus(),
      );
    } else {
      return Container(
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: kToolbarHeight),
        child: Container(
          padding: const EdgeInsets.only(left: 5),
          margin: const EdgeInsets.symmetric(horizontal: 20),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.orange,
              boxShadow: [
                BoxShadow(
                  color: Colors.orange.withAlpha(50),
                  offset: const Offset(1, 4),
                  blurRadius: 5,
                ),
              ]),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Icon(
                      Icons.date_range,
                      size: 15,
                      color: Colors.blue,
                    ),
                    const SizedBox(width: 5),
                    Text(
                      Core.instance.currentCode.date,
                      textAlign: TextAlign.left,
                      style: TextStyle(color: Colors.blue),
                    )
                  ],
                ),
                const SizedBox(height: 5),
                SizedBox(
                  width: double.infinity,
                  child: Text(
                    Core.instance.currentCode.barcode,
                    textAlign: TextAlign.left,
                  ),
                ),
                const Divider(
                  height: 30,
                  thickness: 1,
                ),
                Container(
                  height: 40,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      buildBottomButton('Share',
                          icon: Icons.share,
                          color: Colors.purple, onPressed: () {
                        Share.share(Core.instance.currentCode.barcode);
                      }),
                      buildBottomButton('Copy',
                          icon: Icons.content_copy,
                          color: Colors.green, onPressed: () {
                        Clipboard.setData(ClipboardData(
                            text: Core.instance.currentCode.barcode));
                        _scaffoldKey.currentState.showSnackBar(const SnackBar(
                          content: Text('Copied'),
                          duration: Duration(seconds: 1),
                        ));
                      }),
                      if (_canLaunch)
                        buildBottomButton(
                          'Open',
                          icon: Icons.insert_link,
                          color: Colors.blue,
                          onPressed: () {
                            launch(Core.instance.currentCode.barcode);
                          },
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }
  }

  Widget buildBottomButton(String title,
      {IconData icon, VoidCallback onPressed, Color color = Colors.black87}) {
    return Expanded(
      child: FlatButton(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              Text(title,
                  style: Theme.of(context)
                      .textTheme
                      .caption
                      .merge(TextStyle(color: color)))
            ],
          ),
          onPressed: onPressed),
    );
  }

  Future onScan() async {
    await Navigator.pushNamed(context, '/scan').then((value) {
      setState(() {
        setState(() {});
      });
    });
  }
}

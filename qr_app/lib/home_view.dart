import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:qr_app/core.dart';
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
          title: const Text('SCAN LITE'),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
            ),
            onPressed: onScan,
          ),
          actions: <Widget>[
            IconButton(
                icon: Icon(Icons.history),
                onPressed: () {
                  Navigator.pushNamed(context, '/history').then((value) {
                    setState(() {});
                  });
                }),
          ],
        ),
        body: Container(child: _buildBody()),
        floatingActionButton: FloatingActionButton(
          onPressed: onScan,
          child: Icon(Icons.crop_free),
        ),
      ),
    );
  }

  Widget _buildBody() {
    if (Core.instance.currentCode == null) {
      return Container(
        padding: const EdgeInsets.only(top: 32),
        alignment: Alignment.topCenter,
        child: const Text(
          "You have not scanned",
          textAlign: TextAlign.center,
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      );
    } else {
      return SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 64),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                Core.instance.currentCode.barcode,
                textAlign: TextAlign.left,
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
                        icon: Icons.share, color: Colors.purple, onPressed: () {
                      Share.share(Core.instance.currentCode.barcode);
                    }),
                    buildBottomButton('Copy',
                        icon: Icons.content_copy,
                        color: Colors.green, onPressed: () {
                      Clipboard.setData(
                          ClipboardData(text: Core.instance.currentCode.barcode));
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

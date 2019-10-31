import 'package:flutter/material.dart';
import 'package:qr_app/core.dart';

import 'app_styles.dart';

class HistoryVIew extends StatefulWidget {
  @override
  _HistoryVIewState createState() => new _HistoryVIewState();
}

class _HistoryVIewState extends State<HistoryVIew> {
  List<HistoryUnit> _historyData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() {
    Core.instance.loadHistoryData().then((value) {
      setState(() {
        _historyData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
          backgroundColor: AppStyles.colorBackground,
          appBar: new AppBar(
            elevation: 0,
            backgroundColor: AppStyles.colorSurface,
            title: Text(
              'History',
            ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back,
              ),
              onPressed: () {
                onBack(null);
              },
            ),
          ),
          body: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (_historyData == null || _historyData.length == 0) {
      return new Container(
        child: new Center(
          child: new Text(
            'This list is empty.',
            style: AppStyles.h3(),
          ),
        ),
        padding: const EdgeInsets.all(20.0),
      );
    } else {
      return new Container(
        child: new ListView.separated(
          itemCount: _historyData.length,
          itemBuilder: _buildItem,
          separatorBuilder: (context, index) {
            return Container(
              height: 1,
              color: Colors.white,
            );
          },
        ),
        padding: const EdgeInsets.symmetric(horizontal: 20),
      );
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    HistoryUnit unit = _historyData[index];
    return InkWell(
      onTap: () {
        onBack(unit);
      },
      child: Container(
//          color: Colors.black12,
          child: Column(
            children: <Widget>[
              SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: Text(
                  unit.date,
                  textAlign: TextAlign.left,
                  style: AppStyles.h3(color: Colors.white),
                ),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: double.infinity,
                child: Text(
                  unit.barcode,
                  textAlign: TextAlign.left,
                  style: AppStyles.body2(color: Colors.white70),
                ),
              ),
              SizedBox(height: 10),
            ],
          )),
    );
  }

  onBack(barcode) {
    Core.instance.currentCode = barcode;
    Navigator.pop(context);
  }
}


import 'package:flutter/material.dart';
import 'package:qr_app/history_data.dart';

class HistoryPage extends StatefulWidget {

  @override
  _HistoryPageState createState() => new _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {

  List<HistoryUnit> _historyData;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadData();
  }

  void loadData() {
    loadHistoryData().then((value) {
      setState(() {
        _historyData = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
        home: new Scaffold(
            appBar: new AppBar(
              elevation: 0,
              backgroundColor: Colors.white10,
              title: Text('HISTORY', style: TextStyle(color: Colors.black),),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back, color: Colors.black,),
                onPressed: () {
                  onBack('');
                },
              ),
            ),
            body: _buildBody()
          ),
    );
  }
  Widget _buildBody() {
    if (_historyData == null || _historyData.length == 0) {
      return new Container(
        child: new Center(
          child: new Text('Empty'),
        ),
        padding: const EdgeInsets.all(20.0),
      );
    }
    else {
      return new Container(
        child: new ListView.builder(
          itemBuilder:_buildItem,
          itemCount: _historyData.length,
        ),
        padding: const EdgeInsets.all(20.0),
      );
    }
  }
  Widget _buildItem(BuildContext context, int index) {
    HistoryUnit unit = _historyData[index];
    return RaisedButton(
        color: Colors.white10,
        elevation: 0,
        highlightElevation: 0,
        disabledElevation: 0,
        onPressed: () {
          onBack(unit.barcode);
        },
        child: Column(
          children: <Widget>[
            SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: Text(unit.date, textAlign: TextAlign.left),
            ),
            SizedBox(height: 5),
            SizedBox(
              width: double.infinity,
              child: Text(unit.barcode, textAlign: TextAlign.left, style: const TextStyle(fontWeight: FontWeight.normal),),
            ),
            SizedBox(height: 10),
            Container(
              height: 1,
              width: double.infinity,
              color: Colors.black,
            ),
          ],
        )
    );
  }
  onBack(String barcode)
  {
      Navigator.pop(context, barcode);
  }
}
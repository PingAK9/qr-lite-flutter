import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:qr_app/core.dart';
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

class HistoryVIew extends StatefulWidget {
  @override
  _HistoryVIewState createState() => _HistoryVIewState();
}

class _HistoryVIewState extends State<HistoryVIew> {
  List<HistoryUnit> _historyData;

  @override
  void initState() {
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
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('HISTORY'),
        ),
        body: _buildBody());
  }

  Widget _buildBody() {
    if (_historyData == null || _historyData.isEmpty) {
      return Container(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(
                Icons.message,
                size: 46,
                color: Colors.black54,
              ),
              const Text('THIS LIST IS EMPTY'),
            ],
          ),
        ),
        padding: const EdgeInsets.all(20),
      );
    } else {
      return ListView.separated(
        itemCount: _historyData.length,
        itemBuilder: _buildItem,
        padding: const EdgeInsets.all(15),
        separatorBuilder: (context, index) {
          return const Divider(thickness: 2);
        },
      );
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    final HistoryUnit unit = _historyData[index];
    return HistoryItemUI(unit);
  }
}

class HistoryItemUI extends StatefulWidget {
  const HistoryItemUI(this.item);

  final HistoryUnit item;

  @override
  _HistoryItemUIState createState() => _HistoryItemUIState();
}

class _HistoryItemUIState extends State<HistoryItemUI> {
  @override
  void initState() {
    super.initState();
    checkCanLaunch();
  }

  bool _canLaunch = false;

  Future checkCanLaunch() async {
    _canLaunch = await canLaunch(widget.item.barcode);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(Icons.date_range, size: 15, color: Colors.blue),
              const SizedBox(width: 5),
              Text(widget.item.date, style: TextStyle(color: Colors.blue))
            ],
          ),
          const SizedBox(height: 5),
          Text(widget.item.barcode),
          const SizedBox(height: 8),
          Row(
            children: <Widget>[
              buildBottomButton('Share',
                  icon: Icons.share, color: Colors.purple, onPressed: () {
                Share.share(Core.instance.currentCode.barcode);
              }),
              buildBottomButton('Copy',
                  icon: Icons.content_copy, color: Colors.green, onPressed: () {
                Clipboard.setData(
                    ClipboardData(text: Core.instance.currentCode.barcode));
                Scaffold.of(context).showSnackBar(const SnackBar(
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
        ],
      ),
    );
  }

  Widget buildBottomButton(String title,
      {IconData icon, VoidCallback onPressed, Color color = Colors.black87}) {
    return Expanded(
      child: FlatButton(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(
                icon,
                color: color,
                size: 20,
              ),
              Text(
                title,
                style: Theme.of(context).textTheme.caption.merge(
                      TextStyle(color: color),
                    ),
              )
            ],
          ),
          onPressed: onPressed),
    );
  }
}

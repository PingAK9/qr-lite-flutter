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
          backgroundColor: const Color(0xFF07C5CE),
          centerTitle: true,
          title: const Text(
            'History',
          ),
        ),
        body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                stops: const [0.1, 1],
                colors: [
                  const Color(0xFF07C5CE),
                  const Color(0xFFF0F5FC).withAlpha(50),
                ],
              ),
            ),
            child: _buildBody()));
  }

  final List<Color> _colors = [
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple
  ];

  Widget _buildBody() {
    if (_historyData == null || _historyData.isEmpty) {
      return Container(
        child: const Center(
          child: Text(
            'This list is empty.',
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
          return const SizedBox(
            height: 20,
          );
        },
      );
    }
  }

  Widget _buildItem(BuildContext context, int index) {
    final HistoryUnit unit = _historyData[index];
    return HistoryItemUI(
      unit,
      colorBorder: _colors[index % 4],
    );
  }
}

class HistoryItemUI extends StatefulWidget {
  const HistoryItemUI(this.item, {this.colorBorder = const Color(0xFF0087F0)});

  final HistoryUnit item;
  final Color colorBorder;

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
    return Slidable(
      key: Key(widget.item.toMap().toString()),
      actionPane: const SlidableDrawerActionPane(),
      actionExtentRatio: 0.25,
      secondaryActions: [
        _buildButtonAction(
            color: Colors.purple,
            icon: Icons.share,
            callback: () {
              Share.share(widget.item.barcode);
            }),
        _buildButtonAction(
            color: Colors.green,
            icon: Icons.content_copy,
            callback: () {
              Clipboard.setData(
                  ClipboardData(text: widget.item.barcode));
            }),
        if (_canLaunch)
          _buildButtonAction(
              color: Colors.blue,
              icon: Icons.link,
              callback: () {
                launch(widget.item.barcode);
              }),
      ],
      child: Container(
        padding: const EdgeInsets.only(left: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            color: widget.colorBorder,
            boxShadow: [
              BoxShadow(
                color: widget.colorBorder.withAlpha(50),
                offset: const Offset(1, 4),
                blurRadius: 5,
              ),
            ]),
        child: InkWell(
          onTap: () {
            Core.instance.currentCode = widget.item;
            Navigator.pop(context);
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              color: Colors.white,
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  child: Icon(
                    _canLaunch ? Icons.link : Icons.code,
                    color: widget.colorBorder,
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
                            widget.item.date,
                            textAlign: TextAlign.left,
                            style: TextStyle(color: Colors.blue),
                          )
                        ],
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        width: double.infinity,
                        child: Text(
                          widget.item.barcode,
                          textAlign: TextAlign.left,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildButtonAction(
      {Color color = Colors.grey,
      IconData icon = Icons.notifications,
      VoidCallback callback}) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      child: IconButton(
        onPressed: callback,
        icon: Icon(
          icon,
          color: Colors.white,
        ),
      ),
    );
  }
}

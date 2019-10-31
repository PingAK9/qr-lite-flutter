import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Core {

  static final Core instance = Core._internal();

  factory Core() => instance;

  Core._internal() {
    currentCode = null;
  }


  HistoryUnit currentCode;
  List<HistoryUnit> historyData;

  Future<List<HistoryUnit>> loadHistoryData() async {
    if (historyData == null) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String response = prefs.getString('key_history_data');
      if (response != null) {
        var list = json.decode(response) as List;
        historyData = list.map((i) => HistoryUnit.fromJson(i)).toList();
      } else {
        historyData = new List();
      }
    }
    return historyData;
  }

  addNewHistoryUnit(String barcode) async {
    HistoryUnit unit = HistoryUnit.createNew(barcode);
    currentCode = unit;
    if (historyData == null) {
      await loadHistoryData();
    }
    historyData.insert(0, unit);
    if (historyData.length > 10) {
      historyData.removeLast();
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var myJsonString = json.encode(
        historyData.map((value) => value.toMap()).toList());
    prefs.setString('key_history_data', myJsonString);
  }

}


class HistoryUnit
{
  String date;
  String barcode;

  HistoryUnit({this.barcode, this.date});


  factory HistoryUnit.createNew(value) {
    DateTime today = DateTime.now();
    String date = "${today.month.toString().padLeft(2, '0')}-${today.day
        .toString().padLeft(2, '0')}-${today.year.toString()}";
    return HistoryUnit(
      barcode: value.toString(),
      date: date,
    );
  }

  factory HistoryUnit.fromJson(Map<String, dynamic> json) {
    return HistoryUnit(
      barcode: json['barcode'],
      date: json['date'],
    );
  }
  Map toMap() {
    var map = new Map<String, dynamic>();
    map["barcode"] = barcode;
    map["date"] = date;
    return map;
  }
}
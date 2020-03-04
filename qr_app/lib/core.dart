import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class Core {
  factory Core() => instance;

  Core._internal() {
    currentCode = null;
  }

  static final Core instance = Core._internal();

  HistoryUnit currentCode;
  List<HistoryUnit> historyData;

  Future<List<HistoryUnit>> loadHistoryData() async {
    if (historyData == null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String response = prefs.getString('key_history_data');
      if (response != null) {
        final list = json.decode(response) as List;
        historyData = list.map((i) => HistoryUnit.fromJson(i)).toList();
      } else {
        historyData = [];
      }
    }
    return historyData;
  }

  Future addNewHistoryUnit(String barcode) async {
    final HistoryUnit unit = HistoryUnit.createNew(barcode);
    currentCode = unit;
    if (historyData == null) {
      await loadHistoryData();
    }
    historyData.insert(0, unit);
    if (historyData.length > 10) {
      historyData.removeLast();
    }
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final myJsonString =
        json.encode(historyData.map((value) => value.toMap()).toList());
    await prefs.setString('key_history_data', myJsonString);
  }
}

class HistoryUnit {
  HistoryUnit({this.barcode, this.date});

  String date;
  String barcode;

  factory HistoryUnit.createNew(value) {
    final DateTime today = DateTime.now();
    final String date =
        "${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}-${today.year.toString()}";
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
    final map = <String, dynamic>{};
    map["barcode"] = barcode;
    map["date"] = date;
    return map;
  }
}

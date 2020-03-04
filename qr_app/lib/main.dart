import 'package:flutter/material.dart';
import 'package:qr_app/home_view.dart';
import 'package:qr_app/history_view.dart';
import 'package:qr_app/scan_ml.dart';
import 'package:qr_app/scan_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: const Color(0xFF07C5CE),
        accentColor: Colors.teal[200],
        appBarTheme: AppBarTheme(

            iconTheme: IconThemeData(color: Colors.white),
            elevation: 0,
            actionsIconTheme: IconThemeData(color: Colors.white),
            textTheme: TextTheme(
                title: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w700))),
      ),
      title: 'My App',
      initialRoute: '/scan',
      routes: {
        '/home': (_) => HomeView(),
        '/history': (_) => HistoryVIew(),
        '/scan': (_) => ScanView(),
      },
    );
  }
}

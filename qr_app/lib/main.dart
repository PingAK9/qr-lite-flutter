import 'package:flutter/material.dart';
import 'package:qr_app/home_view.dart';
import 'package:qr_app/history_view.dart';
import 'package:qr_app/scan_view.dart';

void main() {

  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Colors.purple[200],
        accentColor: Colors.teal[200],
        backgroundColor: Color(0xff121212),
//        fontFamily: 'Montserrat',
        iconTheme: IconThemeData(color: Colors.white),
        appBarTheme: AppBarTheme(
          iconTheme: IconThemeData(color: Colors.white),
          brightness: Brightness.dark,
          elevation: 0,
          actionsIconTheme: IconThemeData(color: Colors.white),
        ),
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          title: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          overline: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          button: TextStyle(color: Colors.white),
        ),
      ),
      title: 'Named Routes Demo',
      initialRoute: '/scan',
      routes: {
        '/home': (BuildContext build) => new HomeView(),
        '/history': (BuildContext build) => new HistoryVIew(),
        '/scan': (BuildContext build) => new ScanView(),
      },
    );
  }
}

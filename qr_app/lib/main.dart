
import 'package:flutter/material.dart';
import 'package:qr_app/scan_page.dart';
import 'package:qr_app/history_page.dart';

void main() {
  runApp(new MyApp());
}


class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // Define the default Brightness and Colors
        brightness: Brightness.light,
//        primaryColor: Colors.lightGreen,
//        accentColor: Colors.lightGreen,

        // Define the default Font Family
        fontFamily: 'Montserrat',

        // Define the default TextTheme. Use this to specify the default
        // text styling for headlines, titles, bodies of text, and more.
        textTheme: TextTheme(
          headline: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
          title: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold, color: Colors.white),
          overline: TextStyle(fontSize: 14, fontStyle: FontStyle.italic),
          button: TextStyle(color: Colors.white),
        ),
      ),
      title: 'Named Routes Demo',
      initialRoute: '/',
      routes: {
        '/': (BuildContext build)=> new  ScanPage(),
        '/history': (BuildContext build)=> new HistoryPage(),
      },
    );
  }
}

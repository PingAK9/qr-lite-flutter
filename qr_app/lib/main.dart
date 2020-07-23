import 'package:flutter/material.dart';
import 'package:qr_app/home_view.dart';
import 'package:qr_app/history_view.dart';
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
        scaffoldBackgroundColor: Colors.white,
        brightness: Brightness.light,
        appBarTheme: AppBarTheme(
          elevation: 1,
          color: Colors.white,
          iconTheme: IconThemeData(color: Colors.black54),
          actionsIconTheme: IconThemeData(color: Colors.black54),
          textTheme: TextTheme(
            headline6: TextStyle(
                color: Colors.black54, fontSize: 18, fontWeight: FontWeight.w500),
          ),
        ),
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: FadeUpwardsPageTransitionsBuilder(),
          },
        ),

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

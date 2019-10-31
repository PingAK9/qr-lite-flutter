import 'package:flutter/material.dart';

class AppStyles{

  static Color colorBackground = Color(0xff121212);
  static Color colorSurface = Color(0xff1e1e1e);
  static Color colorPrimary = Colors.purple[200];
  static Color colorSecondary = Colors.teal[200];

  static TextStyle h1({color = Colors.white}){
    return TextStyle(fontSize: 24, color: color, fontWeight: FontWeight.bold);
  }
  static TextStyle h2({color = Colors.white}){
    return TextStyle(fontSize: 20, color: color, fontWeight: FontWeight.bold);
  }
  static TextStyle h3({color = Colors.white}){
    return TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.w500);
  }
  static TextStyle body1({color = Colors.white}){
    return TextStyle(fontSize: 18, color: color, fontWeight: FontWeight.normal);
  }
  static TextStyle body2({color = Colors.white}){
    return TextStyle(fontSize: 16, color: color, fontWeight: FontWeight.normal);
  }
  static TextStyle caption({color = Colors.white}){
    return TextStyle(fontSize: 14, color: color, fontWeight: FontWeight.normal);
  }
}
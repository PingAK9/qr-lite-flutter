import 'dart:math';

import 'package:flutter/material.dart';

class ScanFocus extends StatelessWidget {
  final double borderSize = 30;
  final BorderSide borderSide = BorderSide(color: Colors.white, width: 4);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final double squareSize = min(250, size.width);
    return Hero(
      tag: 'scan forcus',
      child: Container(
        width: squareSize,
        height: squareSize,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                height: borderSize,
                width: borderSize,
                decoration: BoxDecoration(
                    border: Border(
                      top: borderSide,
                      left: borderSide,
                    )),
              ),
            ),
            Positioned(
              top: 0,
              right: 0,
              child: Container(
                height: borderSize,
                width: borderSize,
                decoration: BoxDecoration(
                    border: Border(
                      top: borderSide,
                      right: borderSide,
                    )),
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              child: Container(
                height: borderSize,
                width: borderSize,
                decoration: BoxDecoration(
                    border: Border(
                      bottom: borderSide,
                      left: borderSide,
                    )),
              ),
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Container(
                height: borderSize,
                width: borderSize,
                decoration: BoxDecoration(
                    border: Border(
                      bottom: borderSide,
                      right: borderSide,
                    )),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

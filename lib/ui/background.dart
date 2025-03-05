import 'dart:math';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.lightBlue],
          stops: [0.3, 0.9]));

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          decoration: boxDecoration,
        ),
        Positioned(
          top: -130,
          left: -15,
          child: Column(
            children: [
              Box(),
            ],
          ),
        ),
        Positioned(
          top: 340,
          left: 105,
          child: Column(
            children: [
              Box2(),
            ],
          ),
        ),
      ],
    );
  }
}

class Box extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5,
      child: Container(
          height: 330,
          width: 500,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.white],
                  stops: [0.0, 0.8]))),
    );
  }
}

class Box2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 180 / pi,
      child: Container(
          height: 390,
          width: 300,
          decoration: BoxDecoration(
              color: Colors.blue,
              borderRadius: BorderRadius.circular(40),
              gradient: LinearGradient(
                  colors: [Colors.blue.shade300, Colors.white],
                  stops: [0.0, 0.8]))),
    );
  }
}

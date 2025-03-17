import 'dart:math';
import 'package:flutter/material.dart';

class Background extends StatelessWidget {
  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Colors.white, Colors.lightBlue],
          stops: [0.3, 0.9]));

  const Background({super.key});

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
              customBox(),
            ],
          ),
        ),
        Positioned(
          top: 340,
          left: 105,
          child: Column(
            children: [
              customBox2(),
            ],
          ),
        ),
      ],
    );
  }
}

class customBox extends StatelessWidget {
  const customBox({super.key});

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
                  stops: const [0.0, 0.8]))),
    );
  }
}

class customBox2 extends StatelessWidget {
  const customBox2({super.key});

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
                  stops: const [0.0, 0.8]))),
    );
  }
}

class customBox3 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: -pi / 5,
      child: Container(
          height: 330,
          width: 500,
          decoration: BoxDecoration(
              color: const Color(0xFF03045e),
              borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(
                  colors: [Color(0xFFcaf0f8), Color(0xFF0077b6)],
                  stops: [0.0, 0.8]))),
    );
  }
}

class customBox4 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 180 / pi,
      child: Container(
          height: 390,
          width: 300,
          decoration: BoxDecoration(
              color: const Color(0xFF03045e),
              borderRadius: BorderRadius.circular(40),
              gradient: const LinearGradient(
                  colors: [Color(0xFFcaf0f8), Color(0xFF0077b6)],
                  stops: [0.0, 0.8]))),
    );
  }
}
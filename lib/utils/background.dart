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
        const Positioned(
          top: -130,
          left: -15,
          child: Column(
            children: [
              CustomBox(),
            ],
          ),
        ),
        const Positioned(
          top: 340,
          left: 105,
          child: Column(
            children: [
              CustomBox2(),
            ],
          ),
        ),
      ],
    );
  }
}

class CustomBox extends StatelessWidget {
  const CustomBox({super.key});

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

class CustomBox2 extends StatelessWidget {
  const CustomBox2({super.key});

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

class CustomBox3 extends StatelessWidget {
  const CustomBox3({super.key});

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

class CustomBox4 extends StatelessWidget {
  const CustomBox4({super.key});

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
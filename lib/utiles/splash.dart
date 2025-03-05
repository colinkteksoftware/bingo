import 'package:flutter/material.dart';
//import 'package:shimmer/shimmer.dart';

class Splash extends StatelessWidget {
  const Splash({Key? key}) : super(key: key);
  static const String routeName = '/splash';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        alignment: Alignment.center,
        children: [
          /*          Shimmer.fromColors(
            child: Padding(
              padding: const EdgeInsets.only(top: 150),
              child: Column(
                children: [
                  Image.asset('assets/images/bingo.png'),
                  Text('Caragando.........')
                ],
              ),
            ),
            baseColor: Colors.blue,
            highlightColor: Colors.green,
          ) */
        ],
      ),
    );
  }
}

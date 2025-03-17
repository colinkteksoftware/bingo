import 'package:flutter/material.dart';

class HeadersOptionsWidget extends StatelessWidget {
  const HeadersOptionsWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
        child: Center(
            child: Text(
          "Pagos",
          style: TextStyle(
            color: const Color(0xFFcaf0f8),
            fontSize: size.width * 0.03,
            fontFamily: 'gotic',
            fontWeight: FontWeight.bold,
          ),
        )));
  }
}
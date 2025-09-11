import 'package:bingo/utils/colores.dart';
import 'package:flutter/material.dart';

class BackButtonWidget extends StatelessWidget {
  const BackButtonWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Positioned(
      top: 10,
      left: 16,
      child: IconButton(
        icon: Icon(
          Icons.arrow_back,
          color: primaryBlue,
          size: size.width * 0.08,
        ),
        onPressed: () async {
          Navigator.of(context).pop();
        } 
      ),
    );
  }
}
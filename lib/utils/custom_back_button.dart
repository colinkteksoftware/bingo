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
          color: const Color(0xFF03045e),
          size: size.width * 0.08,
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }
}
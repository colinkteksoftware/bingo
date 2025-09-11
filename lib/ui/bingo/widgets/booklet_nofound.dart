import 'package:bingo/utils/colores.dart';
import 'package:flutter/material.dart';

class BookletNoFound extends StatelessWidget {
  const BookletNoFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return const Center(
      child:
          Column(
        mainAxisAlignment:
            MainAxisAlignment.center,
        crossAxisAlignment:
            CrossAxisAlignment.center,
        children: [
          Icon(
            Icons.cancel,
            color: primaryBlue,
            size: 60,
          ),
          SizedBox(height: 10),
          Text(
            'No hay cartillas para la venta o el módulo ya fue vendido.',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: primaryBlue,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

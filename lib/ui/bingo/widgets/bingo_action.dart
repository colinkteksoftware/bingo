import 'package:animated_button/animated_button.dart';
import 'package:flutter/material.dart';

class BingoActionsWidget extends StatelessWidget {
  final Size size;
  final Function() onPaymentPressed;
  final Function() onSalesPressed;
  final Function() onUvtPressed;
  final Function() onCustomerPressed;

  const BingoActionsWidget({
    Key? key,
    required this.size,
    required this.onPaymentPressed,
    required this.onSalesPressed,
    required this.onUvtPressed,
    required this.onCustomerPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        _buildAnimatedButton(
          size,
          "Payment",
          onPaymentPressed,
          "Pago",
        ),
        _buildAnimatedButton(
          size,
          "Ventas",
          onSalesPressed,
          "Ventas",
        ),
        _buildAnimatedButton(
          size,
          "UVT",
          onUvtPressed,
          "UVT",
        ),
        _buildAnimatedButton(
          size,
          "Clientes",
          onCustomerPressed,
          "Clientes",
        ),
      ],
    );
  }

  Widget _buildAnimatedButton(
    Size size,
    String buttonText,
    Function() onPressed,
    String textLabel,
  ) {
    return AnimatedButton(
      color: const Color(0xFF03045e),
      height: size.height * 0.05,
      width: size.width * 0.16,
      duration: 2,
      onPressed: onPressed,
      child: Center(
        child: Text(
          textLabel,
          style: TextStyle(
            color: const Color(0xFFcaf0f8),
            fontSize: size.width * 0.03,
            fontFamily: 'gotic',
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

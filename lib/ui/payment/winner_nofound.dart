import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/custom_back_button.dart';
import 'package:flutter/material.dart';

class WinnerNoFound extends StatelessWidget {
  const WinnerNoFound({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFcaf0f8),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Stack(
          children: [
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
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      child: Image.asset(
                        "assets/images/logo.png",
                        height: 100,
                        width: 250,
                        fit: BoxFit.fill,
                      ),
                    ),
                    Text(
                      'Lista de Ganadores del Bingo'.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'Inter Tight',
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    const Center(
                        child: Text(
                      'No hay pagos pendientes',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ))
                  ],
                ),
              ),
            ),
            const BackButtonWidget(),
          ],
        ),
      ),
    );
  }
}
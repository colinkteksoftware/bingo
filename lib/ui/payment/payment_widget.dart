import 'dart:async';
import 'package:bingo/core/data/models/bingo.dart';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/providers/payment_provider.dart';
import 'package:bingo/ui/payment/winner_nofound.dart';
import 'package:bingo/ui/home/widgets/list_winner_widget.dart';
import 'package:bingo/utils/custom_back_button.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentWidget extends StatefulWidget {
  const PaymentWidget({super.key});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  List<Widget> widgets = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<BingoProvider>(context, listen: false);
      loadBingos(provider.bingo);
      /*final provider = Provider.of<PaymentProvider>(context, listen: false);
      await provider.getWinners(context);*/
    });
  }

  Future<void> loadBingos(Bingo bingo) async {
    try {
      final provider = Provider.of<PaymentProvider>(context, listen: false);
      provider.updateBingo(bingo);
      await provider.getAmountUVT();
      //ganadores
      await provider.getWinners(context);
    } catch (e) {
      print('Error al cargar el bingo: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<PaymentProvider>(
      builder: (context, provider, _) {
        //print('informacion del bingo seleccionado => ${provider.bingo}');
        if (provider.bingo.estado == 1 ||
            provider.bingo.estado == 2 ||
            provider.bingo.estado == 3) {
          return Consumer<PaymentProvider>(
            builder: (context, provider, _) {
              if (provider.bingo.estado == 1 ||
                  provider.bingo.estado == 2 ||
                  provider.bingo.estado == 3) {
                return Scaffold(
                  backgroundColor: const Color(0xFFcaf0f8),
                  body: Stack(
                    children: [
                      const Positioned(
                        top: -120,
                        left: -15,
                        child: CustomBox(),
                      ),
                      const Positioned(
                        top: 340,
                        left: 105,
                        child: CustomBox2(),
                      ),                      
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: SingleChildScrollView(
                          physics: const BouncingScrollPhysics(),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              const SizedBox(
                                  height: 20),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
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
                              const SizedBox(height: 5),
                              const BuildWinnersList(),
                            ],
                          ),
                        ),
                      ),
                      
                      const Positioned(
                        top: 30,
                        left: 15,
                        child: BackButtonWidget(),
                      ),
                    ],
                  ),
                );
              } else {
                return const WinnerNoFound();
              }
            },
          );
        } else {
          return const WinnerNoFound();
        }
      },
    );
  }
}

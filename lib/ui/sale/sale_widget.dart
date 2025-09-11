import 'dart:async';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/providers/sale_provider.dart';
import 'package:bingo/ui/sale/widgets/sale_card.dart';
import 'package:bingo/ui/sale/widgets/sale_nofound.dart';
import 'package:bingo/utils/colores.dart';
import 'package:bingo/utils/custom_back_button.dart';
import 'package:bingo/utils/background.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class SaleWidget extends StatefulWidget {
  const SaleWidget({super.key});

  @override
  State<SaleWidget> createState() => _SaleWidgetState();
}

class _SaleWidgetState extends State<SaleWidget> {
  String searchString = '';
  String searchStringproduct = '';
  String detectionInfo = '';

  //Timer? _timer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<SaleProvider>(context, listen: false);      
      provider.fetchSales();
    });
    //_startPolling();
  }
  // NO BORRAR!!! - sirve para hacer consulta cada x tiempo
  /*void _startPolling() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      final paymentProvider =
          Provider.of<PaymentProvider>(context, listen: false);
      final provider = Provider.of<SaleProvider>(context, listen: false);
      provider.updateCurrentDate(DateTime.now());
      provider.fetchSales();

      if (paymentProvider.bingo.estado == 3) {
        _timer?.cancel();
        if (mounted) {
          Navigator.of(context).popUntil((route) => route.isFirst);
        }
      }
    });
  }*/

  /*@override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }*/

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final provider = Provider.of<BingoProvider>(context, listen: false);
    final providerSale = Provider.of<SaleProvider>(context, listen: false);
    DateTime maxDate = providerSale.currentDate.add(const Duration(days: 365));
    return Scaffold(
        backgroundColor: const Color(0xFFcaf0f8),
        body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
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
                    alignment: const AlignmentDirectional(0, 0),
                    child: Container(
                        height: size.height,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                            alignment: const AlignmentDirectional(0, 0),
                            child: Padding(
                                padding: const EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 100,
                                        width: 250,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/logo.png"),
                                              fit: BoxFit.fill),
                                        ),
                                        alignment:
                                            const AlignmentDirectional(0, 0),
                                      ),
                                      SizedBox(
                                        height: size.height * 0.09,
                                        child: ScrollDatePicker(
                                          options: const DatePickerOptions(
                                            backgroundColor: Color(0xFFcaf0f8),
                                          ),
                                          maximumDate: maxDate,
                                          selectedDate:
                                              providerSale.currentDate,
                                          locale: const Locale('es'),
                                          onDateTimeChanged: (DateTime date) {
                                            providerSale
                                                .updateCurrentDate(date);
                                            providerSale.fetchSales();
                                          },
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Padding(
                                          padding: const EdgeInsets.only(
                                              left: 30, right: 30, bottom: 10),
                                          child: Container(
                                            width: size.width * 0.62,
                                            padding: const EdgeInsets.only(
                                                top: 0, bottom: 0),
                                            height: size.height * 0.06,
                                            child: TextField(
                                              style: TextStyle(
                                                color: const Color(0xFF424242),
                                                fontSize: size.width * 0.04,
                                              ),
                                              onChanged: (value) async {
                                                setState(() {
                                                  detectionInfo = "";
                                                  searchString =
                                                      value.toUpperCase();
                                                });
                                              },
                                              onSubmitted: (value) async {
                                                setState(() {
                                                  detectionInfo = "";
                                                  searchString =
                                                      value.toUpperCase();
                                                });
                                              },
                                              decoration: InputDecoration(
                                                floatingLabelStyle: TextStyle(
                                                  color:
                                                      const Color(0xFF424242),
                                                  fontSize: size.width * 0.04,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: primaryBlue,
                                                      width: 2.0),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                ),
                                                focusedBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 2.0,
                                                  ),
                                                ),
                                                errorBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xFF7CBF4F),
                                                    width: 2.0,
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xFF7CBF4F),
                                                    width: 2.0,
                                                  ),
                                                ),
                                                labelText: detectionInfo.isEmpty
                                                    ? "Buscar"
                                                    : detectionInfo,
                                                labelStyle: TextStyle(
                                                  color:
                                                      const Color(0xFF424242),
                                                  fontSize: size.width * 0.04,
                                                ),
                                                isDense: true,
                                                filled: true,
                                                fillColor:
                                                    const Color(0xFFcaf0f8),
                                              ),
                                            ),
                                          )),
                                      Consumer<SaleProvider>(
                                        builder: (context, providerSale, _) {
                                          if (providerSale.isLoading) {
                                            return const Center(
                                                child:
                                                    CircularProgressIndicator(
                                                        color: primaryBlue));
                                          }

                                          if (providerSale.listSales.isEmpty) {
                                            return const SaleNoFound();
                                          }

                                          return SizedBox(
                                            height: size.height * 0.56,
                                            child: ListView.separated(
                                              separatorBuilder:
                                                  (context, index) =>
                                                      const Divider(
                                                height: 0,
                                                color: Color(0xFFcaf0f8),
                                                thickness: 0,
                                                indent: 0,
                                                endIndent: 0,
                                              ),
                                              itemCount:
                                                  providerSale.listSales.length,
                                              itemBuilder: (ctx, index) {
                                                final order = providerSale
                                                    .listSales[index];

                                                final matchesSearch = order
                                                            .bingo
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(provider
                                                                .bingo.bingoId
                                                                .toString()) &&
                                                        order.ventaId
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains(
                                                                searchString) ||
                                                    order.codigoModulo
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains(searchString);

                                                if (!matchesSearch) {
                                                  return Container();
                                                }

                                                return CustomSaleCard(
                                                    size: MediaQuery.of(context)
                                                        .size,
                                                    order: order,
                                                    context: context);
                                              },
                                            ),
                                          );
                                        },
                                      ),                                      
                                    ]))))),
                const BackButtonWidget(),
              ],
            )));
  }
}

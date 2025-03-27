import 'dart:convert';
import 'package:bingo/models/uvtconvert.dart';
import 'package:bingo/providers/winner_provider.dart';
import 'package:bingo/ui/user/update_user_page.dart';
import 'package:bingo/utils/custom_back_button.dart';
import 'package:intl/intl.dart';
import 'package:animated_button/animated_button.dart';
import 'package:bingo/models/modelCliente.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/models/bingoconvert.dart';
import 'package:bingo/models/pagosconvert.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class PaymentWidget extends StatefulWidget {
  final ModelCliente? datosuser;
  final Bingo? bingo;

  const PaymentWidget(
      {super.key, required this.datosuser, required this.bingo});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
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
                    ),
                    const SizedBox(height: 16),
                    BuildWinnersList(
                        datosuser: widget.datosuser, bingo: widget.bingo),
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

class BuildWinnersList extends StatefulWidget {
  final ModelCliente? datosuser;
  final Bingo? bingo;
  const BuildWinnersList(
      {super.key, required this.datosuser, required this.bingo});

  @override
  State<BuildWinnersList> createState() => _BuildWinnersListState();
}

class _BuildWinnersListState extends State<BuildWinnersList> {
  Uvt? uvtData;
  List<Pago>? winnersList;
  double totaluvt = 0;
  TextEditingController dniController = TextEditingController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await _loadWinners();
      await _loadUVT();
    });
  }

  Future<void> _loadWinners() async {
    var provider = Provider.of<WinnerProvider>(context, listen: false);
    if (widget.datosuser != null) {
      final winners = await provider
          .getWinners(widget.datosuser?.promotorId.toString() ?? '');
      setState(() {
        winnersList = winners;
      });
    }
  }

  Future<void> _loadUVT() async {
    var provider = Provider.of<WinnerProvider>(context, listen: false);
    final uvt = await provider.getAmountUVT();
    setState(() {
      uvtData = uvt;
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Consumer<WinnerProvider>(
      builder: (context, winnerProvider, child) {
        if (winnerProvider.isLoadingWinners) {
          return const Center(child: CircularProgressIndicator());
        }
        if (winnerProvider.paymentsList == null ||
            winnerProvider.paymentsList!.isEmpty) {
          return const Center(
              child: Text(
            'No hay ganadores disponibles',
            style: TextStyle(fontWeight: FontWeight.w600),
          ));
        }

        return SizedBox(
          height: size.height,
          child: ListView.builder(
            itemCount: winnerProvider.paymentsList!.length,
            itemBuilder: (context, index) {
              final order = winnerProvider.paymentsList![index];
              double totalPremioAdicional = 0;
              double amount = 0;
              double totalValorPremio = 0;

              String jsonBody = json.encode(order.toJson());
              print('Pago pendiente => $jsonBody');

              if (order.detallePremioFigura!.isNotEmpty &&
                  order.detallePremioFigura?.length == 1) {
                totalValorPremio =
                    order.detallePremioFigura!.first.valorPremio ?? 0;

                if (order
                    .detallePremioFigura!.first.listaAdicionales!.isNotEmpty) {
                  totalPremioAdicional = order
                      .detallePremioFigura!.first.listaAdicionales!
                      .map((adicional) => adicional.premioAdicional as double)
                      .reduce((value, element) => value + element);
                }
              } else {
                if (order.detallePremioFigura!.length > 1) {
                  for (var detalle in order.detallePremioFigura!) {
                    if (detalle.listaAdicionales != null &&
                        detalle.listaAdicionales!.isNotEmpty) {
                      totalPremioAdicional += detalle.listaAdicionales!
                          .map((adicional) =>
                              adicional.premioAdicional as double)
                          .reduce((value, element) => value + element);
                    }
                  }

                  for (var detalle in order.detallePremioFigura!) {
                    if (detalle.valorPremio != null) {
                      totalValorPremio +=
                          detalle.valorPremio! + totalPremioAdicional;
                    }
                  }
                }
              }

              amount = totalValorPremio + totalPremioAdicional;
              /*print('Valor premio => $totalValorPremio');
              print('Valor Adicional => $totalPremioAdicional');
              print('Valor total => $amount');*/

              return GestureDetector(
                child: Padding(
                  padding: const EdgeInsets.only(left: 4, right: 4, bottom: 5),
                  child: Container(
                    width: size.width * 0.94,
                    height: size.height * 0.18,
                    decoration: BoxDecoration(
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage("assets/images/venta.png"),
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding:
                          const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 0),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                                0, 0, 0, 10),
                            child: Column(
                              children: [
                                Column(
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Text(
                                          "MODULO:",
                                          style: TextStyle(
                                              fontFamily: 'Inter Tight',
                                              color: Color(0xFFcaf0f8),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          '${order.codigoModulo}',
                                          style: const TextStyle(
                                              fontFamily: 'Inter Tight',
                                              color: Color(0xFFcaf0f8),
                                              letterSpacing: 0.0,
                                              fontWeight: FontWeight.w800,
                                              fontSize: 18),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 5),
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        AnimatedButton(
                                          color: const Color.fromARGB(
                                              255, 210, 193, 3),
                                          height: size.height * 0.07,
                                          width: size.width * 0.48,
                                          duration: 2,
                                          onPressed: () async {
                                            print('ESTADO BINGO => ${widget.bingo?.estado}');
                                            if (widget.bingo?.estado == 2) {
                                              setState(() {
                                                totaluvt =
                                                    uvtData!.cantidadUvt! == 0
                                                        ? 1
                                                        : double.parse(uvtData!
                                                            .cantidadUvt
                                                            .toString());
                                              });
                                              collectPrize(
                                                  context,
                                                  order,
                                                  amount,
                                                  size,
                                                  totalPremioAdicional,
                                                  totaluvt);
                                              setState(() {});
                                            }
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                top: 2,
                                                left: 0,
                                                right: 0,
                                                bottom: 2),
                                            child: Center(
                                              child: Column(
                                                children: [
                                                  Text(
                                                    "Valor Total: \$${NumberFormat('#,##0', 'en_US').format(amount)}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          size.width * 0.034,
                                                      fontFamily: 'gotic',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Valor Premio: \$${NumberFormat('#,##0', 'en_US').format(totalValorPremio)}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          size.width * 0.030,
                                                      fontFamily: 'gotic',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    "Valor Adicionales: \$${NumberFormat('#,##0', 'en_US').format(totalPremioAdicional)}",
                                                    style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize:
                                                          size.width * 0.030,
                                                      fontFamily: 'gotic',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 0, 0, 5),
                                      child: Row(
                                        children: [],
                                      )),
                                  Text(
                                    '${order.ventaId}'.toUpperCase(),
                                    style: const TextStyle(
                                      fontFamily: 'Inter Tight',
                                      color: Color(0xFFcaf0f8),
                                      fontSize: 12,
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w800,
                                    ),
                                  ),
                                ],
                              ),
                              Column(
                                mainAxisSize: MainAxisSize.max,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      //print('INFO BINGO => ${widget.bingo}');
                                      GestureDetector(
                                        child: InkWell(
                                          onTap: widget.bingo?.estado == 2
                                              ? () {
                                                  setState(() {
                                                    totaluvt = uvtData!
                                                                .cantidadUvt! ==
                                                            0
                                                        ? 1
                                                        : double.parse(uvtData!
                                                            .cantidadUvt
                                                            .toString());
                                                  });
                                                  collectPrize(
                                                      context,
                                                      order,
                                                      amount,
                                                      size,
                                                      totalPremioAdicional,
                                                      totaluvt);
                                                  setState(() {});
                                                }
                                              : null,
                                          child: Container(
                                            padding: const EdgeInsets.all(8.0),
                                            decoration: BoxDecoration(
                                              color: widget.bingo?.estado != 3
                                                  ? Colors.green[600]
                                                  : Colors.grey[400],
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Row(
                                              children: [
                                                Container(
                                                  padding:
                                                      const EdgeInsets.all(0),
                                                  child: Center(
                                                    child: Text(
                                                      'Registrar Pago',
                                                      style: TextStyle(
                                                        color: widget.bingo
                                                                    ?.estado !=
                                                                3
                                                            ? Colors.white
                                                            : Colors.grey[600],
                                                        fontSize:
                                                            size.width * 0.032,
                                                        fontFamily: 'gotic',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Icon(
                                                  Icons
                                                      .monetization_on_outlined,
                                                  size: size.width * 0.059,
                                                  color:
                                                      widget.bingo?.estado != 3
                                                          ? Colors.white
                                                          : Colors.grey[600],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }

  Future<dynamic> collectPrize(BuildContext context, Pago order, double amount,
      Size size, double totalPremioAdicional, double totaluvt) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFcaf0f8).withOpacity(1),
          title: Center(
            child: Text(
              'Desea registrar este pago del modulo: ${order.codigoModulo}',
              style: const TextStyle(color: Color(0xFF03045e)),
            ),
          ),
          content: Text(
            "Valor Total: \n${NumberFormat('#,##0', 'en_US').format(amount)}",
            style: const TextStyle(
              color: Color(0xFF0077b6),
              fontSize: 20,
              fontFamily: 'gotic',
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          actions: <Widget>[
            Column(
              children: [
                Column(children: [
                  Text(
                    "Premio: ${order.detallePremioFigura!.first.nombreFigura}",
                    style: const TextStyle(
                      color: Color(0xFF0077b6),
                      fontSize: 14,
                      fontFamily: 'gotic',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Valor Premio: \$ ${NumberFormat('#,##0', 'en_US').format(order.detallePremioFigura!.first.valorPremio ?? 0)}",
                    style: const TextStyle(
                      color: Color(0xFF0077b6),
                      fontSize: 14,
                      fontFamily: 'gotic',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
                for (var adicionales
                    in order.detallePremioFigura!.first.listaAdicionales!)
                  Column(children: [
                    Text(
                      "Premio Adicional: ${adicionales.categoria}",
                      style: const TextStyle(
                        color: Color(0xFF0077b6),
                        fontSize: 14,
                        fontFamily: 'gotic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Valor premio: \$ ${NumberFormat('#,##0', 'en_US').format(adicionales.premioAdicional ?? 0)}",
                      style: const TextStyle(
                        color: Color(0xFF0077b6),
                        fontSize: 14,
                        fontFamily: 'gotic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                Text(
                  "Valor total adicionales: \$ ${NumberFormat('#,##0', 'en_US').format(totalPremioAdicional ?? 0)}",
                  style: const TextStyle(
                    color: Color(0xFF0077b6),
                    fontSize: 14,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                amount >= (uvtData!.valorUvt! * totaluvt)
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: SizedBox(
                          width: size.width * 0.62,
                          height: size.height * 0.06,
                          child: TextFormField(
                            controller: dniController,
                            style: TextStyle(
                              color: const Color(0xFF424242),
                              fontSize: size.width * 0.04,
                            ),
                            decoration: InputDecoration(
                              floatingLabelStyle: TextStyle(
                                color: const Color(0xFF424242),
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF7CBF4F),
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF7CBF4F),
                                  width: 2.0,
                                ),
                              ),
                              labelText: "Ingrese DNI",
                              labelStyle: TextStyle(
                                color: const Color(0xFF424242),
                                fontSize: size.width * 0.04,
                              ),
                              isDense: true,
                              filled: true,
                              fillColor: const Color(0xFFcaf0f8),
                            ),
                          ),
                        ))
                    : Container(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      style: TextButton.styleFrom(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(0.0),
                          side: const BorderSide(color: Colors.grey),
                        ),
                        backgroundColor: Colors.red[900],
                      ),
                      child: Text(
                        'Cancelar',
                        style: TextStyle(
                            fontSize: size.width * 0.03,
                            color: const Color(0xFFcaf0f8)),
                      ),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(0.0),
                            side: const BorderSide(color: Colors.grey),
                          ),
                          backgroundColor: const Color(0xFF03045e),
                        ),
                        child: Text(
                          'Confirmar \$ ${NumberFormat('#,##0', 'en_US').format(amount ?? 0)}',
                          style: TextStyle(
                              fontSize: size.width * 0.03,
                              color: const Color(0xFFcaf0f8)),
                        ),
                        onPressed: () async {
                          double tope = uvtData!.valorUvt! * totaluvt;
                          //print('TOPE DECLARAR => $tope');
                          //print('neto => $amount');

                          if (amount >= tope) {
                            if (dniController.text == '') {
                              const snackBar = SnackBar(
                                  content: Center(
                                      child: Text("Ingrese un DNI valido..")));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              setState(() {
                                order.clienteId = dniController.text;
                                //order.detallePremioFigura!.first.estadoPago = 1;
                              });

                              WinnerProvider winnerProvider =
                                  Provider.of<WinnerProvider>(context);
                              winnerProvider
                                  .findCustomer(dniController.text.toString());

                              if (winnerProvider.customer != null) {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateUserPage(
                                          doi: dniController.text),
                                    ));
                              } else {
                                const snackBar = SnackBar(
                                    content: Center(
                                        child:
                                            Text("Ingrese un DNI valido..")));
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(snackBar);
                              }
                            }
                          } else {
                            Provider.of<WinnerProvider>(context, listen: false)
                                .registerWinner(
                                    context,
                                    order,
                                    widget.datosuser?.promotorId.toString() ??
                                        '');
                          }
                        }),
                  ],
                ),
              ],
            )
          ],
        );
      },
    );
  }
}

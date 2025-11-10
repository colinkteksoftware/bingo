import 'package:bingo/core/data/models/pagosconvert.dart';
import 'package:bingo/providers/payment_provider.dart';
import 'package:bingo/ui/payment/winner_nofound.dart';
import 'package:bingo/ui/user/update_user_page.dart';
import 'package:bingo/utils/colores.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BuildWinnersList extends StatefulWidget {
  const BuildWinnersList({super.key});

  @override
  State<BuildWinnersList> createState() => _BuildWinnersListState();
}

class _BuildWinnersListState extends State<BuildWinnersList> {
  TextEditingController dniController = TextEditingController();
  /*double amount = 0;
  double totalValorPremio = 0;
  double totalPremioAdicional = 0;*/

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Consumer<PaymentProvider>(
      builder: (context, provider, child) {
        if (provider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (provider.listWinners.isEmpty) {
          return const WinnerNoFound();
        }

        return ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.listWinners.length,
          itemBuilder: (context, index) {
            final winner = provider.listWinners[index];
            final totals = calculeTotals(winner);
            final amount = totals['amount'] ?? 0.0;
            final totalValorPremio = totals['valor'] ?? 0.0;
            final totalPremioAdicional = totals['adicional'] ?? 0.0;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/venta.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ExpansionTile(
                  collapsedIconColor: Colors.white,
                  iconColor: Colors.white,
                  title: Text(
                    "MÓDULO: ${winner.codigoModulo ?? '-'}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Cartilla: ${winner.cartillaId}',
                    style: const TextStyle(color: Colors.white),
                  ),
                  children: [
                    if (winner.detallePremioFigura != null &&
                        winner.detallePremioFigura!.isNotEmpty)
                      if (winner.detallePremioFigura!.length > 1) ...[
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: winner.detallePremioFigura!.length,
                          itemBuilder: (context, i) {
                            final premio = winner.detallePremioFigura![i];
                            final valor = (premio.valorPremio ?? 0).toDouble();
                            final adicionales = premio.listaAdicionales
                                    ?.fold<double>(
                                        0.0,
                                        (sum, a) =>
                                            sum +
                                            ((a.premioAdicional ?? 0) as num)
                                                .toDouble()) ??
                                0.0;
                            final total = valor + adicionales;

                            return Card(
                              color: Colors.transparent,
                              elevation: 0,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 4, horizontal: 8),
                              child: ListTile(
                                leading: const Icon(
                                  Icons.workspace_premium_sharp,
                                  color: Color.fromARGB(255, 255, 214, 10),
                                  size: 45,
                                ),
                                title: Center(
                                  child: Text(
                                    premio.nombreFigura ?? "Sin figura",
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Premio: ${moneyFormatted(valor)}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontFamily: 'gotic',
                                      ),
                                    ),
                                    Text(
                                      'Premio adicional: ${moneyFormatted(adicionales)}',
                                      style: const TextStyle(
                                        color: Colors.white70,
                                        fontFamily: 'gotic',
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Premio total: ${moneyFormatted(total)}',
                                      style: const TextStyle(
                                        color: Colors.amber,
                                        fontFamily: 'gotic',
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  collectPrize(context, provider, winner, total,
                                      size, valor, adicionales);
                                },
                              ),
                            );
                          },
                        ),
                        const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Divider(
                            color: Colors.amber,
                            thickness: 1,
                          ),
                        ),
                        Builder(builder: (context) {
                          final totalGeneral = winner.detallePremioFigura!
                              .fold<double>(
                                  0.0,
                                  (sum, d) =>
                                      sum +
                                      ((d.valorPremio ?? 0) as num).toDouble() +
                                      (d.listaAdicionales?.fold<double>(
                                              0.0,
                                              (s, a) =>
                                                  s +
                                                  ((a.premioAdicional ?? 0)
                                                          as num)
                                                      .toDouble()) ??
                                          0.0));

                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 8.0, horizontal: 12.0),
                            child: Center(
                              child: Text(
                                'Total a pagar: ${moneyFormatted(totalGeneral)}',
                                style: const TextStyle(
                                  color: Colors.amber,
                                  fontFamily: 'gotic',
                                  fontSize: 17,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          );
                        }),
                      ]
                      else
                        // 👉 Si solo tiene un premio, muestra el total general
                        ListTile(
                          leading: const Icon(
                            Icons.workspace_premium_sharp,
                            color: Color.fromARGB(255, 210, 193, 3),
                            size: 50,
                          ),
                          title: Center(
                            child: Text(
                              winner.detallePremioFigura!.first.nombreFigura ??
                                  "Sin figura",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Text(
                                'Premio: ${moneyFormatted(totalValorPremio)}',
                                style: const TextStyle(
                                    color: Colors.white, fontFamily: 'gotic'),
                              ),
                              Text(
                                'Premio adicional: ${moneyFormatted(totalPremioAdicional)}',
                                style: const TextStyle(
                                    color: Colors.white, fontFamily: 'gotic'),
                              ),
                              Text(
                                'Premio total: ${moneyFormatted(amount)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'gotic',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            collectPrize(context, provider, winner, amount,
                                size, totalValorPremio, totalPremioAdicional);
                          },
                        )

                      /*if (winner.detallePremioFigura != null &&
                        winner.detallePremioFigura!.isNotEmpty)
                      // 👉 Si tiene más de un premio, muestra cada uno individual
                      if (winner.detallePremioFigura!.length > 1)
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: winner.detallePremioFigura!.length,
                          itemBuilder: (context, i) {
                            final premio = winner.detallePremioFigura![i];
                            final valor = (premio.valorPremio ?? 0).toDouble();
                            final adicionales = premio.listaAdicionales
                                    ?.fold<double>(
                                        0.0,
                                        (sum, a) =>
                                            sum +
                                            ((a.premioAdicional ?? 0) as num)
                                                .toDouble()) ??
                                0.0;
                            final total = valor + adicionales;

                            return ListTile(
                              leading: const Icon(
                                Icons.workspace_premium_sharp,
                                color: Color.fromARGB(255, 210, 193, 3),
                                size: 50,
                              ),
                              title: Center(
                                child: Text(
                                  premio.nombreFigura ?? "Sin figura",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              subtitle: Column(
                                children: [
                                  Text(
                                    'Premio: ${moneyFormatted(valor)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'gotic'),
                                  ),
                                  Text(
                                    'Premio adicional: ${moneyFormatted(adicionales)}',
                                    style: const TextStyle(
                                        color: Colors.white,
                                        fontFamily: 'gotic'),
                                  ),
                                  Text(
                                    'Premio total: ${moneyFormatted(total)}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'gotic',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              onTap: () {
                                collectPrize(context, provider, winner, total,
                                    size, valor, adicionales);
                              },
                            );
                          },
                        )
                      else
                        // 👉 Si solo tiene un premio, muestra el total general
                        ListTile(
                          leading: const Icon(
                            Icons.workspace_premium_sharp,
                            color: Color.fromARGB(255, 210, 193, 3),
                            size: 50,
                          ),
                          title: Center(
                            child: Text(
                              winner.detallePremioFigura!.first.nombreFigura ??
                                  "Sin figura",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          subtitle: Column(
                            children: [
                              Text(
                                'Premio: ${moneyFormatted(totalValorPremio)}',
                                style: const TextStyle(
                                    color: Colors.white, fontFamily: 'gotic'),
                              ),
                              Text(
                                'Premio adicional: ${moneyFormatted(totalPremioAdicional)}',
                                style: const TextStyle(
                                    color: Colors.white, fontFamily: 'gotic'),
                              ),
                              Text(
                                'Premio total: ${moneyFormatted(amount)}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: 'gotic',
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            collectPrize(context, provider, winner, amount,
                                size, totalValorPremio, totalPremioAdicional);
                          },
                        )*/
                      else
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Text('Sin premios registrados', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),),
                        ),
                  ],
                ),
              ),
            );
          },
        );

        /*ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.listWinners.length,
          itemBuilder: (context, index) {
            final winner = provider.listWinners[index];
            print('winner => ${winner.toJson()}');

            final totals = calculeTotals(winner);
            final amount = totals['amount'] ?? 0;
            final totalValorPremio = totals['valor'] ?? 0;
            final totalPremioAdicional = totals['adicional'] ?? 0;

            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 3,
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/venta.png"),
                    fit: BoxFit.cover,
                  ),
                ),
                child: ExpansionTile(
                  collapsedIconColor: Colors.white,
                  iconColor: Colors.white,
                  title: Text(
                    "MODULO: ${winner.codigoModulo ?? '-'}",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'Cartilla: ${winner.cartillaId}',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                  children: [
                    if (winner.detallePremioFigura != null &&
                        winner.detallePremioFigura!.isNotEmpty)
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: winner.detallePremioFigura!.length,
                        itemBuilder: (context, i) {
                          final premio = winner.detallePremioFigura![i];
                          return ListTile(
                            leading: const Icon(
                              Icons.workspace_premium_sharp,
                              color: Color.fromARGB(255, 210, 193, 3),
                              size: 50,
                            ),
                            title: Center(
                                child: Text(
                              premio.nombreFigura ?? "Sin figura",
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            )),
                            subtitle: Column(
                              children: [
                                Text(
                                  'Premio: ${moneyFormatted(amount)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'gotic',
                                  ),
                                ),
                                Text(
                                  'Premio adicional: ${moneyFormatted(totalPremioAdicional)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'gotic',
                                  ),
                                ),
                                Text(
                                  'Premio Total: ${moneyFormatted(amount)}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'gotic',
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            onTap: () {
                              collectPrize(context, provider, winner, amount,
                                  size, totalValorPremio, totalPremioAdicional);
                            },
                          );
                        },
                      )
                    else
                      const Padding(
                        padding: EdgeInsets.all(8.0),
                        child: Text("Sin premios registrados"),
                      ),
                  ],
                ),
              ),
            );
          },
        );*/
      },
    );
  }

  Map<String, double> calculeTotals(Pago winner) {
    double amount = 0;
    double totalValorPremio = 0;
    double totalPremioAdicional = 0;

    if (winner.detallePremioFigura != null &&
        winner.detallePremioFigura!.isNotEmpty) {
      if (winner.detallePremioFigura!.length == 1) {
        final detalle = winner.detallePremioFigura!.first;
        totalValorPremio = detalle.valorPremio ?? 0;

        if (detalle.listaAdicionales != null &&
            detalle.listaAdicionales!.isNotEmpty) {
          totalPremioAdicional = detalle.listaAdicionales!
              .map((adicional) => adicional.premioAdicional as double)
              .reduce((a, b) => a + b);
        }
      } else {
        for (var detalle in winner.detallePremioFigura ?? []) {
          final valor = (detalle.valorPremio ?? 0).toDouble();

          final adicionales = detalle.listaAdicionales?.fold<double>(
                  0.0,
                  (double sum, dynamic a) =>
                      sum + ((a.premioAdicional ?? 0) as num).toDouble()) ??
              0.0;

          if (detalle.isTipoGrupo == true) {
            totalValorPremio += valor + adicionales;
          } else {
            totalPremioAdicional += valor + adicionales;
          }
        }

        /*for (var detalle in winner.detallePremioFigura ?? []) {
          if (detalle.listaAdicionales != null &&
              detalle.listaAdicionales!.isNotEmpty) {
            totalPremioAdicional += detalle.listaAdicionales!
                .map((adicional) => adicional.premioAdicional as double)
                .reduce((a, b) => a + b);
          }

          if (detalle.valorPremio != null && detalle.isTipoGrupo == true) {
            totalValorPremio += detalle.valorPremio ?? 0;
          } else {
            totalPremioAdicional += detalle.valorPremio ?? 0;
          }
        }*/
      }
    }

    amount = totalValorPremio + totalPremioAdicional;

    return {
      'amount': amount,
      'valor': totalValorPremio,
      'adicional': totalPremioAdicional,
    };
  }

  /*void calculeTotals(Pago winner) {
    double amount = 0;
    double totalValorPremio = 0;
    double totalPremioAdicional = 0;

    if (winner.detallePremioFigura!.isNotEmpty &&
        winner.detallePremioFigura?.length == 1) {
      totalValorPremio = winner.detallePremioFigura!.first.valorPremio ?? 0;

      if (winner.detallePremioFigura!.first.listaAdicionales!.isNotEmpty) {
        totalPremioAdicional = winner
            .detallePremioFigura!.first.listaAdicionales!
            .map((adicional) => adicional.premioAdicional as double)
            .reduce((value, element) => value + element);
      }
    } else {
      if (winner.detallePremioFigura!.length > 1) {
        for (var detalle in winner.detallePremioFigura!) {
          if (detalle.listaAdicionales != null &&
              detalle.listaAdicionales!.isNotEmpty) {
            totalPremioAdicional += detalle.listaAdicionales!
                .map((adicional) => adicional.premioAdicional as double)
                .reduce((value, element) => value + element);
          }
        }

        for (var detalle in winner.detallePremioFigura!) {
          if (detalle.valorPremio != null && detalle.isTipoGrupo == true) {
            totalValorPremio +=
                detalle.valorPremio ?? 0; //+ totalPremioAdicional;
          } else {
            totalPremioAdicional += detalle.valorPremio ?? 0;
          }
        }
      }
    }
    amount = totalValorPremio + totalPremioAdicional;
    /*totalUvt = provider.uvt.valorUvt ??
        0.0 * double.parse(provider.uvt.cantidadUvt.toString());*/
  }*/

  Future<dynamic> collectPrize(
      BuildContext context,
      PaymentProvider provider,
      Pago order,
      double amount,
      Size size,
      double totalValorPremio,
      double totalPremioAdicional) {
    final provider = Provider.of<PaymentProvider>(context, listen: false);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFcaf0f8).withOpacity(1),
          title: Center(
            child: Text(
              'Desea registrar este pago del modulo: ${order.codigoModulo}',
              style: const TextStyle(color: primaryBlue),
            ),
          ),
          content: Text(
            "Valor Total: ${moneyFormatted(amount)}",
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
                    "Valor Premio: ${moneyFormatted(totalValorPremio)}",
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
                      "Valor premio: ${moneyFormatted(adicionales.premioAdicional ?? 0)}",
                      style: const TextStyle(
                        color: Color(0xFF0077b6),
                        fontSize: 14,
                        fontFamily: 'gotic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                Text(
                  "Valor total adicionales: ${moneyFormatted(totalPremioAdicional)}",
                  style: const TextStyle(
                    color: Color(0xFF0077b6),
                    fontSize: 14,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                amount >= provider.totalUvt
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
                          backgroundColor: primaryBlue,
                        ),
                        child: Text(
                          'Confirmar ${moneyFormatted(amount)}',
                          style: TextStyle(
                              fontSize: size.width * 0.03,
                              color: const Color(0xFFcaf0f8)),
                        ),
                        onPressed: () async {
                          if (amount >= provider.totalUvt) {
                            if (dniController.text == '') {
                              const snackBar = SnackBar(
                                  content: Center(
                                      child: Text("Ingrese un DNI valido..")));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              setState(() {
                                order.clienteId =
                                    int.parse(dniController.text.toString());
                                //order.detallePremioFigura!.first.estadoPago = 1;
                              });

                              provider
                                  .findCustomer(dniController.text.toString());

                              if (provider.customer.clienteId != null) {
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
                            final success =
                                await provider.registerWinner(context, order);
                            if (success) {
                              Navigator.of(context).pop();
                            }
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

import 'package:bingo/core/data/models/ventasconvert.dart';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/providers/sale_provider.dart';
import 'package:bingo/ui/sale/widgets/sale_edit.dart';
import 'package:bingo/ui/commons/confirm_dialog_widget.dart';
import 'package:bingo/utils/colores.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomSaleCard extends StatelessWidget {
  final Size size;
  final Venta order;
  final BuildContext context;

  const CustomSaleCard(
      {super.key,
      required this.size,
      required this.order,
      required this.context});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        print("Card presionado para orden: ${order.ventaId}");
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 4),
        child: Container(
          width: size.width * 0.94,
          height: size.height * 0.18,
          decoration: BoxDecoration(
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage("assets/images/venta.png"),
            ),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.ventaId}'.toUpperCase(),
                      style: const TextStyle(
                        fontFamily: 'InterTight',
                        color: Color(0xFFcaf0f8),
                        fontSize: 20,
                        fontWeight: FontWeight.w300,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: order.tipo == 1
                            ? Colors.grey
                            : order.tipo == 2
                                ? Colors.orange
                                : Colors.amber,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        order.tipo == 1
                            ? "Juego Normal"
                            : order.tipo == 2
                                ? "Juego Promocional"
                                : "Juego Progresivo *${order.multiplicado}",
                        style: TextStyle(
                          color: const Color(0xFF0077b6),
                          fontSize: size.width * 0.032,
                          fontFamily: 'gotic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Módulo: ${order.codigoModulo}',
                          style: const TextStyle(
                            fontFamily: 'InterTight',
                            color: Color(0xFFcaf0f8),
                            fontSize: 18,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Valor: \$${order.precioTotalCartilla?.toStringAsFixed(2) ?? '0.00'}',
                          style: const TextStyle(
                            fontFamily: 'InterTight',
                            color: Color(0xFFcaf0f8),
                            fontSize: 14,
                            fontWeight: FontWeight.w300,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        if (order.estado != 0) _buildEditButton(context),
                        const SizedBox(width: 8),
                        _buildDeleteButton(context),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  'Descripción: ${order.ventaId}',
                  style: const TextStyle(
                    fontFamily: 'Inter',
                    color: Color(0xFFcaf0f8),
                    fontWeight: FontWeight.w200,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditButton(BuildContext ctx) {
    final provider = Provider.of<BingoProvider>(context, listen: false);
    final providerSale = Provider.of<SaleProvider>(context, listen: false);
    return GestureDetector(
      onTap: () async {
        var size = MediaQuery.of(context).size;
        if (provider.bingo.estado == 3) {
          showAlerta(context, 'Mensaje Informativo',
              'El bingo ya se ha encuentra finalizado.');
        } else {
          await showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                backgroundColor: const Color(0xFFcaf0f8).withOpacity(1),
                title: const Text(
                  'Desea editar este registro?',
                  style: TextStyle(color: primaryBlue),
                ),
                content: const Text('confirmar edición.'),
                actions: <Widget>[
                  Column(
                    children: [
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
                              'Confirmar',
                              style: TextStyle(
                                  fontSize: size.width * 0.03,
                                  color: const Color(0xFFcaf0f8)),
                            ),
                            onPressed: () async {
                              Navigator.of(context).pop();
                              await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return SaleEditWidget(order: order);
                                },
                              );
                              providerSale.fetchSales();
                            },
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              );
            },
          );
        }
      },
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          border: Border.all(
            color: const Color(0xFFcaf0f8),
            width: 2.0,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: const Row(
          children: [
            Icon(
              Icons.edit,
              size: 22,
              color: Color(0xFFcaf0f8),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeleteButton(BuildContext ctx) {
    final providerSale = Provider.of<SaleProvider>(context, listen: false);
    return InkWell(
      onTap: () {
        showConfirmationDialog(
          context: context,
          onConfirm: () async {
            await providerSale.deleteSale(context, order.ventaId.toString());
          },
        );
      },
      splashColor: Colors.red.withAlpha(30),
      highlightColor: Colors.red.withAlpha(50),
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(
            color: Colors.red,
            width: 2.0,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: const Icon(
          Icons.delete,
          size: 22,
          color: Colors.red,
        ),
      ),
    );    
  }
}

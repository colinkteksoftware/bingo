import 'package:bingo/core/data/models/booklet.dart';
import 'package:bingo/core/data/models/pagosconvert.dart';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/providers/sale_provider.dart';
import 'package:bingo/ui/bingo/widgets/booklet_nofound.dart';
import 'package:bingo/ui/sale/widgets/game_type.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/colores.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:provider/provider.dart';
import '../../../core/data/models/ventasconvert.dart';

class SaleEditWidget extends StatefulWidget {
  Venta order;

  SaleEditWidget({super.key, required this.order});

  @override
  State<SaleEditWidget> createState() => _SaleEditWidgetState();
}

class _SaleEditWidgetState extends State<SaleEditWidget> {
  final TextEditingController _controller = TextEditingController(text: "0");
  final pf = Preferencias();

  @override
  void initState() {
    _controller.text = widget.order.multiplicado.toString();
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<SaleProvider>(context, listen: false);
      provider.getBooklets(context, widget.order.ventaId ?? 0);
      //print('venta a modificar => ${widget.order.toMap()}');
    });
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final providerSale = context.watch<SaleProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFe7e8e9),
      body: SingleChildScrollView(
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
                constraints: const BoxConstraints(maxWidth: 550),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Align(
                  alignment: const AlignmentDirectional(0, 0),
                  child: Padding(
                    padding: const EdgeInsets.all(15),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            IconButton(
                              icon: Icon(Icons.arrow_back,
                                  color: primaryBlue, size: size.width * 0.08),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ],
                        ),
                        Padding(
                          padding:
                              const EdgeInsetsDirectional.fromSTEB(0, 5, 0, 0),
                          child: Center(
                            child: Container(
                              height: 100,
                              width: 300,
                              decoration: const BoxDecoration(
                                image: DecorationImage(
                                  image: AssetImage("assets/images/logo.png"),
                                  fit: BoxFit.fill,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Consumer<SaleProvider>(
                          builder: (context, provider, child) {
                            if (provider.isLoading) {
                              return const Center(
                                child: CircularProgressIndicator(
                                  color: primaryBlue,
                                ),
                              );
                            }

                            if (provider.listBooklet.isEmpty) {
                              return const BookletNoFound();
                            }

                            return Column(
                              children: [
                                moduleWidget(
                                    widget.order.codigoModulo.toString()),
                                itemBookletWidget(size, provider),
                              ],
                            );
                          },
                        ),
                        const GameTypeWidget(),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            AnimatedButton(
                              color: primaryBlue,
                              height: size.height * 0.05,
                              width: size.width * 0.4,
                              duration: 2,
                              onPressed: () async {
                                if ((providerSale.preciofinal == 0) &&
                                    providerSale.type != 1) {
                                  showAlerta(context, 'Mensaje Informativo',
                                      'Para ventas debes seleccionar una cartilla!!');
                                } else {
                                  if (providerSale.counter > 1) {
                                    openAlertBox(
                                        context, providerSale, widget.order);
                                  } else {
                                    final bingoProvider =
                                        Provider.of<BingoProvider>(context,
                                            listen: false);

                                    final pago = Pago()
                                      ..ventaId = widget.order.ventaId
                                      ..bingoId = bingoProvider.bingo.bingoId
                                      ..clienteId = 0
                                      ..promotorId = pf.getPromotorId
                                      ..codigoModulo =
                                          widget.order.codigoModulo.toString()
                                      ..multiplicado = providerSale.type == 2
                                          ? providerSale.counter
                                          : 0
                                      ..tipo = providerSale.type + 1;

                                    final success = await providerSale.postSale(
                                        pago, context);
                                    if (success) {
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    }
                                  }
                                }
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                ),
                                child: Center(
                                  child: Text(
                                    "Valor Venta: ${convertirdinerosindecimales(providerSale.preciofinal)}",
                                    style: TextStyle(
                                      color: const Color(0xFFcaf0f8),
                                      fontSize: size.width * 0.034,
                                      fontFamily: 'gotic',
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox itemBookletWidget(Size size, SaleProvider provider) {
    return SizedBox(
      height: size.height * 0.50,
      child: ListView.builder(
        itemCount: provider.listBooklet.length,
        itemBuilder: (context, index) {
          final booklet = provider.listBooklet[index];
          return bookletWidget(booklet);
        },
      ),
    );
  }

  Widget moduleWidget(String codigo) {
    final size = MediaQuery.of(context).size;
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.all(10),
      width: size.width,
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage("assets/images/fongo.png"), fit: BoxFit.fill),
        border: Border.all(color: const Color(0xFF1b6b93), width: 1.0),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('MODULO $codigo',
              style: TextStyle(
                fontSize: size.width * 0.05,
                color: Colors.white,
                fontFamily: 'gotic',
                fontWeight: FontWeight.bold,
              )),
        ],
      ),
    );
  }

  Widget bookletWidget(Booklet cartilla) {
    final size = MediaQuery.of(context).size;
    final provider = Provider.of<SaleProvider>(context, listen: false);
    return Container(
      margin: const EdgeInsets.only(bottom: 2),
      padding: const EdgeInsets.only(left: 10),
      width: size.width,
      decoration: BoxDecoration(
        image: const DecorationImage(
            image: AssetImage("assets/images/fongo.png"), fit: BoxFit.fill),
        border: Border.all(color: const Color(0xFF1b6b93), width: 1.0),
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(20),
          bottomLeft: Radius.circular(20),
          topLeft: Radius.circular(20),
          bottomRight: Radius.circular(20),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(
            cartilla.quantity == 1
                ? "Cartilla: ${cartilla.cartillaId}${" - SI".toUpperCase()}"
                : "Cartilla: ${cartilla.cartillaId}${" - NO".toUpperCase()}",
            style: TextStyle(
              fontSize: size.width * 0.05,
              color: Colors.white,
              fontFamily: 'gotic',
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(
            width: size.width * 0.34,
            child: Center(
              child: SwitchListTile(
                controlAffinity: ListTileControlAffinity.platform,
                activeThumbColor: const Color(0xffffb703),
                title: const SizedBox(),
                value: cartilla.quantity == 1,
                onChanged: (value) {
                  setState(() {
                    cartilla.quantity = value ? 1 : 0;
                    cartilla.estado = value;
                  });
                  provider.updateEstado(cartilla.cartillaId.toString(), value);
                  provider.calculeTotal();
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> openAlertBox(
    BuildContext context,
    SaleProvider providerSale,
    Venta order,
  ) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return PopScope(
          canPop: false,
          child: AlertDialog(
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0)),
            ),
            contentPadding: const EdgeInsets.all(16.0),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'Mensaje de Sistema',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
                const Divider(color: Colors.grey),
                const SizedBox(height: 16),
                Column(
                  children: [
                    const Text(
                      '¿Está seguro de agregar este progresivo?',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.black,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'X${providerSale.counter}',
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    )
                  ],
                ),
                const SizedBox(height: 15),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.red, width: 1.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                      ),
                      onPressed: () => Navigator.of(context).pop(),
                      child: const Text(
                        'No',
                        style: TextStyle(
                          color: Colors.red,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 12),
                        elevation: 2,
                      ),
                      onPressed: () async {
                        final bingoProvider =
                            Provider.of<BingoProvider>(context, listen: false);

                        final pago = Pago()
                          ..ventaId = order.ventaId
                          ..bingoId = bingoProvider.bingo.bingoId
                          ..clienteId = 0
                          ..promotorId = pf.getPromotorId
                          ..codigoModulo = order.codigoModulo.toString()
                          ..multiplicado =
                              providerSale.type == 2 ? providerSale.counter : 0
                          ..tipo = providerSale.type + 1;

                        final success =
                            await providerSale.postSale(pago, context);
                        if (success) {
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      },
                      child: const Text(
                        'Sí',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

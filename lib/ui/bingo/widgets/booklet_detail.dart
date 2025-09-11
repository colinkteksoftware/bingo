import 'package:bingo/core/data/models/booklet.dart';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/ui/bingo/widgets/booklet_nofound.dart';
import 'package:bingo/utils/colores.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:provider/provider.dart';

class BookletDetailPage extends StatefulWidget {
  const BookletDetailPage({super.key});

  @override
  State<BookletDetailPage> createState() => _BookletDetailPageState();
}

class _BookletDetailPageState extends State<BookletDetailPage> {
  final TextEditingController _controller = TextEditingController(text: "0");

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final provider = Provider.of<BingoProvider>(context, listen: false);
      if ((provider.bingo.bingoId ?? 0) != 0 && provider.qrcode.isNotEmpty) {
        await provider.fetchShowscartilla(context);
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final provider = context.watch<BingoProvider>();
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              decoration:
                  BoxDecoration(borderRadius: BorderRadius.circular(15)),
              child: Column(
                children: [
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        height: size.height * 0.40,
                        child: Column(
                          children: [
                            Consumer<BingoProvider>(
                              builder: (context, provider, child) {
                                if (provider.isLoading) {
                                  return const Center(
                                    child: Padding(
                                      padding: EdgeInsets.all(16),
                                      child: CircularProgressIndicator(
                                          color: primaryBlue),
                                    ),
                                  );
                                } else if (provider.infoBooklet.isEmpty) {
                                  return const BookletNoFound();
                                } else {
                                  return Column(
                                    children: [
                                      moduleWidget(provider.qrcode),
                                      itemBookletWidget(size, provider),
                                    ],
                                  );
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            GameTypeWidget(provider, size),
            Padding(
              padding: const EdgeInsets.only(top: 4),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedButton(
                    color: primaryBlue,
                    height: size.height * 0.05,
                    width: size.width * 0.4,
                    duration: 2,
                    onPressed: () async {
                      //print('info status bingo => ${provider.bingo}');
                      if (provider.bingo.estado == 3) {
                        showAlerta(context, 'Mensaje Informativo',
                            'El bingo ya se ha finalizado');
                      } else {
                        if ((provider.preciofinal == 0) &&
                            provider.aditional != 1) {
                          showAlerta(context, 'Mensaje Informativo',
                              'Para ventas debes seleccionar una cartilla.');
                        } else {
                          await provider.registerSale(context);
                        }
                      }
                    },
                    child: Center(
                      child: Text(
                        "Valor venta: ${moneyFormatted(double.parse(provider.preciofinal.toString()))}",
                        style: TextStyle(
                          color: const Color(0xFFcaf0f8),
                          fontSize: size.width * 0.034,
                          fontFamily: 'gotic',
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Center GameTypeWidget(BingoProvider provider, Size size) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: () {
              provider.updateaditional(0);
              provider.calculeTotal();
            },
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: provider.aditional == 0 ? primaryBlue : Colors.black,
                    width: 2,
                  ),
                  color: provider.aditional == 0
                      ? primaryBlue
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.all(12),
                child: provider.aditional == 0
                    ? const Icon(Icons.check, color: Color(0xFFcaf0f8))
                    : const SizedBox(),
              ),
              Center(
                child: Text(
                  "Normal",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.030,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
          ),
          const SizedBox(width: 3.5),
          GestureDetector(
            onTap: () {
              provider.updateaditional(1);
              provider.calculeTotal();
            },
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: provider.aditional == 1 ? primaryBlue : Colors.black,
                    width: 2,
                  ),
                  color: provider.aditional == 1
                      ? primaryBlue
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.all(12),
                child: provider.aditional == 1
                    ? const Icon(Icons.check, color: Color(0xFFcaf0f8))
                    : const SizedBox(),
              ),
              Center(
                child: Text(
                  "Promocional",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.030,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
          ),
          const SizedBox(width: 3.5),
          GestureDetector(
            onTap: () {
              provider.updateaditional(2);
              provider.calculeTotal();
              setState(() {
                _controller.text = provider.counter.toString();
              });
            },
            child: Column(children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: provider.aditional == 2 ? primaryBlue : Colors.black,
                    width: 2,
                  ),
                  color: provider.aditional == 2
                      ? primaryBlue
                      : Colors.transparent,
                ),
                padding: const EdgeInsets.all(12),
                child: provider.aditional == 2
                    ? const Icon(Icons.check, color: Color(0xFFcaf0f8))
                    : const SizedBox(),
              ),
              Center(
                child: Text(
                  "Progresivo",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: size.width * 0.030,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              )
            ]),
          ),
          provider.aditional == 2
              ? Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.remove, color: Colors.amber),
                      onPressed: () {
                        provider.decrement();
                        setState(() {
                          _controller.text = provider.counter.toString();
                        });
                      },
                    ),
                    SizedBox(
                      width: size.width * 0.14,
                      child: TextFormField(
                        controller: _controller,
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: size.width * 0.034,
                          fontFamily: 'gotic',
                          fontWeight: FontWeight.bold,
                        ),
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintStyle: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * 0.034,
                            fontFamily: 'gotic',
                            fontWeight: FontWeight.bold,
                          ),
                          labelStyle: TextStyle(
                            color: Colors.black,
                            fontSize: size.width * 0.020,
                            fontFamily: 'gotic',
                            fontWeight: FontWeight.bold,
                          ),
                          labelText: 'Cantidad',
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            final newValue = int.tryParse(value);
                            if (newValue != null && newValue >= 0) {
                              provider.updateCounter(newValue);
                              _controller.text = provider.counter.toString();
                            } else {
                              _controller.text = provider.counter.toString();
                            }
                          }
                        },
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.add, color: Colors.amber),
                      onPressed: () {
                        provider.increment();
                        setState(() {
                          _controller.text = provider.counter.toString();
                        });
                      },
                    ),
                  ],
                )
              : const SizedBox.shrink(),
        ],
      ),
    );
  }

  SizedBox itemBookletWidget(Size size, BingoProvider provider) {
    return SizedBox(
      height: size.height * 0.32,
      child: ListView.builder(
        itemCount: provider.infoBooklet.length,
        itemBuilder: (context, index) {
          final infoBooklet = provider.infoBooklet[index];
          return bookletWidget(infoBooklet);
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
    final provider = Provider.of<BingoProvider>(context, listen: false);
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
                activeColor: const Color(0xffffb703),
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
}

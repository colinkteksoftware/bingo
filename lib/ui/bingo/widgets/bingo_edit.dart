import 'dart:convert';
import 'dart:io';
import 'package:bingo/models/modelCliente.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:bingo/models/cartillaconvert.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:http/io_client.dart';
import '../../../models/bingoconvert.dart';
import '../../../models/ventasconvert.dart';

class EditBingo extends StatefulWidget {
  ModelCliente? datosuser;
  Bingo? bingo;
  Venta venta;

  EditBingo(
      {super.key,
      required this.bingo,
      required this.datosuser,
      required this.venta});

  @override
  State<EditBingo> createState() => _EditBingoState();
}

class _EditBingoState extends State<EditBingo> {
  final DateTime _selectedDate = DateTime.now();
  final pf = Preferencias();

  Future<List<Venta>?>? listaset;
  List<Venta>? listasetresponseList;
  final ioc = HttpClient();
  Future<List<Venta>?> fetchShows() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    String _fecha =
        "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";

    final url = Uri.parse(
        "${pf.getIp.text}/api/PromotorInterno/GetMisVentasByPromotor?PromotorId=${widget.datosuser!.promotorId}&FechaCompra=$_fecha");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseList =
            ventaFromMap(utf8.decode(response.bodyBytes));
      });
      await fetchShowscartilla();
      setState(() {});
      return listasetresponseList;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  Future<Cartilla?>? listasetcartilla;
  Cartilla? listasetresponseListcartilla;
  Future<Cartilla?> fetchShowscartilla() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    final url = Uri.parse(
        "${pf.getIp.toString()}/api/GrupoCartillaDetalle/GetItemNameGrupoTodos/${widget.venta.codigoModulo!}");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListcartilla = cartillaFromJson(utf8.decode(response.bodyBytes));

        var jsonData =
            jsonDecode(listasetresponseListcartilla!.grupoCartillas!);

        _reponse.clear();
        _reponsevalores.clear();
        for (var numero in jsonData) {
          String valor = numero.toString();
          _reponse.add(TextEditingController(text: valor));
          _reponsevalores.add(TextEditingController(text: "1"));

          double finalito = 0.0;
          _preciofinal.text = "0";
          for (var cantidadunique in _reponsevalores) {
            if (cantidadunique.text == "1" && _selectedIndex == 0) {
              finalito = finalito + widget.bingo!.precioPorCartilla;
              _preciofinal.text = finalito.toStringAsFixed(2);
            }
            if (cantidadunique.text == "1" && _selectedIndex == 2) {
              double contador = 0;

              contador = double.parse(_controller.text) + 1;

              finalito =
                  finalito + (widget.bingo!.precioPorCartilla * contador);
              _preciofinal.text = finalito.toStringAsFixed(2);
            }
          }
        }
      });

      return listasetresponseListcartilla;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
    //await pf.initPrefs();
    _controller.text = widget.venta.multiplicado.toString();
    valores();
    listaset = fetchShows();
    listasetcartilla = fetchShowscartilla();    
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  void valores() async {
    setState(() {
      _value = widget.venta.multiplicado!;
      _selectedIndex = widget.venta.tipo! - 1;
    });
  }

  void _increment() {
    setState(() {
      _value++;
      _controller.text = _value.toString();
    });
    double finalito = 0.0;
    _preciofinal.text = "0";
    for (var cantidadunique in _reponsevalores) {
      if (cantidadunique.text == "1" && _selectedIndex == 0) {
        finalito = finalito + widget.bingo!.precioPorCartilla;
        _preciofinal.text = finalito.toStringAsFixed(2);
      }
      if (cantidadunique.text == "1" && _selectedIndex == 2) {
        double contador = 0;

        contador = double.parse(_controller.text) + 1;

        finalito =
            finalito + (widget.bingo!.precioPorCartilla * contador);
        _preciofinal.text = finalito.toStringAsFixed(2);
      }
    }
  }

  void _decrement() {
    if (_value > 0) {
      setState(() {
        _value--;
        _controller.text = _value.toString();
      });
    }
    double finalito = 0.0;
    _preciofinal.text = "0";
    for (var cantidadunique in _reponsevalores) {
      if (cantidadunique.text == "1" && _selectedIndex == 0) {
        finalito = finalito + widget.bingo!.precioPorCartilla;
        _preciofinal.text = finalito.toStringAsFixed(2);
      }
      if (cantidadunique.text == "1" && _selectedIndex == 2) {
        double contador = 0;

        contador = double.parse(_controller.text) + 1;

        finalito =
            finalito + (widget.bingo!.precioPorCartilla * contador);
        _preciofinal.text = finalito.toStringAsFixed(2);
      }
    }
  }

  final TextEditingController _controller = TextEditingController(text: "0");
  final TextEditingController _preciofinal = TextEditingController();
  final List<TextEditingController> _reponse = [];
  final List<TextEditingController> _reponsevalores = [];

  int _value = 0;
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: const Color(0xFFe7e8e9),
        body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Stack(children: [
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
                      constraints: const BoxConstraints(maxWidth: 570),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                          alignment: const AlignmentDirectional(0, 0),
                          child: Padding(
                              padding: const EdgeInsets.all(32),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.arrow_back,
                                              color: const Color(0xFF03045e),
                                              size: size.width * 0.08),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              0, 20, 0, 0),
                                      child: Container(
                                        height: size.height * 0.1,
                                        decoration: const BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/logo.png"),
                                              fit: BoxFit.fill),
                                        ),
                                        alignment:
                                            const AlignmentDirectional(0, 0),
                                      ),
                                    ),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 0,
                                            bottom: 10),
                                        child: Container(
                                            width: size.width * 0.9,
                                            height: size.height * 0.44,
                                            color: Colors.transparent,
                                            child: Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 7,
                                                    right: 7,
                                                    top: 0,
                                                    bottom: 0),
                                                child: Column(
                                                  children: [
                                                    Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .spaceAround,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          Container(
                                                              height:
                                                                  size.height *
                                                                      0.40,
                                                              width:
                                                                  size.width *
                                                                      0.9,
                                                              color: Colors
                                                                  .transparent,
                                                              child: Column(
                                                                children: [
                                                                  _reponse == null ||
                                                                          _reponse
                                                                              .isEmpty
                                                                      ? Container()
                                                                      : Column(
                                                                          children: [
                                                                            SizedBox(
                                                                                height: size.height * 0.4,
                                                                                child: ListView.builder(
                                                                                    scrollDirection: Axis.vertical,
                                                                                    itemCount: _reponse.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      return check(_reponse[index], _reponse[index].text, _reponsevalores[index], _reponsevalores);
                                                                                    }))
                                                                          ],
                                                                        )
                                                                ],
                                                              )),
                                                        ]),
                                                  ],
                                                )))),
                                    Center(
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          // Primer "Radio Button"
                                          GestureDetector(
                                            onTap: () {
                                              setState(() {
                                                _selectedIndex =
                                                    0; // Establecer el índice como 0
                                              });
                                              double finalito = 0.0;
                                              _preciofinal.text = "0";
                                              for (var cantidadunique
                                                  in _reponsevalores) {
                                                if (cantidadunique.text ==
                                                        "1" &&
                                                    _selectedIndex == 0) {
                                                  finalito = finalito +
                                                      widget.bingo!
                                                          .precioPorCartilla;
                                                  _preciofinal.text = finalito
                                                      .toStringAsFixed(2);
                                                }
                                                if (cantidadunique.text ==
                                                        "1" &&
                                                    _selectedIndex == 2) {
                                                  double contador = 0;

                                                  contador = double.parse(
                                                          _controller.text) +
                                                      1;

                                                  finalito = finalito +
                                                      (widget.bingo!
                                                              .precioPorCartilla *
                                                          contador);
                                                  _preciofinal.text = finalito
                                                      .toStringAsFixed(2);
                                                }
                                              }
                                            },
                                            child: Column(children: [
                                              Container(
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  border: Border.all(
                                                    color: _selectedIndex == 0
                                                        ? const Color(
                                                            0xFF03045e)
                                                        : Colors.black,
                                                    width: 2,
                                                  ),
                                                  color: _selectedIndex == 0
                                                      ? const Color(0xFF03045e)
                                                      : Colors.transparent,
                                                ),
                                                padding:
                                                    const EdgeInsets.all(12),
                                                child: _selectedIndex == 0
                                                    ? const Icon(Icons.check,
                                                        color:
                                                            Color(0xFFcaf0f8))
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
                                              ))
                                            ]),
                                          ),
                                          const SizedBox(width: 3.5),
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedIndex =
                                                      1; // Establecer el índice como 1
                                                });
                                                double finalito = 0.0;
                                                _preciofinal.text = "0";
                                                for (var cantidadunique
                                                    in _reponsevalores) {
                                                  if (cantidadunique.text ==
                                                          "1" &&
                                                      _selectedIndex == 0) {
                                                    finalito = finalito +
                                                        widget.bingo!
                                                            .precioPorCartilla;
                                                    _preciofinal.text = finalito
                                                        .toStringAsFixed(2);
                                                  }
                                                  if (cantidadunique.text ==
                                                          "1" &&
                                                      _selectedIndex == 2) {
                                                    double contador = 0;

                                                    contador = double.parse(
                                                            _controller.text) +
                                                        1;

                                                    finalito = finalito +
                                                        (widget.bingo!
                                                                .precioPorCartilla *
                                                            contador);
                                                    _preciofinal.text = finalito
                                                        .toStringAsFixed(2);
                                                  }
                                                }
                                              },
                                              child: Column(children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: _selectedIndex == 1
                                                          ? const Color(
                                                              0xFF03045e)
                                                          : Colors.black,
                                                      width: 2,
                                                    ),
                                                    color: _selectedIndex == 1
                                                        ? const Color(
                                                            0xFF03045e)
                                                        : Colors.transparent,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: _selectedIndex == 1
                                                      ? const Icon(Icons.check,
                                                          color:
                                                              Color(0xFFcaf0f8))
                                                      : const SizedBox(),
                                                ),
                                                Center(
                                                    child: Text(
                                                  "Promocional",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        size.width * 0.030,
                                                    fontFamily: 'gotic',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ))
                                              ])),
                                          const SizedBox(width: 3.5),
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedIndex = 2;
                                                });
                                                double finalito = 0.0;
                                                _preciofinal.text = "0";
                                                for (var cantidadunique
                                                    in _reponsevalores) {
                                                  if (cantidadunique.text ==
                                                          "1" &&
                                                      _selectedIndex == 0) {
                                                    finalito = finalito +
                                                        widget.bingo!
                                                            .precioPorCartilla;
                                                    _preciofinal.text = finalito
                                                        .toStringAsFixed(2);
                                                  }
                                                  if (cantidadunique.text ==
                                                          "1" &&
                                                      _selectedIndex == 2) {
                                                    double contador = 0;

                                                    contador = double.parse(
                                                            _controller.text) +
                                                        1;

                                                    finalito = finalito +
                                                        (widget.bingo!
                                                                .precioPorCartilla *
                                                            contador);
                                                    _preciofinal.text = finalito
                                                        .toStringAsFixed(2);
                                                  }
                                                }
                                              },
                                              child: Column(children: [
                                                Container(
                                                  decoration: BoxDecoration(
                                                    shape: BoxShape.circle,
                                                    border: Border.all(
                                                      color: _selectedIndex == 2
                                                          ? const Color(
                                                              0xFF03045e)
                                                          : Colors.black,
                                                      width: 2,
                                                    ),
                                                    color: _selectedIndex == 2
                                                        ? const Color(
                                                            0xFF03045e)
                                                        : Colors.transparent,
                                                  ),
                                                  padding:
                                                      const EdgeInsets.all(12),
                                                  child: _selectedIndex == 2
                                                      ? const Icon(Icons.check,
                                                          color: const Color(
                                                              0xFFcaf0f8))
                                                      : const SizedBox(),
                                                ),
                                                Center(
                                                    child: Text(
                                                  "Progresivo",
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        size.width * 0.030,
                                                    fontFamily: 'gotic',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ))
                                              ])),
                                          _selectedIndex == 2
                                              ? Row(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.remove,
                                                          color: Colors.amber),
                                                      onPressed: _decrement,
                                                    ),
                                                    SizedBox(
                                                      width: size.width * 0.14,
                                                      child: TextFormField(
                                                        controller: _controller,
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: size.width *
                                                              0.034,
                                                          fontFamily: 'gotic',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        keyboardType:
                                                            TextInputType
                                                                .number,
                                                        decoration:
                                                            InputDecoration(
                                                          hintStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                size.width *
                                                                    0.034,
                                                            fontFamily: 'gotic',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          labelStyle: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                size.width *
                                                                    0.020,
                                                            fontFamily: 'gotic',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          labelText: 'Cantidad',
                                                          border:
                                                              const OutlineInputBorder(),
                                                        ),
                                                        onChanged: (value) {
                                                          if (value
                                                              .isNotEmpty) {
                                                            int? newValue =
                                                                int.tryParse(
                                                                    value);
                                                            if (newValue !=
                                                                    null &&
                                                                newValue >= 0) {
                                                              setState(() {
                                                                _value =
                                                                    newValue;
                                                              });
                                                            } else {
                                                              _controller.text =
                                                                  _value
                                                                      .toString();
                                                            }
                                                          }

                                                          double finalito = 0.0;
                                                          _preciofinal.text =
                                                              "0";
                                                          for (var cantidadunique
                                                              in _reponsevalores) {
                                                            if (cantidadunique
                                                                        .text ==
                                                                    "1" &&
                                                                _selectedIndex ==
                                                                    0) {
                                                              finalito = finalito +
                                                                  widget
                                                                      .bingo!                                                                      
                                                                      .precioPorCartilla;
                                                              _preciofinal
                                                                      .text =
                                                                  finalito
                                                                      .toStringAsFixed(
                                                                          2);
                                                            }
                                                            if (cantidadunique
                                                                        .text ==
                                                                    "1" &&
                                                                _selectedIndex ==
                                                                    2) {
                                                              double contador =
                                                                  0;

                                                              contador = double.parse(
                                                                      _controller
                                                                          .text) +
                                                                  1;

                                                              finalito = finalito +
                                                                  (widget
                                                                          .bingo!
                                                                          .precioPorCartilla *
                                                                      contador);
                                                              _preciofinal
                                                                      .text =
                                                                  finalito
                                                                      .toStringAsFixed(
                                                                          2);
                                                            }
                                                          }
                                                        },
                                                      ),
                                                    ),
                                                    IconButton(
                                                      icon: const Icon(
                                                          Icons.add,
                                                          color: Colors.amber),
                                                      onPressed: _increment,
                                                    ),
                                                  ],
                                                )
                                              : Container(),
                                        ],
                                      ),
                                    ),
                                    SizedBox(
                                      height: size.height * 0.01,
                                    ),
                                    Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AnimatedButton(
                                              color: const Color(0xFF03045e),
                                              height: size.height * 0.05,
                                              width: size.width * 0.4,
                                              duration: 2,
                                              onPressed: () async {
                                                if (_selectedIndex == 0 ||
                                                    _selectedIndex == 2 ||
                                                    _selectedIndex == 1) {
                                                  if ((_preciofinal.text ==
                                                              "0" ||
                                                          _preciofinal.text ==
                                                              "") &&
                                                      _selectedIndex != 1) {
                                                    showAlerta(
                                                        context,
                                                        'Mensaje Informativo',
                                                        'Para ventas debes seleccionar una cartilla!!');
                                                  } else {
                                                    List<Map<String, int>>
                                                        body = [];
                                                    for (int index = 0;
                                                        index <
                                                            _reponsevalores
                                                                .length;
                                                        index++) {
                                                      var cantidadunique =
                                                          _reponsevalores[index]
                                                              .text;
                                                      var cantidaduniquecartilla =
                                                          _reponse[index].text;
                                                      if (cantidadunique ==
                                                          "1") {
                                                        print(
                                                            "Índice: $index, Valor: $cantidadunique");
                                                        print(
                                                            "Índice cartilla: $index, Valor: $cantidaduniquecartilla");
                                                        body.add({
                                                          "cartillaId": int.parse(
                                                              cantidaduniquecartilla)
                                                        });
                                                      }
                                                    }

                                                    await fetchShowsupdate(
                                                        body, context);
                                                    listaset = fetchShows();
                                                  }
                                                }
                                                setState(() {});
                                              },
                                              child: Container(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0,
                                                          left: 0,
                                                          right: 0,
                                                          bottom: 0),
                                                  child: Center(
                                                      child: Text(
                                                    "Valor Venta: ${_preciofinal.text}",
                                                    style: TextStyle(
                                                      color: const Color(
                                                          0xFFcaf0f8),
                                                      fontSize:
                                                          size.width * 0.034,
                                                      fontFamily: 'gotic',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )))),
                                        ]),
                                  ])))))
            ])));
  }

  Future<String> fetchShowsupdate(
      List<Map<String, int>> elemento, BuildContext context) async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
//List<Map<String, int>> body = listaEnteros
//     .take(cantidadMaxima) // Limitar a los primeros N elementos
//     .map((numero) => {"cartillaId": numero})
//     .toList();
//
    print(jsonEncode({
      "ventaId": widget.venta.ventaId,
      "bingoId": widget.bingo!.bingoId,
      "clienteId": 0,
      "promotorId": widget.datosuser!.promotorId,
      "codigoModulo": widget.venta.codigoModulo,
      "multiplicado": _controller.text,
      "tipo": _selectedIndex + 1,
      "ventasDetalle": elemento
    }));

    final url =
        Uri.parse('${pf.getIp.toString()}/api/PromotorInterno/UpdateVentaManual');

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "ventaId": widget.venta.ventaId,
          "bingoId": widget.bingo!.bingoId,
          "clienteId": 0,
          "promotorId": widget.datosuser!.promotorId,
          "codigoModulo": widget.venta.codigoModulo,
          "multiplicado": _controller.text,
          "tipo": _selectedIndex + 1,
          "ventasDetalle": elemento
        }));

    if (response.statusCode == 200) {
      _controller.text = "0";
      const snackBar =
          SnackBar(content: Center(child: Text("Se ha confirmado la actualización..")), backgroundColor: Colors.green,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      return "si";
    } else {
      const snackBar =
          SnackBar(content: Center(child: Text("No se ha confirmado la actualización..")), backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //     Navigator.of(context).pop();
      throw Exception('Failed to load shows');
    }
  }

  Widget check(TextEditingController controller, String title,
      TextEditingController valores, List<TextEditingController> cantidad) {
    //Orientation deviceOrientation = MediaQuery.of(context).orientation;
    //bool isLandscape = (deviceOrientation == Orientation.landscape);
    var size = MediaQuery.of(context).size;
    return Container(
        padding: const EdgeInsets.only(left: 10),
        height: size.height * 0.064,
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
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                  valores.text == "1"
                      ? "Cartilla: ${controller.text}${"  - SI".toUpperCase()}"
                      : "Cartilla: ${controller.text}${"  - NO".toUpperCase()}",
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.white,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              child: Container(
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      bottomRight: Radius.circular(10),
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                    ),
                  ),
                  height: size.height,
                  width: size.width * 0.34,
                  child: SwitchListTile(
                    controlAffinity: ListTileControlAffinity.platform,
                    activeColor: const Color(0xffffb703),
                    title: Container(),
                    value: valores.text == "1" ? true : false,
                    onChanged: (value) async {
                      setState(() {
                        if (value) {
                          valores.text = "1";
                          value = false;
                        } else {
                          valores.text = "0";
                          value = true;
                        }
                      });
                  
                      double finalito = 0.0;
                      _preciofinal.text = "0";
                      for (var cantidadunique in cantidad) {
                        if (cantidadunique.text == "1" && _selectedIndex == 0) {
                          finalito =
                              finalito + widget.bingo!.precioPorCartilla;
                          _preciofinal.text = finalito.toStringAsFixed(2);
                        }
                        if (cantidadunique.text == "1" && _selectedIndex == 2) {
                          double contador = 0;
                  
                          contador = double.parse(_controller.text) + 1;
                  
                          finalito = finalito +
                              (widget.bingo!.precioPorCartilla *
                                  contador);
                          _preciofinal.text = finalito.toStringAsFixed(2);
                        }
                      }
                      // _modeld.status.text = value == true ? "1" : "0";
                    },
                  )),
            ),
          ],
        ));
  }
}
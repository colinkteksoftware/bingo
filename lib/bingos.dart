import 'dart:convert';
import 'dart:io';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bingo/ui/modificarusuario.dart';
import 'package:intl/intl.dart';

import 'package:bingo/models/modelCliente.dart';
import 'package:bingo/ui/background.dart';
import 'package:bingo/ui/modificarcliente.dart';
import 'package:bingo/utiles/conversiones.dart';
import 'package:bingo/utiles/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:http/io_client.dart';
import 'convert.dart' as listasetconvert;
import 'promotorconvert.dart' as listasetconvertpromotor;
import 'ventasconvert.dart' as listasetventasconvert;
import 'pagosconvert.dart' as listasetpagosconvert;
import 'clienteconvert.dart' as listasetclienteconvert;
import 'uvtconvert.dart' as listasetuvtconvert;
import 'cartillaconvert.dart' as listasetcartillaconvert;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:scroll_date_picker/scroll_date_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

final ipController = TextEditingController(text: "0.0.0.0");

class Bingos extends StatefulWidget {
  ModelCliente? datosuser;
  Bingos({super.key, required this.datosuser});

  @override
  State<Bingos> createState() => _BingosState();
}

class _BingosState extends State<Bingos> {
  @override
  void initState() {
    listaset = fetchShows();

    // Lógica para refrescar la vista según el índice
    // Puedes llamar a funciones de actualización o setState aquí

    // Ejemplo de refresco de la vista

    // Tu lógica de actualización aquí

    super.initState();
  }

  final pf = new Preferencias();
  iniciarPreferencias() async {
    await pf.initPrefs();
    ipController.text = pf.getIp;
    setState(() {});
  }

  Future<List<listasetconvert.Sala>?>? listaset;
  List<listasetconvert.Sala>? listasetresponseList;
  final ioc = new HttpClient();
  Future<List<listasetconvert.Sala>?> fetchShows() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);

    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    await iniciarPreferencias();
    final url = Uri.parse(ipController.text +
        "/api/BingoPremioDetalleInterno/GetAll?Estado=1&FechaInicio=" +
        formattedDate);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseList =
            listasetconvert.salaFromMap(utf8.decode(response.bodyBytes));
      });
      setState(() {});
      return listasetresponseList;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  DateTime _selectedDate = DateTime.now();

  TextEditingController _controllerestado = TextEditingController(text: "1");

  String searchString = "";
  String searchStringproduct = "";
  String detectionInfo = "";
  final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFcaf0f8), Color(0xFF00b4d8)],
          stops: [0.3, 0.9]));
  int _selectedIndex = 0; // Variable para rastrear el índice del seleccionado

  @override
  Widget build(BuildContext context) {
    DateTime maxDate = _selectedDate.add(Duration(days: 365));

    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: Color(0xFFcaf0f8),
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Stack(children: [
              Container(
                decoration: boxDecoration,
              ),
              Positioned(
                top: -130,
                left: -15,
                child: Column(
                  children: [
                    Box(),
                  ],
                ),
              ),
              Positioned(
                top: 340,
                left: 105,
                child: Column(
                  children: [
                    Box2(),
                  ],
                ),
              ),
              Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Container(
                      height: size.height,
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: 570,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                              padding: EdgeInsets.all(32),
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
                                              color: Color(0xFF03045e),
                                              size: size.width * 0.08),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 20, 0, 0),
                                      child: Container(
                                        height: size.height * 0.1,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/logo.png"),
                                              fit: BoxFit.fill),
                                        ),
                                        alignment: AlignmentDirectional(0, 0),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.all(2),
                                        child: Container(
                                          width: size.width * 0.62,
                                          padding: EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          height: size.height * 0.06,
                                          child: TextField(
                                            style: TextStyle(
                                              color: Color(0xFF424242),
                                              fontSize: size.width * 0.04,
                                            ),
                                            onChanged: (value) async {
                                              setState(() {
                                                detectionInfo = "";
                                              });

                                              setState(() {
                                                searchString =
                                                    value.toUpperCase();
                                              });
                                            },
                                            onSubmitted: (value) async {
                                              setState(() {
                                                detectionInfo = "";
                                              });

                                              setState(() {
                                                searchString =
                                                    value.toUpperCase();
                                              });
                                            },
                                            decoration: InputDecoration(
                                              floatingLabelStyle: TextStyle(
                                                color: Color(0xFF424242),
                                                fontSize: size.width *
                                                    0.04, // Ajusta el tamaño de la letra de la etiqueta flotante aquí
                                                fontWeight: FontWeight.bold,
                                              ),
                                              enabledBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors
                                                      .black, // Borde inferior de color negro
                                                  width:
                                                      2.0, // Ancho del borde inferior
                                                ),
                                              ),
                                              focusedBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Colors
                                                      .black, // Borde inferior de color negro al enfocar
                                                  width: 2.0,
                                                ),
                                              ),
                                              errorBorder: UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(
                                                      0xFF7CBF4F), // Borde inferior para el error
                                                  width: 2.0,
                                                ),
                                              ),
                                              focusedErrorBorder:
                                                  UnderlineInputBorder(
                                                borderSide: BorderSide(
                                                  color: Color(0xFF7CBF4F),
                                                  width: 2.0,
                                                ),
                                              ),
                                              labelText: detectionInfo.isEmpty
                                                  ? "Buscar"
                                                  : detectionInfo,
                                              labelStyle: TextStyle(
                                                color: Color(0xFF424242),
                                                fontSize: size.width * 0.04,
                                              ),
                                              isDense: true,
                                              filled: true,
                                              fillColor: Color(0xFFcaf0f8),
                                            ),
                                          ),
                                        )),
                                    Container(
                                      height: size.height * 0.09,
                                      child: ScrollDatePicker(
                                        options: DatePickerOptions(
                                            backgroundColor: Color(0xFFcaf0f8)),
                                        maximumDate: maxDate,
                                        selectedDate: _selectedDate,
                                        locale: Locale('es'),
                                        onDateTimeChanged:
                                            (DateTime value) async {
                                          setState(() {
                                            _selectedDate = value;
                                          });

                                          await fetchShows();
                                          listasetresponseList!.sort((a, b) {
                                            int diffA = (a.bingo.fecha.day -
                                                    _selectedDate.day)
                                                .abs();
                                            int diffB = (b.bingo.fecha.day -
                                                    _selectedDate.day)
                                                .abs();
                                            return diffA.compareTo(diffB);
                                          });
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Center(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                // Primer "Radio Button"
                                                GestureDetector(
                                                  onTap: () async {
                                                    await fetchShows();
                                                    setState(() {
                                                      _selectedIndex =
                                                          0; // Establecer el índice como 0
                                                    });
                                                  },
                                                  child: Column(children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: BoxShape.circle,
                                                        border: Border.all(
                                                          color:
                                                              _selectedIndex ==
                                                                      0
                                                                  ? Color(
                                                                      0xFF03045e)
                                                                  : Colors
                                                                      .black,
                                                          width: 2,
                                                        ),
                                                        color: _selectedIndex ==
                                                                0
                                                            ? Color(0xFF03045e)
                                                            : Colors
                                                                .transparent,
                                                      ),
                                                      padding:
                                                          EdgeInsets.all(12),
                                                      child: _selectedIndex == 0
                                                          ? Icon(Icons.check,
                                                              color: Color(
                                                                  0xFFcaf0f8))
                                                          : SizedBox(),
                                                    ),
                                                    Center(
                                                        child: Text(
                                                      "Inactivo",
                                                      style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize:
                                                            size.width * 0.030,
                                                        fontFamily: 'gotic',
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ))
                                                  ]),
                                                ),
                                                SizedBox(
                                                    width:
                                                        3.5), // Espacio entre los "Radio Buttons"
                                                // Segundo "Radio Button"
                                                GestureDetector(
                                                    onTap: () async {
                                                      await fetchShows();
                                                      setState(() {
                                                        _selectedIndex =
                                                            1; // Establecer el índice como 1
                                                      });
                                                    },
                                                    child: Column(children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: _selectedIndex ==
                                                                    1
                                                                ? Color(
                                                                    0xFF03045e)
                                                                : Colors.black,
                                                            width: 2,
                                                          ),
                                                          color: _selectedIndex ==
                                                                  1
                                                              ? Color(
                                                                  0xFF03045e)
                                                              : Colors
                                                                  .transparent,
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(12),
                                                        child: _selectedIndex ==
                                                                1
                                                            ? Icon(Icons.check,
                                                                color: Color(
                                                                    0xFFcaf0f8))
                                                            : SizedBox(),
                                                      ),
                                                      Center(
                                                          child: Text(
                                                        "Activo",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: size.width *
                                                              0.030,
                                                          fontFamily: 'gotic',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ))
                                                    ])),
                                                SizedBox(
                                                    width:
                                                        3.5), // Espacio entre los "Radio Buttons"
                                                // Tercer "Radio Button"
                                                GestureDetector(
                                                    onTap: () async {
                                                      await fetchShows();
                                                      setState(() {
                                                        _selectedIndex =
                                                            2; // Establecer el índice como 2
                                                      });
                                                    },
                                                    child: Column(children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: _selectedIndex ==
                                                                    2
                                                                ? Color(
                                                                    0xFF03045e)
                                                                : Colors.black,
                                                            width: 2,
                                                          ),
                                                          color: _selectedIndex ==
                                                                  2
                                                              ? Color(
                                                                  0xFF03045e)
                                                              : Colors
                                                                  .transparent,
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(12),
                                                        child: _selectedIndex ==
                                                                2
                                                            ? Icon(Icons.check,
                                                                color: Color(
                                                                    0xFFcaf0f8))
                                                            : SizedBox(),
                                                      ),
                                                      Center(
                                                          child: Text(
                                                        "Jugando",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: size.width *
                                                              0.030,
                                                          fontFamily: 'gotic',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ))
                                                    ])),
                                                SizedBox(
                                                    width:
                                                        3.5), // Espacio entre los "Radio Buttons"
                                                // Tercer "Radio Button"
                                                GestureDetector(
                                                    onTap: () async {
                                                      await fetchShows();
                                                      setState(() {
                                                        _selectedIndex =
                                                            3; // Establecer el índice como 2
                                                      });
                                                    },
                                                    child: Column(children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: _selectedIndex ==
                                                                    3
                                                                ? Color(
                                                                    0xFF03045e)
                                                                : Colors.black,
                                                            width: 2,
                                                          ),
                                                          color: _selectedIndex ==
                                                                  3
                                                              ? Color(
                                                                  0xFF03045e)
                                                              : Colors
                                                                  .transparent,
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(12),
                                                        child: _selectedIndex ==
                                                                3
                                                            ? Icon(Icons.check,
                                                                color: Color(
                                                                    0xFFcaf0f8))
                                                            : SizedBox(),
                                                      ),
                                                      Center(
                                                          child: Text(
                                                        "Finalizado",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: size.width *
                                                              0.030,
                                                          fontFamily: 'gotic',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ))
                                                    ])),
                                                GestureDetector(
                                                    onTap: () async {
                                                      await fetchShows();
                                                      setState(() {
                                                        _selectedIndex =
                                                            4; // Establecer el índice como 2
                                                      });
                                                    },
                                                    child: Column(children: [
                                                      Container(
                                                        decoration:
                                                            BoxDecoration(
                                                          shape:
                                                              BoxShape.circle,
                                                          border: Border.all(
                                                            color: _selectedIndex ==
                                                                    4
                                                                ? Color(
                                                                    0xFF03045e)
                                                                : Colors.black,
                                                            width: 2,
                                                          ),
                                                          color: _selectedIndex ==
                                                                  4
                                                              ? Color(
                                                                  0xFF03045e)
                                                              : Colors
                                                                  .transparent,
                                                        ),
                                                        padding:
                                                            EdgeInsets.all(12),
                                                        child: _selectedIndex ==
                                                                4
                                                            ? Icon(Icons.check,
                                                                color: Color(
                                                                    0xFFcaf0f8))
                                                            : SizedBox(),
                                                      ),
                                                      Center(
                                                          child: Text(
                                                        "Cancelado",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: size.width *
                                                              0.030,
                                                          fontFamily: 'gotic',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ))
                                                    ])),
                                              ],
                                            ),
                                          ),
                                          AnimatedButton(
                                              color: Color(0xFF03045e),
                                              height: size.height * 0.05,
                                              width: size.width * 0.16,
                                              duration: 2,
                                              onPressed: () async {
                                                await showDialog(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) {
                                                    return PagosWidget(
                                                      datosuser:
                                                          widget.datosuser,
                                                    );
                                                  },
                                                );
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
                                                    "Pagos",
                                                    style: TextStyle(
                                                      color: Color(0xFFcaf0f8),
                                                      fontSize:
                                                          size.width * 0.03,
                                                      fontFamily: 'gotic',
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  )))),
                                        ]),
                                    listasetresponseList == null
                                        ? Container()
                                        : Container(
                                            height: size.height * 0.44,
                                            child: ListView.separated(
                                                separatorBuilder: (context,
                                                        index) =>
                                                    Divider(
                                                      height: 0,
                                                      color: Color(0xFFcaf0f8),
                                                      thickness: 0,
                                                      indent: 0,
                                                      endIndent: 0,
                                                    ),
                                                itemCount: listasetresponseList!
                                                    .length,
                                                itemBuilder: ((ctx, index) {
                                                  final order =
                                                      listasetresponseList![
                                                          index];

                                                  return order.bingo.fecha.year
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(
                                                                  _selectedDate
                                                                      .year
                                                                      .toString()) &&
                                                          order.bingo.estado
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(
                                                                  _selectedIndex
                                                                      .toString()) &&
                                                          order
                                                              .bingo.fecha.month
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(
                                                                  _selectedDate
                                                                      .month
                                                                      .toString())
                                                      ? GestureDetector(
                                                          onTap: () async {
                                                            await Navigator.push(
                                                                context,
                                                                MaterialPageRoute(
                                                                  builder: (context) => MyHomePage(
                                                                      bingo:
                                                                          order,
                                                                      datosuser:
                                                                          widget
                                                                              .datosuser),
                                                                ));

                                                            await fetchShows();
                                                          },
                                                          child: Padding(
                                                              padding: EdgeInsets
                                                                  .only(
                                                                      left: 8,
                                                                      right: 8,
                                                                      top: 0),
                                                              child: Container(
                                                                width:
                                                                    size.width *
                                                                        0.9,
                                                                height:
                                                                    size.height *
                                                                        0.18,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  color: Color(
                                                                      0xFF023e8a),
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                ),
                                                                child: Padding(
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              20),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.spaceBetween,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Column(
                                                                            mainAxisSize:
                                                                                MainAxisSize.min,
                                                                            crossAxisAlignment:
                                                                                CrossAxisAlignment.start,
                                                                            children: [
                                                                              Padding(
                                                                                padding: EdgeInsetsDirectional.fromSTEB(0, 1, 0, 1),
                                                                                child: Text(
                                                                                  'Bingo ID',
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Cera Pro',
                                                                                    color: Colors.white,
                                                                                    fontSize: size.width * 0.04,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w500,
                                                                                  ),
                                                                                ),
                                                                              ),
                                                                              Text(
                                                                                '${order.bingo.bingoId}'.toUpperCase(),
                                                                                style: TextStyle(
                                                                                  fontFamily: 'Cera Pro',
                                                                                  color: Colors.white,
                                                                                  fontSize: size.width * 0.06,
                                                                                  letterSpacing: 0.0,
                                                                                  fontWeight: FontWeight.w500,
                                                                                ),
                                                                              ),
                                                                            ],
                                                                          ),
                                                                        ],
                                                                      ),
                                                                      Text(
                                                                        "Descripción: " +
                                                                            order.bingo.descripcion,
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Cera Pro',
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              size.width * 0.034,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                      ),
                                                                      Row(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        children: [
                                                                          Padding(
                                                                              padding: EdgeInsetsDirectional.fromSTEB(0, 0, 25, 0),
                                                                              child: Column(
                                                                                children: [
                                                                                  Text(
                                                                                    "Valor c/u \$" + (order.bingo.precioPorCartilla.toStringAsFixed(2)),
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'Cera Pro',
                                                                                      color: Colors.white,
                                                                                      fontSize: size.width * 0.030,
                                                                                      letterSpacing: 1.5,
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    "Valor Total \$" + ((order.bingo.precioPorCartilla * 6).toStringAsFixed(2)),
                                                                                    style: TextStyle(
                                                                                      fontFamily: 'Cera Pro',
                                                                                      color: Colors.white,
                                                                                      fontSize: size.width * 0.030,
                                                                                      letterSpacing: 1.5,
                                                                                      fontWeight: FontWeight.w500,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              )),
                                                                          Text(
                                                                            order.bingo.fecha.toString().substring(0,
                                                                                16),
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Gilroy',
                                                                              color: Colors.white,
                                                                              fontSize: size.width * 0.030,
                                                                              letterSpacing: 1.5,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ),
                                                              )),
                                                        )
                                                      : Container();
                                                })))
                                  ]))))),
            ])),
        floatingActionButton: GestureDetector(
            onTap: () async {
              await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ModificarPromotor(datosuser: widget.datosuser),
                  ));
            },
            child: Container(
              width: size.width * 0.4,
              color: Color(0xFF03045e),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Modificar Usuario",
                          style: TextStyle(
                            color: Color(0xFFcaf0f8),
                            fontSize: size.width * 0.042,
                            fontFamily: 'gotic',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.supervised_user_circle,
                          size: size.width * 0.059,
                          color: Color(0xFFcaf0f8),
                        ),
                      ],
                    )
                  ]),
            )));
  }
}

late Future<void> _initializeControllerFuture;

class MyHomePage extends StatefulWidget {
  MyHomePage({super.key, required this.bingo, required this.datosuser});
  ModelCliente? datosuser;

  listasetconvert.Sala? bingo;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController? qrcodeController = TextEditingController(text: "-1");
  Future<void> requestCameraPermission() async {
    final PermissionStatus status = await Permission.camera.request();
    if (status.isDenied) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          title: Text('Camera permission'),
          content: Text('Please enable camera access in your device settings.'),
          actions: <Widget>[
            TextButton(
              child: Text('Ok'),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        ),
      );
    }
  }

  Future<void> initializeCameras() async {
    if (await Permission.camera.isDenied) {
      requestCameraPermission();
    }
    if (await Permission.camera.isDenied) {
      requestCameraPermission();
    }
    try {} catch (e) {
      openAppSettings();

      print('Error initializing camera: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    _controller.text =
        _value.toString(); // Inicializar el valor del controlador

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      requestCameraPermission();
      initializeCameras();
    });
  }

  Future<List<listasetconvert.Sala>?>? listaset;
  List<listasetconvert.Sala>? listasetresponseListbingo;
  final ioc = new HttpClient();
  Future<List<listasetconvert.Sala>?> fetchShowsbingo() async {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(widget.bingo!.bingo.fecha);

    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    final url = Uri.parse(ipController.text +
        "/api/BingoPremioDetalleInterno/GetAll?Estado=1&FechaInicio=" +
        formattedDate);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListbingo =
            listasetconvert.salaFromMap(utf8.decode(response.bodyBytes));
        var resultado = listasetresponseListbingo!.firstWhere(
          (elemento) => elemento.bingo.bingoId == widget.bingo!.bingo.bingoId,
        );

        if (resultado != null) {
          print("Elemento encontrado: ${resultado.bingo.bingoId}");
          setState(() {
            widget.bingo = resultado;
          });
        } else {}
      });

      return listasetresponseListbingo;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  DateTime _selectedDate = DateTime.now();

  Future<List<listasetconvertpromotor.Promotor>?>? listasetpromotor;
  listasetconvertpromotor.Promotor? listasetresponseListpromotor;

  Future<listasetconvertpromotor.Promotor?> fetchShows() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    final url = Uri.parse(ipController.text +
        "/api/DashboardInterno/GetDashboarPromotor/" +
        widget.datosuser!.promotorId.toString());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListpromotor = listasetconvertpromotor
            .promotorFromJson(utf8.decode(response.bodyBytes));
      });

      return listasetresponseListpromotor;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  final boxDecoration = BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFcaf0f8), Color(0xFF00b4d8)],
          stops: [0.3, 0.9]));
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
          top: true,
          child: Container(
            height: double.infinity,
            width: size.width,
            decoration: BoxDecoration(
              color: Color(0xFFcaf0f8),
            ),
            alignment: AlignmentDirectional(0.0, -1.0),
            child: SingleChildScrollView(
                child: Stack(
              children: <Widget>[
                Container(
                  decoration: boxDecoration,
                ),
                Positioned(
                  top: -130,
                  left: -15,
                  child: Column(
                    children: [
                      Box(),
                    ],
                  ),
                ),
                Positioned(
                  top: 340,
                  left: 105,
                  child: Column(
                    children: [
                      Box2(),
                    ],
                  ),
                ),
                Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Container(
                        height: size.height,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.arrow_back,
                                                color: Color(0xFF03045e),
                                                size: size.width * 0.08),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        child: Container(
                                          height: size.height * 0.1,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/logo.png"),
                                                fit: BoxFit.fill),
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                        ),
                                      ),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Bienvenido: " +
                                                      widget
                                                          .datosuser!.nombres!,
                                                  style: TextStyle(
                                                    color: Color(0xFF03045e),
                                                    fontSize: size.width * 0.03,
                                                    fontFamily: 'gotic',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  "Usuario: " +
                                                      widget
                                                          .datosuser!.usuario!,
                                                  style: TextStyle(
                                                    color: Color(0xFF03045e),
                                                    fontSize: size.width * 0.03,
                                                    fontFamily: 'gotic',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                )
                                              ],
                                            ),
                                          ]),
                                      SizedBox(
                                        height: size.height * 0.01,
                                      ),
                                      Column(
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceAround,
                                            children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 0,
                                                          left: 0,
                                                          right: 0,
                                                          bottom: 0),
                                                  child: Row(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .center,
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceAround,
                                                      children: [
                                                        AnimatedButton(
                                                            color: Color(
                                                                0xFF03045e),
                                                            height:
                                                                size.height *
                                                                    0.05,
                                                            width: size.width *
                                                                0.16,
                                                            duration: 2,
                                                            onPressed:
                                                                () async {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return PagosWidget(
                                                                    datosuser:
                                                                        widget
                                                                            .datosuser,
                                                                  );
                                                                },
                                                              );
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 0,
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0),
                                                                child: Center(
                                                                    child: Text(
                                                                  "Pagos",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFFcaf0f8),
                                                                    fontSize:
                                                                        size.width *
                                                                            0.03,
                                                                    fontFamily:
                                                                        'gotic',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                )))),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.05,
                                                        ),
                                                        AnimatedButton(
                                                            color: Color(
                                                                0xFF03045e),
                                                            height:
                                                                size.height *
                                                                    0.05,
                                                            width: size.width *
                                                                0.16,
                                                            duration: 2,
                                                            onPressed:
                                                                () async {
                                                              await fetchShowsbingo();
                                                              if (widget
                                                                          .bingo!
                                                                          .bingo
                                                                          .estado ==
                                                                      2 ||
                                                                  widget
                                                                          .bingo!
                                                                          .bingo
                                                                          .estado ==
                                                                      3) {
                                                                showAlerta(
                                                                    context,
                                                                    'Mensaje Informativo',
                                                                    'Para ventas el bingo debe estar en un estado diferente de jugando!!');
                                                              } else {
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return VentasWidget(
                                                                      datosuser:
                                                                          widget
                                                                              .datosuser,
                                                                      bingo: widget
                                                                          .bingo,
                                                                    );
                                                                  },
                                                                );
                                                              }
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 0,
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0),
                                                                child: Center(
                                                                    child: Text(
                                                                  "Ventas",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFFcaf0f8),
                                                                    fontSize:
                                                                        size.width *
                                                                            0.03,
                                                                    fontFamily:
                                                                        'gotic',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                )))),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.05,
                                                        ),
                                                        AnimatedButton(
                                                            color: Color(
                                                                0xFF03045e),
                                                            height:
                                                                size.height *
                                                                    0.05,
                                                            width: size.width *
                                                                0.16,
                                                            duration: 2,
                                                            onPressed:
                                                                () async {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return UvtWidget(
                                                                    datosuser:
                                                                        widget
                                                                            .datosuser,
                                                                    bingo: widget
                                                                        .bingo,
                                                                  );
                                                                },
                                                              );
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 0,
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0),
                                                                child: Center(
                                                                    child: Text(
                                                                  "UVT",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFFcaf0f8),
                                                                    fontSize:
                                                                        size.width *
                                                                            0.03,
                                                                    fontFamily:
                                                                        'gotic',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                )))),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.05,
                                                        ),
                                                        AnimatedButton(
                                                            color: Color(
                                                                0xFF03045e),
                                                            height:
                                                                size.height *
                                                                    0.05,
                                                            width: size.width *
                                                                0.16,
                                                            duration: 2,
                                                            onPressed:
                                                                () async {
                                                              await showDialog(
                                                                context:
                                                                    context,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return ClienteWidget(
                                                                    datosuser:
                                                                        widget
                                                                            .datosuser,
                                                                    bingo: widget
                                                                        .bingo,
                                                                  );
                                                                },
                                                              );
                                                              setState(() {});
                                                            },
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 0,
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0),
                                                                child: Center(
                                                                    child: Text(
                                                                  "Clientes",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFFcaf0f8),
                                                                    fontSize:
                                                                        size.width *
                                                                            0.03,
                                                                    fontFamily:
                                                                        'gotic',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                )))),
                                                      ])),

                                              // Padding(
                                              //     padding: const EdgeInsets.only(
                                              //         top: 10, left: 0, right: 0, bottom: 0),
                                              //     child: Row(
                                              //         crossAxisAlignment: CrossAxisAlignment.center,
                                              //         mainAxisAlignment: MainAxisAlignment.center,
                                              //         children: [
                                              //           AnimatedButton(
                                              //               color: Color(0xFF03045e),
                                              //               height: size.height * 0.05,
                                              //               width: size.width * 0.3,
                                              //               duration: 2,
                                              //               onPressed: () async {
                                              //                 await fetchShows();
                                              //                 await showDialog(
                                              //                   context: context,
                                              //                   builder: (BuildContext context) {
                                              //                     return PromotorWidget(
                                              //                       listasetresponseList:
                                              //                           listasetresponseListpromotor,
                                              //                     );
                                              //                   },
                                              //                 );
                                              //                 setState(() {});
                                              //               },
                                              //               child: Container(
                                              //                   padding: const EdgeInsets.only(
                                              //                       top: 0,
                                              //                       left: 0,
                                              //                       right: 0,
                                              //                       bottom: 0),
                                              //                   child: Center(
                                              //                       child: Text(
                                              //                     "Resumen",
                                              //                     style: TextStyle(
                                              //                       color: Color(0xFFcaf0f8),
                                              //                       fontSize: size.width * 0.034,
                                              //                       fontFamily: 'gotic',
                                              //                       fontWeight: FontWeight.bold,
                                              //                     ),
                                              //                   )))),
                                              //         ])),
                                            ],
                                          )
                                        ],
                                      ),
                                      SingleChildScrollView(
                                          padding: EdgeInsets.only(
                                              left: 0, right: 0, top: 0),
                                          child: Container(
                                              width: size.width,
                                              height:
                                                  qrcodeController!.text != "-1"
                                                      ? size.height * 0.15
                                                      : size.height * 0.15,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                              child: Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 08,
                                                      right: 0,
                                                      top: 2,
                                                      bottom: 0),
                                                  child: Row(
                                                    children: [
                                                      Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 6,
                                                                  right: 6,
                                                                  top: 0),
                                                          child: Container(
                                                            width: size.width *
                                                                0.5,
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 10,
                                                                    right: 10,
                                                                    top: 0),
                                                            height:
                                                                size.height *
                                                                    0.124,
                                                            decoration:
                                                                BoxDecoration(
                                                              color: Color(
                                                                  0xFF023e8a),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30),
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8),
                                                              child: Column(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .start,
                                                                children: [
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceBetween,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.min,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                2,
                                                                                0,
                                                                                2),
                                                                            child:
                                                                                Text(
                                                                              'Bingo ID',
                                                                              style: TextStyle(
                                                                                fontFamily: 'Cera Pro',
                                                                                color: Colors.white,
                                                                                fontSize: size.width * 0.030,
                                                                                letterSpacing: 0.0,
                                                                                fontWeight: FontWeight.w500,
                                                                              ),
                                                                            ),
                                                                          ),
                                                                          Text(
                                                                            '${widget.bingo!.bingo.bingoId}'.toUpperCase(),
                                                                            style:
                                                                                TextStyle(
                                                                              fontFamily: 'Cera Pro',
                                                                              color: Colors.white,
                                                                              fontSize: size.width * 0.050,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.w500,
                                                                            ),
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            0,
                                                                            0,
                                                                            25,
                                                                            0),
                                                                    child: Text(
                                                                      "Valor \$" +
                                                                          (widget
                                                                              .bingo!
                                                                              .bingo
                                                                              .precioPorCartilla
                                                                              .toStringAsFixed(2)),
                                                                      style:
                                                                          TextStyle(
                                                                        fontFamily:
                                                                            'Cera Pro',
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            size.width *
                                                                                0.030,
                                                                        letterSpacing:
                                                                            1.5,
                                                                        fontWeight:
                                                                            FontWeight.w500,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                  Row(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Text(
                                                                        widget
                                                                            .bingo!
                                                                            .bingo
                                                                            .fecha
                                                                            .toString()
                                                                            .substring(0,
                                                                                16),
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Gilroy',
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              size.width * 0.030,
                                                                          letterSpacing:
                                                                              1.5,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                          )),
                                                      Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .end,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .end,
                                                          children: [
                                                            Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        bottom:
                                                                            0),
                                                                child:
                                                                    GestureDetector(
                                                                        onTap:
                                                                            () async {
                                                                          await fetchShowsbingo();
                                                                          if (widget.bingo!.bingo.estado == 2 ||
                                                                              widget.bingo!.bingo.estado == 3) {
                                                                            showAlerta(
                                                                                context,
                                                                                'Mensaje Informativo',
                                                                                'Para ventas el bingo debe estar en un estado diferente de jugando!!');
                                                                          } else {
                                                                            qrcodeController!.text =
                                                                                "-1";
                                                                            setState(() {});
                                                                            final PermissionStatus
                                                                                status =
                                                                                await Permission.camera.request();
                                                                            if (status.isDenied) {
                                                                              await _initializeControllerFuture;
                                                                            } else {
                                                                              var res = await Navigator.push(
                                                                                  context,
                                                                                  MaterialPageRoute(
                                                                                    builder: (context) => const SimpleBarcodeScannerPage(),
                                                                                  ));
                                                                              setState(() {
                                                                                if (res is String) {}
                                                                              });
                                                                              if (res == "-1") {
                                                                                setState(() {});
                                                                              } else {
                                                                                setState(() {
                                                                                  qrcodeController!.text = res;
                                                                                });

                                                                                setState(() {});
                                                                              }

                                                                              setState(() {});
                                                                            }
                                                                          }
                                                                          setState(
                                                                              () {});
                                                                          setState(
                                                                              () {});
                                                                        },
                                                                        child:
                                                                            Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.center,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.center,
                                                                          children: [
                                                                            Icon(Icons.qr_code,
                                                                                color: Color(0xFF03045e),
                                                                                size: size.width * 0.14),
                                                                          ],
                                                                        ))),
                                                          ])
                                                    ],
                                                  )))),
                                      SingleChildScrollView(
                                          child: Container(
                                              height:
                                                  qrcodeController!.text != "-1"
                                                      ? size.height * 0.5
                                                      : size.height * 0.2,
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                                color: Colors.transparent,
                                                image: qrcodeController!.text !=
                                                        "-1"
                                                    ? null
                                                    : DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/bingo.jpg"),
                                                        fit: BoxFit.fill),
                                              ),
                                              alignment: AlignmentDirectional(
                                                  0.0, -1.0),
                                              child: qrcodeController!.text !=
                                                      "-1"
                                                  ? Scaffold(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      body: CreacionBingo(
                                                        datosuser:
                                                            widget.datosuser,
                                                        bingo: widget.bingo,
                                                        modulo:
                                                            qrcodeController!
                                                                .text,
                                                        actualizarElementos:
                                                            actualizarElementos,
                                                      ))
                                                  : Container())),
                                    ])))))
              ],
            )),
          )),
    );
  }

  Future<String>? actualizarElementos(bool valida) async {
    if (valida) {
      qrcodeController!.text = "-1";
      setState(() {
        valida = false;
      });
    } else {
      // Lógica para el caso en que valida es false
    }

    // Debes devolver un valor de tipo Future<String> aquí, en función de la lógica que necesites
    Future<String> resultado = Future.value('Resultado de actualizarElementos');
    return resultado;
  }

  void _increment() {
    setState(() {
      _value++;
      _controller.text = _value.toString();
    });
  }

  void _decrement() {
    if (_value > 0) {
      setState(() {
        _value--;
        _controller.text = _value.toString();
      });
    }
  }

  TextEditingController _controller = TextEditingController();
  int _value = 0;
  int _selectedIndex = -1; // Variable para rastrear el índice del seleccionado
}

class VentasWidget extends StatefulWidget {
  ModelCliente? datosuser;

  listasetconvert.Sala? bingo;
  VentasWidget({super.key, required this.bingo, required this.datosuser});

  @override
  State<VentasWidget> createState() => _VentasWidgetState();
}

class _VentasWidgetState extends State<VentasWidget> {
  String searchString = "";
  String searchStringproduct = "";
  String detectionInfo = "";
  DateTime _selectedDate = DateTime.now();
  final ioc = new HttpClient();
  Future<List<listasetventasconvert.Bingo>?>? listaset;
  List<listasetventasconvert.Bingo>? listasetresponseList;

  Future<List<listasetventasconvert.Bingo>?> fetchShows() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    String _fecha = _selectedDate.year.toString() +
        "-" +
        _selectedDate.month.toString() +
        "-" +
        _selectedDate.day.toString();

    final url = Uri.parse(ipController.text +
        "/api/PromotorInterno/GetMisVentasByPromotor?PromotorId=" +
        widget.datosuser!.promotorId.toString() +
        "&FechaCompra=" +
        _fecha);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseList =
            listasetventasconvert.salaFromMap(utf8.decode(response.bodyBytes));

        listasetresponseList!.sort((a, b) {
          return (b.ventaId ?? 0).compareTo(a.ventaId ?? 0);
        });
      });

      return listasetresponseList;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
    listaset = fetchShows();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  List<listasetconvert.Sala>? listasetresponseListbingo;

  Future<List<listasetconvert.Sala>?> fetchShowsbingo() async {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(widget.bingo!.bingo.fecha);

    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    final url = Uri.parse(ipController.text +
        "/api/BingoPremioDetalleInterno/GetAll?Estado=1&FechaInicio=" +
        formattedDate);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListbingo =
            listasetconvert.salaFromMap(utf8.decode(response.bodyBytes));
        var resultado = listasetresponseListbingo!.firstWhere(
          (elemento) => elemento.bingo.bingoId == widget.bingo!.bingo.bingoId,
        );

        if (resultado != null) {
          print("Elemento encontrado: ${resultado.bingo.bingoId}");
          setState(() {
            widget.bingo = resultado;
          });
        } else {}
      });

      return listasetresponseListbingo;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    DateTime maxDate = _selectedDate.add(Duration(days: 365));
    return Scaffold(
        backgroundColor: Color(0xFFcaf0f8),
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Stack(
              children: [
                Positioned(
                  top: -130,
                  left: -15,
                  child: Column(
                    children: [
                      Box(),
                    ],
                  ),
                ),
                Positioned(
                  top: 340,
                  left: 105,
                  child: Column(
                    children: [
                      Box2(),
                    ],
                  ),
                ),
                Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Container(
                        height: size.height,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.arrow_back,
                                                color: Color(0xFF03045e),
                                                size: size.width * 0.08),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        child: Container(
                                          height: size.height * 0.1,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/logo.png"),
                                                fit: BoxFit.fill),
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                        ),
                                      ),
                                      Container(
                                        height: size.height * 0.09,
                                        child: ScrollDatePicker(
                                          options: DatePickerOptions(
                                            backgroundColor: Color(0xFFcaf0f8),
                                          ),
                                          maximumDate: maxDate,
                                          selectedDate: _selectedDate,
                                          locale: Locale('es'),
                                          onDateTimeChanged: (DateTime value) {
                                            setState(() {
                                              _selectedDate = value;
                                            });

                                            listaset = fetchShows();
                                            setState(() {});
                                          },
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Container(
                                            width: size.width * 0.62,
                                            padding: EdgeInsets.only(
                                                top: 0, bottom: 0),
                                            height: size.height * 0.06,
                                            child: TextField(
                                              style: TextStyle(
                                                color: Color(0xFF424242),
                                                fontSize: size.width * 0.04,
                                              ),
                                              onChanged: (value) async {
                                                setState(() {
                                                  detectionInfo = "";
                                                });

                                                setState(() {
                                                  searchString =
                                                      value.toUpperCase();
                                                });
                                              },
                                              onSubmitted: (value) async {
                                                setState(() {
                                                  detectionInfo = "";
                                                });

                                                setState(() {
                                                  searchString =
                                                      value.toUpperCase();
                                                });
                                              },
                                              decoration: InputDecoration(
                                                floatingLabelStyle: TextStyle(
                                                  color: Color(0xFF424242),
                                                  fontSize: size.width *
                                                      0.04, // Ajusta el tamaño de la letra de la etiqueta flotante aquí
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors
                                                        .black, // Borde inferior de color negro
                                                    width:
                                                        2.0, // Ancho del borde inferior
                                                  ),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors
                                                        .black, // Borde inferior de color negro al enfocar
                                                    width: 2.0,
                                                  ),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(
                                                        0xFF7CBF4F), // Borde inferior para el error
                                                    width: 2.0,
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xFF7CBF4F),
                                                    width: 2.0,
                                                  ),
                                                ),
                                                labelText: detectionInfo.isEmpty
                                                    ? "Buscar"
                                                    : detectionInfo,
                                                labelStyle: TextStyle(
                                                  color: Color(0xFF424242),
                                                  fontSize: size.width * 0.04,
                                                ),
                                                isDense: true,
                                                filled: true,
                                                fillColor: Color(0xFFcaf0f8),
                                              ),
                                            ),
                                          )),
                                      listasetresponseList == null
                                          ? Container()
                                          : Container(
                                              height: size.height * 0.54,
                                              child: ListView.separated(
                                                  separatorBuilder: (context,
                                                          index) =>
                                                      Divider(
                                                        height: 0,
                                                        color:
                                                            Color(0xFFcaf0f8),
                                                        thickness: 0,
                                                        indent: 0,
                                                        endIndent: 0,
                                                      ),
                                                  itemCount:
                                                      listasetresponseList!
                                                          .length,
                                                  itemBuilder: ((ctx, index) {
                                                    final order =
                                                        listasetresponseList![
                                                            index];

                                                    return order.bingo
                                                                    .toString()
                                                                    .toLowerCase()
                                                                    .contains(widget
                                                                        .bingo!
                                                                        .bingo
                                                                        .bingoId
                                                                        .toString()) &&
                                                                order.ventaId
                                                                    .toString()
                                                                    .toLowerCase()
                                                                    .contains(
                                                                        searchString) ||
                                                            order.codigoModulo
                                                                .toString()
                                                                .toLowerCase()
                                                                .contains(
                                                                    searchString)
                                                        ? GestureDetector(
                                                            onTap: () async {},
                                                            child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 4,
                                                                        right:
                                                                            4,
                                                                        top: 0),
                                                                child:

                                                                    // Generated code for this CardDetails Widget...
// Generated code for this Card_Style_1-1 Widget...
                                                                    Container(
                                                                  width:
                                                                      size.width *
                                                                          0.94,
                                                                  height:
                                                                      size.height *
                                                                          0.16,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: AssetImage(
                                                                          "assets/images/venta.png"),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            27,
                                                                            0,
                                                                            27,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                10),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                                                              children: [
                                                                                Text(
                                                                                  '${order.ventaId}'.toUpperCase(),
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Inter Tight',
                                                                                    color: Color(0xFFcaf0f8),
                                                                                    fontSize: 20,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w300,
                                                                                  ),
                                                                                ),
                                                                                AnimatedButton(
                                                                                    color: order.tipo == 1
                                                                                        ? Colors.grey
                                                                                        : order.tipo == 2
                                                                                            ? Colors.orange
                                                                                            : Colors.amber,
                                                                                    height: size.height * 0.06,
                                                                                    width: size.width * 0.3,
                                                                                    duration: 2,
                                                                                    onPressed: () async {},
                                                                                    child: Container(
                                                                                        padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                                                                                        child: Center(
                                                                                            child: Text(
                                                                                          order.tipo == 1
                                                                                              ? "Juego Normal"
                                                                                              : order.tipo == 2
                                                                                                  ? "Juego Promocional"
                                                                                                  : "Juego Progresivo * ${order.multiplicado}",
                                                                                          style: TextStyle(
                                                                                            color: Color(0xFF0077b6),
                                                                                            fontSize: size.width * 0.032,
                                                                                            fontFamily: 'gotic',
                                                                                            fontWeight: FontWeight.bold,
                                                                                          ),
                                                                                        )))),
                                                                              ],
                                                                            )),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          "Descripción: " + order.ventaId.toString(),
                                                                                          style: TextStyle(
                                                                                            fontFamily: 'Inter',
                                                                                            color: Color(0xFFcaf0f8),
                                                                                            letterSpacing: 0.0,
                                                                                            fontWeight: FontWeight.w200,
                                                                                          ),
                                                                                        ),
                                                                                        order.estado == 0
                                                                                            ? Container()
                                                                                            : GestureDetector(
                                                                                                onTap: () async {
                                                                                                  var size = MediaQuery.of(context).size;
                                                                                                  await fetchShowsbingo();

                                                                                                  if (widget.bingo!.bingo.estado == 2 || widget.bingo!.bingo.estado == 3) {
                                                                                                    showAlerta(context, 'Mensaje Informativo', 'Para ventas el bingo debe estar en un estado diferente de jugando!!');
                                                                                                  } else {
                                                                                                    await showDialog(
                                                                                                      context: context,
                                                                                                      builder: (BuildContext context) {
                                                                                                        return AlertDialog(
                                                                                                          backgroundColor: Color(0xFFcaf0f8).withOpacity(1),
                                                                                                          title: Text(
                                                                                                            'Desea editar este registro?',
                                                                                                            style: TextStyle(color: Color(0xFF03045e)),
                                                                                                          ),
                                                                                                          content: Text('confirmar edición.'),
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
                                                                                                                        style: TextStyle(fontSize: size.width * 0.03, color: Color(0xFFcaf0f8)),
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
                                                                                                                        backgroundColor: Color(0xFF03045e),
                                                                                                                      ),
                                                                                                                      child: Text(
                                                                                                                        'Confirmar',
                                                                                                                        style: TextStyle(fontSize: size.width * 0.03, color: Color(0xFFcaf0f8)),
                                                                                                                      ),
                                                                                                                      onPressed: () async {
                                                                                                                        //   await fetchShowsdelete(order.ventaId.toString());
                                                                                                                        //   listaset = fetchShows();
                                                                                                                        await showDialog(
                                                                                                                          context: context,
                                                                                                                          builder: (BuildContext context) {
                                                                                                                            return EdicionBingo(datosuser: widget.datosuser, bingo: widget.bingo, venta: order);
                                                                                                                          },
                                                                                                                        );

                                                                                                                        await fetchShows();
                                                                                                                        setState(() {});
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
                                                                                                child: Row(
                                                                                                  children: [
                                                                                                    Icon(
                                                                                                      Icons.edit,
                                                                                                      size: size.width * 0.07,
                                                                                                      color: Color(0xFFcaf0f8),
                                                                                                    ),
                                                                                                    Text(
                                                                                                      "Editar ",
                                                                                                      style: TextStyle(
                                                                                                        fontFamily: 'Inter Tight',
                                                                                                        color: Color(0xFFcaf0f8),
                                                                                                        letterSpacing: 0.0,
                                                                                                        fontWeight: FontWeight.w300,
                                                                                                      ),
                                                                                                    ),
                                                                                                  ],
                                                                                                )),
                                                                                      ],
                                                                                    )),
                                                                                Text(
                                                                                  "Modulo: " + order.codigoModulo.toString() + " Valor: " + "\$" + (order.precioTotalCartilla!.toStringAsFixed(2)),
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Inter Tight',
                                                                                    color: Color(0xFFcaf0f8),
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w300,
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
                                                                                    Row(
                                                                                      children: [
                                                                                        order.estado == 0
                                                                                            ? AnimatedButton(
                                                                                                color: Colors.red,
                                                                                                height: size.height * 0.03,
                                                                                                width: size.width * 0.3,
                                                                                                duration: 2,
                                                                                                onPressed: () async {},
                                                                                                child: Container(
                                                                                                    padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                                                                                                    child: Center(
                                                                                                        child: Text(
                                                                                                      "Registro Eliminado",
                                                                                                      style: TextStyle(
                                                                                                        color: Color(0xFFcaf0f8),
                                                                                                        fontSize: size.width * 0.032,
                                                                                                        fontFamily: 'gotic',
                                                                                                        fontWeight: FontWeight.bold,
                                                                                                      ),
                                                                                                    ))))
                                                                                            : GestureDetector(
                                                                                                onTap: () async {
                                                                                                  var size = MediaQuery.of(context).size;

                                                                                                  showDialog(
                                                                                                    context: context,
                                                                                                    builder: (BuildContext context) {
                                                                                                      return AlertDialog(
                                                                                                        backgroundColor: Color(0xFFcaf0f8).withOpacity(1),
                                                                                                        title: Text(
                                                                                                          'Desea elliminar este registro?',
                                                                                                          style: TextStyle(color: Color(0xFF03045e)),
                                                                                                        ),
                                                                                                        content: Text('confirmar Eliminación.'),
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
                                                                                                                      style: TextStyle(fontSize: size.width * 0.03, color: Color(0xFFcaf0f8)),
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
                                                                                                                      backgroundColor: Color(0xFF03045e),
                                                                                                                    ),
                                                                                                                    child: Text(
                                                                                                                      'Confirmar',
                                                                                                                      style: TextStyle(fontSize: size.width * 0.03, color: Color(0xFFcaf0f8)),
                                                                                                                    ),
                                                                                                                    onPressed: () async {
                                                                                                                      await fetchShowsdelete(order.ventaId.toString());
                                                                                                                      listaset = fetchShows();
                                                                                                                      setState(() {});
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
                                                                                                },
                                                                                                child: Icon(
                                                                                                  Icons.delete,
                                                                                                  size: size.width * 0.059,
                                                                                                  color: Colors.red,
                                                                                                ),
                                                                                              )
                                                                                      ],
                                                                                    )
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )))
                                                        : Container();
                                                  }))),
                                    ])))))
              ],
            )));
  }

  Future<String> fetchShowsdelete(String elemento) async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    final url = Uri.parse(
        ipController.text + "/api/PromotorInterno/Delete/" + elemento);

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      final snackBar =
          SnackBar(content: Text("Se ha confirmado la Eliminación.."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      return "si";
    } else {
      final snackBar =
          SnackBar(content: Text("No Se ha confirmado la Eliminación.."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      throw Exception('Failed to load shows');
    }
  }
}

class PagosWidget extends StatefulWidget {
  ModelCliente? datosuser;

  listasetconvert.Sala? bingo;
  PagosWidget({super.key, required this.datosuser});

  @override
  State<PagosWidget> createState() => _PagosWidgetState();
}

class _PagosWidgetState extends State<PagosWidget> {
  String searchString = "";
  String searchStringproduct = "";
  String detectionInfo = "";
  DateTime _selectedDate = DateTime.now();
  final ioc = new HttpClient();
  Future<List<listasetpagosconvert.Promotor>?>? listaset;
  List<listasetpagosconvert.Promotor>? listasetresponseListpagos;

  Future<List<listasetpagosconvert.Promotor>?> fetchShows() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    String _fecha = _selectedDate.year.toString() +
        "-" +
        _selectedDate.month.toString() +
        "-" +
        _selectedDate.day.toString();

    final url = Uri.parse(ipController.text +
        "/api/PromotorInterno/GetGanadoresForPromotor/" +
        widget.datosuser!.promotorId.toString());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListpagos = listasetpagosconvert
            .promotorFromJson(utf8.decode(response.bodyBytes));
      });

      return listasetresponseListpagos;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
    listaset = fetchShows();
    listasetuvt = fetchShowsUVT();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    DateTime maxDate = _selectedDate.add(Duration(days: 365));
    return Scaffold(
        backgroundColor: Color(0xFFcaf0f8),
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Stack(
              children: [
                Positioned(
                  top: -130,
                  left: -15,
                  child: Column(
                    children: [
                      Box(),
                    ],
                  ),
                ),
                Positioned(
                  top: 340,
                  left: 105,
                  child: Column(
                    children: [
                      Box2(),
                    ],
                  ),
                ),
                Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Container(
                        height: size.height,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.arrow_back,
                                                color: Color(0xFF03045e),
                                                size: size.width * 0.08),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        child: Container(
                                          height: size.height * 0.1,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/logo.png"),
                                                fit: BoxFit.fill),
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                        ),
                                      ),
                                      Text(
                                        'Lista de Ganadores del Bingo'
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.black,
                                          fontSize: 20,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      listasetresponseListpagos == null ||
                                              listasetresponseListpagos!
                                                      .length ==
                                                  0
                                          ? Center(
                                              child: AnimatedTextKit(
                                              animatedTexts: [
                                                TypewriterAnimatedText(
                                                    'No hay Resultados.',
                                                    textStyle: TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.white,
                                                      backgroundColor:
                                                          Color(0xFF427382),
                                                    )),
                                              ],
                                              isRepeatingAnimation: true,
                                              repeatForever: true,
                                              pause:
                                                  Duration(milliseconds: 1000),
                                            ))
                                          : Container(
                                              height: size.height * 0.54,
                                              child: ListView.separated(
                                                  separatorBuilder: (context,
                                                          index) =>
                                                      Divider(
                                                        height: 0,
                                                        color:
                                                            Color(0xFFcaf0f8),
                                                        thickness: 0,
                                                        indent: 0,
                                                        endIndent: 0,
                                                      ),
                                                  itemCount:
                                                      listasetresponseListpagos!
                                                          .length,
                                                  itemBuilder: ((ctx, index) {
                                                    final order =
                                                        listasetresponseListpagos![
                                                            index];
                                                    double
                                                        totalPremioAdicional =
                                                        0;
                                                    if (order
                                                            .detallePremioFigura!
                                                            .first
                                                            .listaAdicionales!
                                                            .length ==
                                                        0) {
                                                    } else {
                                                      totalPremioAdicional = order
                                                          .detallePremioFigura!
                                                          .first
                                                          .listaAdicionales!
                                                          .map((adicional) =>
                                                              adicional
                                                                      .premioAdicional
                                                                  as double)
                                                          .reduce((value,
                                                                  element) =>
                                                              value + element);
                                                    }

                                                    double valor_total = (order
                                                            .detallePremioFigura!
                                                            .first
                                                            .valorPremio! +
                                                        totalPremioAdicional);

                                                    return order.bingoId
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains("")
                                                        ? GestureDetector(
                                                            onTap: () async {},
                                                            child: Padding(
                                                                padding: EdgeInsets
                                                                    .only(
                                                                        left: 4,
                                                                        right:
                                                                            4,
                                                                        top: 0),
                                                                child:

                                                                    // Generated code for this CardDetails Widget...
// Generated code for this Card_Style_1-1 Widget...
                                                                    Container(
                                                                  width:
                                                                      size.width *
                                                                          0.94,
                                                                  height:
                                                                      size.height *
                                                                          0.16,
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    image:
                                                                        DecorationImage(
                                                                      fit: BoxFit
                                                                          .cover,
                                                                      image: AssetImage(
                                                                          "assets/images/venta.png"),
                                                                    ),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            25),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding: EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                            20,
                                                                            0,
                                                                            20,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      mainAxisSize:
                                                                          MainAxisSize
                                                                              .max,
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Padding(
                                                                            padding: EdgeInsetsDirectional.fromSTEB(
                                                                                0,
                                                                                0,
                                                                                0,
                                                                                10),
                                                                            child:
                                                                                Row(
                                                                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                                                                              children: [
                                                                                Column(
                                                                                  crossAxisAlignment: CrossAxisAlignment.center,
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: [
                                                                                    Text(
                                                                                      '${order.ventaId}'.toUpperCase(),
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Inter Tight',
                                                                                        color: Color(0xFFcaf0f8),
                                                                                        fontSize: 12,
                                                                                        letterSpacing: 0.0,
                                                                                        fontWeight: FontWeight.w300,
                                                                                      ),
                                                                                    ),
                                                                                  ],
                                                                                ),
                                                                                AnimatedButton(
                                                                                    color: Colors.amber,
                                                                                    height: size.height * 0.07,
                                                                                    width: size.width * 0.48,
                                                                                    duration: 2,
                                                                                    onPressed: () async {},
                                                                                    child: Container(
                                                                                        padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                                                                                        child: Center(
                                                                                            child: Column(
                                                                                          children: [
                                                                                            Text(
                                                                                              "Valor Total:  ${NumberFormat('#,##0', 'en_US').format(valor_total)}",
                                                                                              style: TextStyle(
                                                                                                color: Color(0xFF0077b6),
                                                                                                fontSize: size.width * 0.034,
                                                                                                fontFamily: 'gotic',
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              "Valor Premio:  ${NumberFormat('#,##0', 'en_US').format(order.detallePremioFigura!.first.valorPremio)}",
                                                                                              style: TextStyle(
                                                                                                color: Color(0xFF0077b6),
                                                                                                fontSize: size.width * 0.030,
                                                                                                fontFamily: 'gotic',
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                            ),
                                                                                            Text(
                                                                                              "Valor Adicionales:  ${NumberFormat('#,##0', 'en_US').format(totalPremioAdicional)}",
                                                                                              style: TextStyle(
                                                                                                color: Color(0xFF0077b6),
                                                                                                fontSize: size.width * 0.030,
                                                                                                fontFamily: 'gotic',
                                                                                                fontWeight: FontWeight.bold,
                                                                                              ),
                                                                                            )
                                                                                          ],
                                                                                        )))),
                                                                              ],
                                                                            )),
                                                                        Row(
                                                                          mainAxisSize:
                                                                              MainAxisSize.max,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.spaceBetween,
                                                                          children: [
                                                                            Column(
                                                                              mainAxisSize: MainAxisSize.max,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                                                                                    child: Row(
                                                                                      children: [],
                                                                                    )),
                                                                                Text(
                                                                                  "Modulo: " + order.codigoModulo.toString(),
                                                                                  style: TextStyle(
                                                                                    fontFamily: 'Inter Tight',
                                                                                    color: Color(0xFFcaf0f8),
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w300,
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
                                                                                    GestureDetector(
                                                                                        onTap: () async {
                                                                                          var size = MediaQuery.of(context).size;
                                                                                          double totaluvt = listasetresponseListpagosuvt!.cantidadUvt! == 0 ? 1 : double.parse(listasetresponseListpagosuvt!.cantidadUvt.toString());

                                                                                          showDialog(
                                                                                            context: context,
                                                                                            builder: (BuildContext context) {
                                                                                              return AlertDialog(
                                                                                                backgroundColor: Color(0xFFcaf0f8).withOpacity(1),
                                                                                                title: Text(
                                                                                                  'Desea Registrar este Pago del Modulo: ' + order.codigoModulo.toString(),
                                                                                                  style: TextStyle(color: Color(0xFF03045e)),
                                                                                                ),
                                                                                                content: Text(
                                                                                                  "Valor Total:  ${NumberFormat('#,##0', 'en_US').format(valor_total)}",
                                                                                                  style: TextStyle(
                                                                                                    color: Color(0xFF0077b6),
                                                                                                    fontSize: size.width * 0.034,
                                                                                                    fontFamily: 'gotic',
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                ),
                                                                                                actions: <Widget>[
                                                                                                  Column(
                                                                                                    children: [
                                                                                                      Row(children: [
                                                                                                        Text(
                                                                                                          "Premio:  ${order.detallePremioFigura!.first.nombreFigura}",
                                                                                                          style: TextStyle(
                                                                                                            color: Color(0xFF0077b6),
                                                                                                            fontSize: size.width * 0.024,
                                                                                                            fontFamily: 'gotic',
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                          ),
                                                                                                        ),
                                                                                                        Text(
                                                                                                          " Valor Premio:  ${NumberFormat('#,##0', 'en_US').format(order.detallePremioFigura!.first.valorPremio ?? 0)}",
                                                                                                          style: TextStyle(
                                                                                                            color: Color(0xFF0077b6),
                                                                                                            fontSize: size.width * 0.024,
                                                                                                            fontFamily: 'gotic',
                                                                                                            fontWeight: FontWeight.bold,
                                                                                                          ),
                                                                                                        ),
                                                                                                      ]),
                                                                                                      for (var Adicionales in order.detallePremioFigura!.first.listaAdicionales!)
                                                                                                        Row(children: [
                                                                                                          Text(
                                                                                                            "Premio Adicional:  ${Adicionales.categoria}",
                                                                                                            style: TextStyle(
                                                                                                              color: Color(0xFF0077b6),
                                                                                                              fontSize: size.width * 0.024,
                                                                                                              fontFamily: 'gotic',
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                            ),
                                                                                                          ),
                                                                                                          Text(
                                                                                                            " Valor Premio:  ${NumberFormat('#,##0', 'en_US').format(Adicionales.premioAdicional ?? 0)}",
                                                                                                            style: TextStyle(
                                                                                                              color: Color(0xFF0077b6),
                                                                                                              fontSize: size.width * 0.024,
                                                                                                              fontFamily: 'gotic',
                                                                                                              fontWeight: FontWeight.bold,
                                                                                                            ),
                                                                                                          ),
                                                                                                        ]),
                                                                                                      Text(
                                                                                                        "Valor Total Adicionales:  ${NumberFormat('#,##0', 'en_US').format(totalPremioAdicional ?? 0)}",
                                                                                                        style: TextStyle(
                                                                                                          color: Color(0xFF0077b6),
                                                                                                          fontSize: size.width * 0.024,
                                                                                                          fontFamily: 'gotic',
                                                                                                          fontWeight: FontWeight.bold,
                                                                                                        ),
                                                                                                      ),
                                                                                                      valor_total >= (listasetresponseListpagosuvt!.valorUvt! * totaluvt)
                                                                                                          ? Padding(
                                                                                                              padding: EdgeInsets.all(4),
                                                                                                              child: Container(
                                                                                                                width: size.width * 0.62,
                                                                                                                padding: EdgeInsets.only(top: 0, bottom: 0),
                                                                                                                height: size.height * 0.06,
                                                                                                                child: TextFormField(
                                                                                                                  controller: dniController,
                                                                                                                  style: TextStyle(
                                                                                                                    color: Color(0xFF424242),
                                                                                                                    fontSize: size.width * 0.04,
                                                                                                                  ),
                                                                                                                  decoration: InputDecoration(
                                                                                                                    floatingLabelStyle: TextStyle(
                                                                                                                      color: Color(0xFF424242),
                                                                                                                      fontSize: size.width * 0.04, // Ajusta el tamaño de la letra de la etiqueta flotante aquí
                                                                                                                      fontWeight: FontWeight.bold,
                                                                                                                    ),
                                                                                                                    enabledBorder: UnderlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                        color: Colors.black, // Borde inferior de color negro
                                                                                                                        width: 2.0, // Ancho del borde inferior
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    focusedBorder: UnderlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                        color: Colors.black, // Borde inferior de color negro al enfocar
                                                                                                                        width: 2.0,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    errorBorder: UnderlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                        color: Color(0xFF7CBF4F), // Borde inferior para el error
                                                                                                                        width: 2.0,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    focusedErrorBorder: UnderlineInputBorder(
                                                                                                                      borderSide: BorderSide(
                                                                                                                        color: Color(0xFF7CBF4F),
                                                                                                                        width: 2.0,
                                                                                                                      ),
                                                                                                                    ),
                                                                                                                    labelText: "Ingrese DNI",
                                                                                                                    labelStyle: TextStyle(
                                                                                                                      color: Color(0xFF424242),
                                                                                                                      fontSize: size.width * 0.04,
                                                                                                                    ),
                                                                                                                    isDense: true,
                                                                                                                    filled: true,
                                                                                                                    fillColor: Color(0xFFcaf0f8),
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
                                                                                                              style: TextStyle(fontSize: size.width * 0.03, color: Color(0xFFcaf0f8)),
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
                                                                                                              backgroundColor: Color(0xFF03045e),
                                                                                                            ),
                                                                                                            child: Text(
                                                                                                              'Confirmar ${NumberFormat('#,##0', 'en_US').format(valor_total ?? 0)}',
                                                                                                              style: TextStyle(fontSize: size.width * 0.03, color: Color(0xFFcaf0f8)),
                                                                                                            ),
                                                                                                            onPressed: () async {
                                                                                                              await fetchShowsUVT();

                                                                                                              if (valor_total >= (listasetresponseListpagosuvt!.valorUvt! * totaluvt)) {
                                                                                                                if (dniController.text == "") {
                                                                                                                  final snackBar = SnackBar(content: Text("Ingrese un DNI Valido.."));
                                                                                                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                                                                } else {
                                                                                                                  setState(() {
                                                                                                                    order.clienteId = dniController.text;
                                                                                                                    //order.detallePremioFigura!.first.estadoPago = 1;
                                                                                                                  });

                                                                                                                  await fetchShowscliente();
                                                                                                                  if (listasetresponseListpagoscliente == null) {
                                                                                                                    final snackBar = SnackBar(content: Text("Ingrese un DNI Valido.."));
                                                                                                                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                                                                                                  } else {
                                                                                                                    if (listasetresponseListpagoscliente!.doi == dniController.text && listasetresponseListpagoscliente!.doi != null) {
                                                                                                                      await fetchShowsdelete(order);
                                                                                                                    } else {
                                                                                                                      await Navigator.push(
                                                                                                                          context,
                                                                                                                          MaterialPageRoute(
                                                                                                                            builder: (context) => ModificarUsuario(doi:dniController.text),
                                                                                                                          ));
                                                                                                                    }
                                                                                                                  }
                                                                                                                }
                                                                                                              } else {
                                                                                                                await fetchShowsdelete(order);
                                                                                                              }

                                                                                                              listaset = fetchShows();

                                                                                                              setState(() {});
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
                                                                                        },
                                                                                        child: Row(
                                                                                          children: [
                                                                                            Container(
                                                                                                padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                                                                                                child: Center(
                                                                                                    child: Text(
                                                                                                  "Registrar Pago",
                                                                                                  style: TextStyle(
                                                                                                    color: Color(0xFFcaf0f8),
                                                                                                    fontSize: size.width * 0.032,
                                                                                                    fontFamily: 'gotic',
                                                                                                    fontWeight: FontWeight.bold,
                                                                                                  ),
                                                                                                ))),
                                                                                            Icon(
                                                                                              Icons.monetization_on_outlined,
                                                                                              size: size.width * 0.059,
                                                                                              color: Colors.green[600],
                                                                                            ),
                                                                                          ],
                                                                                        ))
                                                                                  ],
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                )))
                                                        : Container();
                                                  }))),
                                    ])))))
              ],
            )));
  }

  Future<listasetuvtconvert.Promotor?>? listasetuvt;
  listasetuvtconvert.Promotor? listasetresponseListpagosuvt;

  Future<listasetuvtconvert.Promotor?> fetchShowsUVT() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    final url = Uri.parse(ipController.text + "/api/ParametroInterno/GetAll");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListpagosuvt = listasetuvtconvert
            .promotorFromJson(utf8.decode(response.bodyBytes));
      });

      return listasetresponseListpagosuvt;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  listasetclienteconvert.Promotor? listasetresponseListpagoscliente;
  Future<listasetclienteconvert.Promotor?> fetchShowscliente() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    final url = Uri.parse(ipController.text +
        "/api/ClienteInterno/GetClienteByDocumento/" +
        dniController.text);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListpagoscliente = listasetclienteconvert
            .promotorFromJson(utf8.decode(response.bodyBytes));
      });

      return listasetresponseListpagoscliente;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  TextEditingController dniController = TextEditingController(text: "");
  Future<String> fetchShowsdelete(
      listasetpagosconvert.Promotor elemento) async {
    String jsonBody = json.encode(elemento.toJson());

    print(jsonBody);
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    final url = Uri.parse(
        ipController.text + "/api/PromotorInterno/RegistrarGanadorForPromotor");
    try {
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonBody);

      if (response.statusCode == 200) {
        final snackBar = SnackBar(content: Text("Se ha confirmado el pago.."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
        return "si";
      } else {
        final snackBar = SnackBar(
            content: Text("No Se ha confirmado el Pago valide el valor UVT.."));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        throw Exception('Failed to load shows');
      }
    } catch (e) {
      final snackBar = SnackBar(
          content: Text("No Se ha confirmado el Pago valide conexión."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      throw Exception('Failed to load shows');
    }
  }
}

class ClienteWidget extends StatefulWidget {
  ModelCliente? datosuser;

  listasetconvert.Sala? bingo;
  ClienteWidget({super.key, required this.bingo, required this.datosuser});

  @override
  State<ClienteWidget> createState() => _ClienteWidgetState();
}

class _ClienteWidgetState extends State<ClienteWidget> {
  String searchString = "";
  String searchStringproduct = "";
  String detectionInfo = "";
  DateTime _selectedDate = DateTime.now();
  final ioc = new HttpClient();
  Future<listasetclienteconvert.Promotor?>? listaset;
  listasetclienteconvert.Promotor? listasetresponseListpagos;

  Future<listasetclienteconvert.Promotor?> fetchShows() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    final url = Uri.parse(ipController.text +
        "/api/ClienteInterno/GetClienteByDocumento/" +
        dniController.text);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListpagos = listasetclienteconvert
            .promotorFromJson(utf8.decode(response.bodyBytes));
      });

      return listasetresponseListpagos;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    DateTime maxDate = _selectedDate.add(Duration(days: 365));
    return Scaffold(
        backgroundColor: Color(0xFFcaf0f8),
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Stack(
              children: [
                Positioned(
                  top: -130,
                  left: -15,
                  child: Column(
                    children: [
                      Box(),
                    ],
                  ),
                ),
                Positioned(
                  top: 340,
                  left: 105,
                  child: Column(
                    children: [
                      Box2(),
                    ],
                  ),
                ),
                Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Container(
                        height: size.height,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.arrow_back,
                                                color: Color(0xFF03045e),
                                                size: size.width * 0.08),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        child: Container(
                                          height: size.height * 0.1,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/logo.png"),
                                                fit: BoxFit.fill),
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                        ),
                                      ),
                                      Text(
                                        'Cliente'.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.black,
                                          fontSize: 20,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Padding(
                                          padding: EdgeInsets.all(4),
                                          child: Container(
                                            width: size.width * 0.62,
                                            padding: EdgeInsets.only(
                                                top: 0, bottom: 0),
                                            height: size.height * 0.06,
                                            child: TextFormField(
                                              controller: dniController,
                                              style: TextStyle(
                                                color: Color(0xFF424242),
                                                fontSize: size.width * 0.04,
                                              ),
                                              decoration: InputDecoration(
                                                floatingLabelStyle: TextStyle(
                                                  color: Color(0xFF424242),
                                                  fontSize: size.width *
                                                      0.04, // Ajusta el tamaño de la letra de la etiqueta flotante aquí
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                enabledBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors
                                                        .black, // Borde inferior de color negro
                                                    width:
                                                        2.0, // Ancho del borde inferior
                                                  ),
                                                ),
                                                focusedBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors
                                                        .black, // Borde inferior de color negro al enfocar
                                                    width: 2.0,
                                                  ),
                                                ),
                                                errorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(
                                                        0xFF7CBF4F), // Borde inferior para el error
                                                    width: 2.0,
                                                  ),
                                                ),
                                                focusedErrorBorder:
                                                    UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Color(0xFF7CBF4F),
                                                    width: 2.0,
                                                  ),
                                                ),
                                                labelText: "Ingrese DNI",
                                                labelStyle: TextStyle(
                                                  color: Color(0xFF424242),
                                                  fontSize: size.width * 0.04,
                                                ),
                                                isDense: true,
                                                filled: true,
                                                fillColor: Color(0xFFcaf0f8),
                                              ),
                                            ),
                                          )),
                                      TextButton(
                                        style: TextButton.styleFrom(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(0.0),
                                            side: const BorderSide(
                                                color: Colors.grey),
                                          ),
                                          backgroundColor: Color(0xFF03045e),
                                        ),
                                        child: Text(
                                          'Confirmar',
                                          style: TextStyle(
                                              fontSize: size.width * 0.03,
                                              color: Color(0xFFcaf0f8)),
                                        ),
                                        onPressed: () async {
                                          if (dniController.text == "") {
                                            final snackBar = SnackBar(
                                                content: Text(
                                                    "Ingrese un DNI Valido.."));
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(snackBar);
                                          } else {
                                            setState(() {
                                              //order.detallePremioFigura!.first.estadoPago = 1;
                                            });

                                            listaset = fetchShows();
                                            setState(() {});
                                          }

                                          setState(() {});
                                        },
                                      ),
                                      listasetresponseListpagos == null
                                          ? Container()
                                          : Container(
                                              height: size.height * 0.24,
                                              child: GestureDetector(
                                                  onTap: () async {},
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 4,
                                                          right: 4,
                                                          top: 0),
                                                      child:

                                                          // Generated code for this CardDetails Widget...
// Generated code for this Card_Style_1-1 Widget...
                                                          Container(
                                                        width:
                                                            size.width * 0.94,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: AssetImage(
                                                                "assets/images/venta.png"),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(0,
                                                                      10, 0, 0),
                                                          child: Column(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .start,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Center(
                                                                child: AnimatedButton(
                                                                    color: Colors.amber,
                                                                    height: size.height * 0.18,
                                                                    width: size.width * 0.68,
                                                                    duration: 2,
                                                                    onPressed: () async {},
                                                                    child: Container(
                                                                        padding: const EdgeInsets.only(top: 0, left: 10, right: 0, bottom: 0),
                                                                        child: Column(
                                                                          crossAxisAlignment:
                                                                              CrossAxisAlignment.start,
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment.start,
                                                                          children: [
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Nombre:  ${listasetresponseListpagos!.nombres}",
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF0077b6),
                                                                                    fontSize: size.width * 0.034,
                                                                                    fontFamily: 'gotic',
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Apellidos:  ${listasetresponseListpagos!.apellidos}",
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF0077b6),
                                                                                    fontSize: size.width * 0.034,
                                                                                    fontFamily: 'gotic',
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Documento:  ${listasetresponseListpagos!.doi}",
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF0077b6),
                                                                                    fontSize: size.width * 0.034,
                                                                                    fontFamily: 'gotic',
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Documento:  ${listasetresponseListpagos!.doi}",
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF0077b6),
                                                                                    fontSize: size.width * 0.034,
                                                                                    fontFamily: 'gotic',
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Telefono:  ${listasetresponseListpagos!.telefono}",
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF0077b6),
                                                                                    fontSize: size.width * 0.034,
                                                                                    fontFamily: 'gotic',
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Correo:  ${listasetresponseListpagos!.email}",
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF0077b6),
                                                                                    fontSize: size.width * 0.034,
                                                                                    fontFamily: 'gotic',
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                            Row(
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              mainAxisAlignment: MainAxisAlignment.start,
                                                                              children: [
                                                                                Text(
                                                                                  "Direccion:  ${listasetresponseListpagos!.direccion}",
                                                                                  style: TextStyle(
                                                                                    color: Color(0xFF0077b6),
                                                                                    fontSize: size.width * 0.034,
                                                                                    fontFamily: 'gotic',
                                                                                    fontWeight: FontWeight.bold,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                            ),
                                                                          ],
                                                                        ))),
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ))))
                                    ])))))
              ],
            )));
  }

  TextEditingController dniController = TextEditingController(text: "");
  Future<String> fetchShowsdelete(
      listasetpagosconvert.Promotor elemento) async {
    String jsonBody = json.encode(elemento.toJson());
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    final url = Uri.parse(
        ipController.text + "/api/PromotorInterno/RegistrarGanadorForPromotor");

    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody);

    if (response.statusCode == 200) {
      final snackBar =
          SnackBar(content: Text("Se ha confirmado la Eliminación.."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      return "si";
    } else {
      final snackBar =
          SnackBar(content: Text("No Se ha confirmado la Eliminación.."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      throw Exception('Failed to load shows');
    }
  }
}

class UvtWidget extends StatefulWidget {
  ModelCliente? datosuser;

  listasetconvert.Sala? bingo;
  UvtWidget({super.key, required this.bingo, required this.datosuser});

  @override
  State<UvtWidget> createState() => _UvtWidgetState();
}

class _UvtWidgetState extends State<UvtWidget> {
  String searchString = "";
  String searchStringproduct = "";
  String detectionInfo = "";
  DateTime _selectedDate = DateTime.now();
  final ioc = new HttpClient();
  Future<listasetuvtconvert.Promotor?>? listaset;
  listasetuvtconvert.Promotor? listasetresponseListpagos;

  Future<listasetuvtconvert.Promotor?> fetchShows() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    String _fecha = _selectedDate.year.toString() +
        "-" +
        _selectedDate.month.toString() +
        "-" +
        _selectedDate.day.toString();

    final url = Uri.parse(ipController.text + "/api/ParametroInterno/GetAll");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListpagos = listasetuvtconvert
            .promotorFromJson(utf8.decode(response.bodyBytes));
      });

      return listasetresponseListpagos;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
    listaset = fetchShows();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    DateTime maxDate = _selectedDate.add(Duration(days: 365));
    return Scaffold(
        backgroundColor: Color(0xFFcaf0f8),
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Stack(
              children: [
                Positioned(
                  top: -130,
                  left: -15,
                  child: Column(
                    children: [
                      Box(),
                    ],
                  ),
                ),
                Positioned(
                  top: 340,
                  left: 105,
                  child: Column(
                    children: [
                      Box2(),
                    ],
                  ),
                ),
                Align(
                    alignment: AlignmentDirectional(0, 0),
                    child: Container(
                        height: size.height,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Align(
                            alignment: AlignmentDirectional(0, 0),
                            child: Padding(
                                padding: EdgeInsets.all(32),
                                child: Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          IconButton(
                                            icon: Icon(Icons.arrow_back,
                                                color: Color(0xFF03045e),
                                                size: size.width * 0.08),
                                            onPressed: () =>
                                                Navigator.of(context).pop(),
                                          ),
                                        ],
                                      ),
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(
                                            0, 0, 0, 0),
                                        child: Container(
                                          height: size.height * 0.1,
                                          decoration: BoxDecoration(
                                            image: DecorationImage(
                                                image: AssetImage(
                                                    "assets/images/logo.png"),
                                                fit: BoxFit.fill),
                                          ),
                                          alignment: AlignmentDirectional(0, 0),
                                        ),
                                      ),
                                      Text(
                                        'Valor Parametros UVT'.toUpperCase(),
                                        style: TextStyle(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.black,
                                          fontSize: 20,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      listasetresponseListpagos == null
                                          ? Container()
                                          : Container(
                                              height: size.height * 0.24,
                                              child: GestureDetector(
                                                  onTap: () async {},
                                                  child: Padding(
                                                      padding: EdgeInsets.only(
                                                          left: 4,
                                                          right: 4,
                                                          top: 0),
                                                      child:

                                                          // Generated code for this CardDetails Widget...
// Generated code for this Card_Style_1-1 Widget...
                                                          Container(
                                                        width:
                                                            size.width * 0.94,
                                                        height:
                                                            size.height * 0.16,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              DecorationImage(
                                                            fit: BoxFit.cover,
                                                            image: AssetImage(
                                                                "assets/images/venta.png"),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(25),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              EdgeInsetsDirectional
                                                                  .fromSTEB(20,
                                                                      0, 20, 0),
                                                          child: Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Column(
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    'Contrato: ${listasetresponseListpagos!.contrato}'
                                                                        .toUpperCase(),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Inter Tight',
                                                                      color: Color(
                                                                          0xFFcaf0f8),
                                                                      fontSize:
                                                                          12,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                  padding: EdgeInsetsDirectional
                                                                      .fromSTEB(
                                                                          0,
                                                                          0,
                                                                          0,
                                                                          10),
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .spaceAround,
                                                                    children: [
                                                                      AnimatedButton(
                                                                          color: Colors
                                                                              .amber,
                                                                          height: size.height *
                                                                              0.07,
                                                                          width: size.width *
                                                                              0.48,
                                                                          duration:
                                                                              2,
                                                                          onPressed:
                                                                              () async {},
                                                                          child: Container(
                                                                              padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
                                                                              child: Center(
                                                                                  child: Column(
                                                                                children: [
                                                                                  Text(
                                                                                    "Valor Uvt:  ${listasetresponseListpagos!.valorUvt}",
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF0077b6),
                                                                                      fontSize: size.width * 0.034,
                                                                                      fontFamily: 'gotic',
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    "Cantidad Uvt:  ${listasetresponseListpagos!.cantidadUvt}",
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF0077b6),
                                                                                      fontSize: size.width * 0.030,
                                                                                      fontFamily: 'gotic',
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    "Valor Total:  ${listasetresponseListpagos!.valorUvt! * double.parse(listasetresponseListpagos!.cantidadUvt.toString())}",
                                                                                    style: TextStyle(
                                                                                      color: Color(0xFF0077b6),
                                                                                      fontSize: size.width * 0.030,
                                                                                      fontFamily: 'gotic',
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  )
                                                                                ],
                                                                              )))),
                                                                    ],
                                                                  )),
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                          padding: EdgeInsetsDirectional.fromSTEB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              5),
                                                                          child:
                                                                              Row(
                                                                            children: [],
                                                                          )),
                                                                      Text(
                                                                        "Nit: " +
                                                                            listasetresponseListpagos!.nit.toString(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Inter Tight',
                                                                          color:
                                                                              Color(0xFFcaf0f8),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    children: [
                                                                      Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.end,
                                                                        children: [],
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ))))
                                    ])))))
              ],
            )));
  }

  TextEditingController dniController = TextEditingController(text: "");
  Future<String> fetchShowsdelete(
      listasetpagosconvert.Promotor elemento) async {
    String jsonBody = json.encode(elemento.toJson());
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    final url = Uri.parse(
        ipController.text + "/api/PromotorInterno/RegistrarGanadorForPromotor");

    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody);

    if (response.statusCode == 200) {
      final snackBar =
          SnackBar(content: Text("Se ha confirmado la Eliminación.."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      return "si";
    } else {
      final snackBar =
          SnackBar(content: Text("No Se ha confirmado la Eliminación.."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      throw Exception('Failed to load shows');
    }
  }
}

class PromotorWidget extends StatefulWidget {
  listasetconvertpromotor.Promotor? listasetresponseList;

  PromotorWidget({
    super.key,
    required this.listasetresponseList,
  });

  @override
  State<PromotorWidget> createState() => _PromotorWidgetState();
}

class _PromotorWidgetState extends State<PromotorWidget> {
  String searchString = "";
  String searchStringproduct = "";
  String detectionInfo = "";
  DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    DateTime maxDate = _selectedDate.add(Duration(days: 365));
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: Color(0xFFe7e8e9),
        body: Stack(
          children: [
            Positioned(
              top: -130,
              left: -15,
              child: Column(
                children: [
                  Box(),
                ],
              ),
            ),
            Positioned(
              top: 340,
              left: 105,
              child: Column(
                children: [
                  Box2(),
                ],
              ),
            ),
            Align(
                alignment: AlignmentDirectional(0, 0),
                child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    constraints: BoxConstraints(
                      maxWidth: 570,
                    ),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Align(
                        alignment: AlignmentDirectional(0, 0),
                        child: Padding(
                            padding: EdgeInsets.all(32),
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Padding(
                                    padding: EdgeInsetsDirectional.fromSTEB(
                                        0, 20, 0, 0),
                                    child: Container(
                                      height: size.height * 0.1,
                                      decoration: BoxDecoration(
                                        image: DecorationImage(
                                            image: AssetImage(
                                                "assets/images/logo.png"),
                                            fit: BoxFit.fill),
                                      ),
                                      alignment: AlignmentDirectional(0, 0),
                                    ),
                                  ),
                                  widget.listasetresponseList == null
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () async {},
                                          child: Padding(
                                              padding: EdgeInsets.only(
                                                  left: 0, right: 0, top: 0),
                                              child: Container(
                                                  height: size.height * 0.74,
                                                  width: size.width,
                                                  decoration: BoxDecoration(
                                                    color: Color(0xFF023e8a)
                                                        .withOpacity(0.6),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            12),
                                                  ),
                                                  child: ListTile(
                                                    contentPadding:
                                                        EdgeInsets.only(
                                                            left: 4,
                                                            right: 4,
                                                            top: 0),
                                                    title: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween, // Alinea hacia arriba
                                                      children: [
                                                        Container(
                                                          child: Text(
                                                            'Total Clientes: ${widget.listasetresponseList!.clientes}'
                                                                .toUpperCase(),
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xFFcaf0f8),
                                                              fontSize:
                                                                  size.width *
                                                                      0.038,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                            ),
                                                          ),
                                                        ),
                                                        AnimatedButton(
                                                            color: Colors.green,
                                                            height:
                                                                size.height *
                                                                    0.06,
                                                            width: size.width *
                                                                0.4,
                                                            duration: 2,
                                                            onPressed:
                                                                () async {},
                                                            child: Container(
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        top: 0,
                                                                        left: 0,
                                                                        right:
                                                                            0,
                                                                        bottom:
                                                                            0),
                                                                child: Center(
                                                                    child: Text(
                                                                  "Total Ventas ${widget.listasetresponseList!.totalVentaGanancia!.totalVenta}",
                                                                  style:
                                                                      TextStyle(
                                                                    color: Color(
                                                                        0xFFcaf0f8),
                                                                    fontSize:
                                                                        size.width *
                                                                            0.032,
                                                                    fontFamily:
                                                                        'gotic',
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold,
                                                                  ),
                                                                )))),
                                                      ],
                                                    ),
                                                    subtitle:
                                                        SingleChildScrollView(
                                                            child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Generated code for this Column Widget...
                                                        Row(children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              2,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child: SelectionArea(
                                                                          child: Text(
                                                                        " ${widget.listasetresponseList!.crecimiento!}",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.08,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                      )),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              8,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SelectionArea(
                                                                              child: Text(
                                                                            "Crecimiento",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFFcaf0f8),
                                                                              fontSize: size.width * 0.04,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              2,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child: SelectionArea(
                                                                          child: Text(
                                                                        " ${widget.listasetresponseList!.totalVentaGanancia!.ganancias}",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.08,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                      )),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              8,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SelectionArea(
                                                                              child: Text(
                                                                            "Total",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFFcaf0f8),
                                                                              fontSize: size.width * 0.04,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          )),
                                                                          SelectionArea(
                                                                              child: Text(
                                                                            "Ganancia",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFFcaf0f8),
                                                                              fontSize: size.width * 0.04,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ]),
                                                        const Divider(
                                                          thickness:
                                                              0.4, // Grosor de la línea

                                                          height: 5,
                                                          color:
                                                              Color(0xFFe5f8ff),
                                                        ),
                                                        Row(children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              2,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child: SelectionArea(
                                                                          child: Text(
                                                                        " ${widget.listasetresponseList!.promedioIngresoMensual!}",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.08,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                      )),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              8,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SelectionArea(
                                                                              child: Text(
                                                                            "Promedio Ingreso",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFFcaf0f8),
                                                                              fontSize: size.width * 0.04,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          )),
                                                                          SelectionArea(
                                                                              child: Text(
                                                                            "Mensual",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFFcaf0f8),
                                                                              fontSize: size.width * 0.04,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              2,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child: SelectionArea(
                                                                          child: Text(
                                                                        "${widget.listasetresponseList!.totalVentaGanancia!.ganancias}",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.08,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                      )),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              8,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SelectionArea(
                                                                              child: Text(
                                                                            "Total",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFFcaf0f8),
                                                                              fontSize: size.width * 0.04,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          )),
                                                                          SelectionArea(
                                                                              child: Text(
                                                                            "Ganancia",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFFcaf0f8),
                                                                              fontSize: size.width * 0.04,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          )
                                                        ]),
                                                        const Divider(
                                                          thickness:
                                                              0.4, // Grosor de la línea

                                                          height: 5,
                                                          color:
                                                              Color(0xFFe5f8ff),
                                                        ),

                                                        Row(children: [
                                                          Column(
                                                            mainAxisSize:
                                                                MainAxisSize
                                                                    .max,
                                                            children: [
                                                              Padding(
                                                                padding:
                                                                    EdgeInsets
                                                                        .all(4),
                                                                child: Row(
                                                                  mainAxisSize:
                                                                      MainAxisSize
                                                                          .max,
                                                                  children: [
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              2,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child: SelectionArea(
                                                                          child: Text(
                                                                        "${widget.listasetresponseList!.ventaHoy!}",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.08,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w300,
                                                                        ),
                                                                      )),
                                                                    ),
                                                                    Padding(
                                                                      padding: EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                              8,
                                                                              0,
                                                                              0,
                                                                              0),
                                                                      child:
                                                                          Column(
                                                                        mainAxisSize:
                                                                            MainAxisSize.max,
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.start,
                                                                        children: [
                                                                          SelectionArea(
                                                                              child: Text(
                                                                            "Venta Hoy",
                                                                            style:
                                                                                TextStyle(
                                                                              color: Color(0xFFcaf0f8),
                                                                              fontSize: size.width * 0.04,
                                                                              letterSpacing: 0.0,
                                                                              fontWeight: FontWeight.normal,
                                                                            ),
                                                                          )),
                                                                        ],
                                                                      ),
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                            ],
                                                          ),
                                                        ]),

                                                        const Divider(
                                                          thickness:
                                                              0.4, // Grosor de la línea

                                                          height: 5,
                                                          color:
                                                              Color(0xFFe5f8ff),
                                                        ),
                                                        Column(children: [
                                                          Container(
                                                              width:
                                                                  size.width *
                                                                      0.8,
                                                              height:
                                                                  size.height *
                                                                      0.4,
                                                              child: ListView
                                                                  .builder(
                                                                      scrollDirection:
                                                                          Axis
                                                                              .vertical,
                                                                      itemCount: widget
                                                                          .listasetresponseList!
                                                                          .ventasIngresosMensuales!
                                                                          .length,
                                                                      itemBuilder:
                                                                          (context,
                                                                              index) {
                                                                        return Column(
                                                                            children: [
                                                                              Column(
                                                                                mainAxisSize: MainAxisSize.max,
                                                                                children: [
                                                                                  Padding(
                                                                                    padding: EdgeInsets.all(4),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                                                                                          child: SelectionArea(
                                                                                              child: Text(
                                                                                            "Mes:",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFFcaf0f8),
                                                                                              fontSize: size.width * 0.04,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w300,
                                                                                            ),
                                                                                          )),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              SelectionArea(
                                                                                                  child: Text(
                                                                                                "${widget.listasetresponseList!.ventasIngresosMensuales![index].mes}  ",
                                                                                                style: TextStyle(
                                                                                                  color: Color(0xFFcaf0f8),
                                                                                                  fontSize: size.width * 0.04,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                ),
                                                                                              )),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              ),
                                                                              Row(
                                                                                children: [
                                                                                  Column(
                                                                                    mainAxisSize: MainAxisSize.max,
                                                                                    children: [
                                                                                      Padding(
                                                                                        padding: EdgeInsets.all(4),
                                                                                        child: Row(
                                                                                          mainAxisSize: MainAxisSize.max,
                                                                                          children: [
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                                                                                              child: SelectionArea(
                                                                                                  child: Text(
                                                                                                "Venta:",
                                                                                                style: TextStyle(
                                                                                                  color: Color(0xFFcaf0f8),
                                                                                                  fontSize: size.width * 0.04,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.w300,
                                                                                                ),
                                                                                              )),
                                                                                            ),
                                                                                            Padding(
                                                                                              padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                                                                              child: Column(
                                                                                                mainAxisSize: MainAxisSize.max,
                                                                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                                                                children: [
                                                                                                  SelectionArea(
                                                                                                      child: Text(
                                                                                                    "${widget.listasetresponseList!.ventasIngresosMensuales![index].venta}",
                                                                                                    style: TextStyle(
                                                                                                      color: Color(0xFFcaf0f8),
                                                                                                      fontSize: size.width * 0.06,
                                                                                                      letterSpacing: 0.0,
                                                                                                      fontWeight: FontWeight.normal,
                                                                                                    ),
                                                                                                  )),
                                                                                                ],
                                                                                              ),
                                                                                            ),
                                                                                          ],
                                                                                        ),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  Padding(
                                                                                    padding: EdgeInsets.all(4),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                                                                                          child: SelectionArea(
                                                                                              child: Text(
                                                                                            " Ingreso:",
                                                                                            style: TextStyle(
                                                                                              color: Color(0xFFcaf0f8),
                                                                                              fontSize: size.width * 0.04,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w300,
                                                                                            ),
                                                                                          )),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              SelectionArea(
                                                                                                  child: Text(
                                                                                                " ${widget.listasetresponseList!.ventasIngresosMensuales![index].ingreso}",
                                                                                                style: TextStyle(
                                                                                                  color: Color(0xFFcaf0f8),
                                                                                                  fontSize: size.width * 0.04,
                                                                                                  letterSpacing: 0.0,
                                                                                                  fontWeight: FontWeight.normal,
                                                                                                ),
                                                                                              )),
                                                                                            ],
                                                                                          ),
                                                                                        ),
                                                                                      ],
                                                                                    ),
                                                                                  ),
                                                                                ],
                                                                              )
                                                                            ]);
                                                                      }))
                                                        ]),
                                                      ],
                                                    )),
                                                    onTap: () async {},
                                                  ))))
                                ])))))
          ],
        ));
  }
}

class EdicionBingo extends StatefulWidget {
  ModelCliente? datosuser;

  listasetconvert.Sala? bingo;

  listasetventasconvert.Bingo venta;
  EdicionBingo(
      {super.key,
      required this.bingo,
      required this.datosuser,
      required this.venta});

  @override
  State<EdicionBingo> createState() => _EdicionBingoState();
}

class _EdicionBingoState extends State<EdicionBingo> {
  DateTime _selectedDate = DateTime.now();

  Future<List<listasetventasconvert.Bingo>?>? listaset;
  List<listasetventasconvert.Bingo>? listasetresponseList;
  final ioc = new HttpClient();
  Future<List<listasetventasconvert.Bingo>?> fetchShows() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    String _fecha = _selectedDate.year.toString() +
        "-" +
        _selectedDate.month.toString() +
        "-" +
        _selectedDate.day.toString();

    final url = Uri.parse(ipController.text +
        "/api/PromotorInterno/GetMisVentasByPromotor?PromotorId=" +
        widget.datosuser!.promotorId.toString() +
        "&FechaCompra=" +
        _fecha);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseList =
            listasetventasconvert.salaFromMap(utf8.decode(response.bodyBytes));
      });
      await fetchShowscartilla();
      setState(() {});
      return listasetresponseList;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  Future<listasetcartillaconvert.Welcome?>? listasetcartilla;
  listasetcartillaconvert.Welcome? listasetresponseListcartilla;
  Future<listasetcartillaconvert.Welcome?> fetchShowscartilla() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    final url = Uri.parse(ipController.text +
        "/api/GrupoCartillaDetalle/GetItemNameGrupoTodos/" +
        widget.venta.codigoModulo!);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListcartilla = listasetcartillaconvert
            .welcomeFromJson(utf8.decode(response.bodyBytes));

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
              finalito = finalito + widget.bingo!.bingo.precioPorCartilla;
              _preciofinal.text = finalito.toStringAsFixed(2);
            }
            if (cantidadunique.text == "1" && _selectedIndex == 2) {
              double contador = 0;

              contador = double.parse(_controller.text) + 1;

              finalito =
                  finalito + (widget.bingo!.bingo.precioPorCartilla * contador);
              _preciofinal.text = finalito.toStringAsFixed(2);
            }
          }

          // Realiza aquí lo que necesites con cada elemento
        }
      });

      return listasetresponseListcartilla;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
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
        finalito = finalito + widget.bingo!.bingo.precioPorCartilla;
        _preciofinal.text = finalito.toStringAsFixed(2);
      }
      if (cantidadunique.text == "1" && _selectedIndex == 2) {
        double contador = 0;

        contador = double.parse(_controller.text) + 1;

        finalito =
            finalito + (widget.bingo!.bingo.precioPorCartilla * contador);
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
        finalito = finalito + widget.bingo!.bingo.precioPorCartilla;
        _preciofinal.text = finalito.toStringAsFixed(2);
      }
      if (cantidadunique.text == "1" && _selectedIndex == 2) {
        double contador = 0;

        contador = double.parse(_controller.text) + 1;

        finalito =
            finalito + (widget.bingo!.bingo.precioPorCartilla * contador);
        _preciofinal.text = finalito.toStringAsFixed(2);
      }
    }
  }

  TextEditingController _controller = TextEditingController(text: "0");
  TextEditingController _preciofinal = TextEditingController();
  List<TextEditingController> _reponse = [];
  List<TextEditingController> _reponsevalores = [];

  int _value = 0;
  int _selectedIndex = 0; // Variable para rastrear el índice del seleccionado
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Color(0xFFe7e8e9),
        body: SingleChildScrollView(
            physics: NeverScrollableScrollPhysics(),
            child: Stack(children: [
              Positioned(
                top: -130,
                left: -15,
                child: Column(
                  children: [
                    Box(),
                  ],
                ),
              ),
              Positioned(
                top: 340,
                left: 105,
                child: Column(
                  children: [
                    Box2(),
                  ],
                ),
              ),
              Align(
                  alignment: AlignmentDirectional(0, 0),
                  child: Container(
                      height: size.height,
                      width: double.infinity,
                      constraints: BoxConstraints(
                        maxWidth: 570,
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Align(
                          alignment: AlignmentDirectional(0, 0),
                          child: Padding(
                              padding: EdgeInsets.all(32),
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
                                              color: Color(0xFF03045e),
                                              size: size.width * 0.08),
                                          onPressed: () =>
                                              Navigator.of(context).pop(),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding: EdgeInsetsDirectional.fromSTEB(
                                          0, 20, 0, 0),
                                      child: Container(
                                        height: size.height * 0.1,
                                        decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: AssetImage(
                                                  "assets/images/logo.png"),
                                              fit: BoxFit.fill),
                                        ),
                                        alignment: AlignmentDirectional(0, 0),
                                      ),
                                    ),
                                    Padding(
                                        padding: EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            top: 0,
                                            bottom: 10),
                                        child: Container(
                                            width: size.width * 0.9,
                                            height: size.height * 0.44,
                                            color: Colors.transparent,
                                            child: Padding(
                                                padding: EdgeInsets.only(
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
                                                                          _reponse.length ==
                                                                              0
                                                                      ? Container()
                                                                      : Column(
                                                                          children: [
                                                                            Container(
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
                                                      widget.bingo!.bingo
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
                                                      (widget.bingo!.bingo
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
                                                        ? Color(0xFF03045e)
                                                        : Colors.black,
                                                    width: 2,
                                                  ),
                                                  color: _selectedIndex == 0
                                                      ? Color(0xFF03045e)
                                                      : Colors.transparent,
                                                ),
                                                padding: EdgeInsets.all(12),
                                                child: _selectedIndex == 0
                                                    ? Icon(Icons.check,
                                                        color:
                                                            Color(0xFFcaf0f8))
                                                    : SizedBox(),
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
                                          SizedBox(
                                              width:
                                                  3.5), // Espacio entre los "Radio Buttons"
                                          // Segundo "Radio Button"
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
                                                        widget.bingo!.bingo
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
                                                        (widget.bingo!.bingo
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
                                                          ? Color(0xFF03045e)
                                                          : Colors.black,
                                                      width: 2,
                                                    ),
                                                    color: _selectedIndex == 1
                                                        ? Color(0xFF03045e)
                                                        : Colors.transparent,
                                                  ),
                                                  padding: EdgeInsets.all(12),
                                                  child: _selectedIndex == 1
                                                      ? Icon(Icons.check,
                                                          color:
                                                              Color(0xFFcaf0f8))
                                                      : SizedBox(),
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
                                          SizedBox(
                                              width:
                                                  3.5), // Espacio entre los "Radio Buttons"
                                          // Tercer "Radio Button"
                                          GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  _selectedIndex =
                                                      2; // Establecer el índice como 2
                                                });
                                                double finalito = 0.0;
                                                _preciofinal.text = "0";
                                                for (var cantidadunique
                                                    in _reponsevalores) {
                                                  if (cantidadunique.text ==
                                                          "1" &&
                                                      _selectedIndex == 0) {
                                                    finalito = finalito +
                                                        widget.bingo!.bingo
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
                                                        (widget.bingo!.bingo
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
                                                          ? Color(0xFF03045e)
                                                          : Colors.black,
                                                      width: 2,
                                                    ),
                                                    color: _selectedIndex == 2
                                                        ? Color(0xFF03045e)
                                                        : Colors.transparent,
                                                  ),
                                                  padding: EdgeInsets.all(12),
                                                  child: _selectedIndex == 2
                                                      ? Icon(Icons.check,
                                                          color:
                                                              Color(0xFFcaf0f8))
                                                      : SizedBox(),
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
                                                      icon: Icon(Icons.remove,
                                                          color: Colors.amber),
                                                      onPressed: _decrement,
                                                    ),
                                                    Container(
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
                                                              OutlineInputBorder(),
                                                        ),
                                                        onChanged: (value) {
                                                          // Asegurarse de que el valor ingresado sea un número entero
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
                                                                      .toString(); // Reset al valor anterior
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
                                                                      .bingo
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
                                                                          .bingo
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
                                                      icon: Icon(Icons.add,
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
                                    Padding(
                                        padding: EdgeInsets.only(
                                            top: 0,
                                            left: 0,
                                            right: 0,
                                            bottom: 0),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              AnimatedButton(
                                                  color: Color(0xFF03045e),
                                                  height: size.height * 0.05,
                                                  width: size.width * 0.4,
                                                  duration: 2,
                                                  onPressed: () async {
                                                    if (_selectedIndex == 0 ||
                                                        _selectedIndex == 2 ||
                                                        _selectedIndex == 1) {
                                                      if ((_preciofinal.text ==
                                                                  "0" ||
                                                              _preciofinal
                                                                      .text ==
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
                                                              _reponsevalores[
                                                                      index]
                                                                  .text;
                                                          var cantidaduniquecartilla =
                                                              _reponse[index]
                                                                  .text;
                                                          if (cantidadunique ==
                                                              "1") {
                                                            print(
                                                                "Índice: $index, Valor: $cantidadunique");
                                                            print(
                                                                "Índice cartilla: $index, Valor: $cantidaduniquecartilla");
                                                            body.add({
                                                              "cartillaId":
                                                                  int.parse(
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
                                                        "Valor Venta: " +
                                                            _preciofinal.text,
                                                        style: TextStyle(
                                                          color:
                                                              Color(0xFFcaf0f8),
                                                          fontSize: size.width *
                                                              0.034,
                                                          fontFamily: 'gotic',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      )))),
                                            ])),
                                  ])))))
            ])));
  }

  Future<String> fetchShowsupdate(
      List<Map<String, int>> elemento, BuildContext context) async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
//List<Map<String, int>> body = listaEnteros
//     .take(cantidadMaxima) // Limitar a los primeros N elementos
//     .map((numero) => {"cartillaId": numero})
//     .toList();
//
    print(jsonEncode({
      "ventaId": widget.venta.ventaId,
      "bingoId": widget.bingo!.bingo.bingoId,
      "clienteId": 0,
      "promotorId": widget.datosuser!.promotorId,
      "codigoModulo": widget.venta.codigoModulo,
      "multiplicado": _controller.text,
      "tipo": _selectedIndex + 1,
      "ventasDetalle": elemento
    }));

    final url =
        Uri.parse(ipController.text + "/api/PromotorInterno/UpdateVentaManual");

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "ventaId": widget.venta.ventaId,
          "bingoId": widget.bingo!.bingo.bingoId,
          "clienteId": 0,
          "promotorId": widget.datosuser!.promotorId,
          "codigoModulo": widget.venta.codigoModulo,
          "multiplicado": _controller.text,
          "tipo": _selectedIndex + 1,
          "ventasDetalle": elemento
        }));

    if (response.statusCode == 200) {
      _controller.text = "0";
      final snackBar =
          SnackBar(content: Text("Se ha confirmado la Actualización.."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      Navigator.of(context).pop();

      return "si";
    } else {
      final snackBar =
          SnackBar(content: Text("No Se ha confirmado la Actualización.."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //     Navigator.of(context).pop();
      throw Exception('Failed to load shows');
    }
  }

  Widget check(TextEditingController controller, String title,
      TextEditingController valores, List<TextEditingController> cantidad) {
    Orientation deviceOrientation = MediaQuery.of(context).orientation;
    bool isLandscape = (deviceOrientation == Orientation.landscape);

    var size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.only(left: 10),
        height: size.height * 0.064,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/fongo.png"), fit: BoxFit.fill),
          border: Border.all(
              color: Color(0xFF1b6b93), width: 1.0), // Set border width
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ), // Set rounded corner radius
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                  valores.text == "1"
                      ? "Cartilla:  " + controller.text + "  - SI".toUpperCase()
                      : "Cartilla:   " +
                          controller.text +
                          "  - NO".toUpperCase(),
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.white,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              child: Container(
                  decoration: BoxDecoration(
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
                    activeColor: Color(0xffffb703),
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
                              finalito + widget.bingo!.bingo.precioPorCartilla;
                          _preciofinal.text = finalito.toStringAsFixed(2);
                        }
                        if (cantidadunique.text == "1" && _selectedIndex == 2) {
                          double contador = 0;

                          contador = double.parse(_controller.text) + 1;

                          finalito = finalito +
                              (widget.bingo!.bingo.precioPorCartilla *
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

class CreacionBingo extends StatefulWidget {
  ModelCliente? datosuser;

  listasetconvert.Sala? bingo;
  String? modulo;
  final Future<String>? Function(bool) actualizarElementos;
  CreacionBingo(
      {super.key,
      required this.bingo,
      required this.datosuser,
      required this.modulo,
      required this.actualizarElementos});

  @override
  State<CreacionBingo> createState() => _CreacionBingoState();
}

class _CreacionBingoState extends State<CreacionBingo> {
  DateTime _selectedDate = DateTime.now();

  Future<List<listasetventasconvert.Bingo>?>? listaset;
  List<listasetventasconvert.Bingo>? listasetresponseList;
  final ioc = new HttpClient();
  Future<List<listasetventasconvert.Bingo>?> fetchShows() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    String _fecha = _selectedDate.year.toString() +
        "-" +
        _selectedDate.month.toString() +
        "-" +
        _selectedDate.day.toString();

    final url = Uri.parse(ipController.text +
        "/api/PromotorInterno/GetMisVentasByPromotor?PromotorId=" +
        widget.datosuser!.promotorId.toString() +
        "&FechaCompra=" +
        _fecha);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseList =
            listasetventasconvert.salaFromMap(utf8.decode(response.bodyBytes));
      });

      return listasetresponseList;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  Future<listasetcartillaconvert.Welcome?>? listasetcartilla;
  listasetcartillaconvert.Welcome? listasetresponseListcartilla;
  Future<listasetcartillaconvert.Welcome?> fetchShowscartilla() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
    final url = Uri.parse(ipController.text +
        "/api/GrupoCartillaDetalle/GetItemNameGrupo/" +
        widget.modulo! +
        "/" +
        widget.bingo!.bingo.bingoId.toString());
    //+widget.venta.codigoModulo!+"/"+widget.venta.ventaId.toString());

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListcartilla = listasetcartillaconvert
            .welcomeFromJson(utf8.decode(response.bodyBytes));

        if (listasetresponseListcartilla!.grupoCartillas! == "") {
          final snackBar = SnackBar(
              content: Text("No Hay Cartillas disponibles para la venta.."));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        } else {
          var jsonData =
              jsonDecode(listasetresponseListcartilla!.grupoCartillas!);

          _reponse.clear();
          _reponsevalores.clear();
          for (var numero in jsonData) {
            String valor = numero.toString();
            _reponse.add(TextEditingController(text: valor));
            _reponsevalores.add(TextEditingController(text: "1"));

            // Realiza aquí lo que necesites con cada elemento
          }
          double finalito = 0.0;
          _preciofinal.text = "0";
          for (var cantidadunique in _reponsevalores) {
            if (cantidadunique.text == "1" && _selectedIndex == 0) {
              finalito = finalito + widget.bingo!.bingo.precioPorCartilla;
              _preciofinal.text = finalito.toStringAsFixed(2);
            }
            if (cantidadunique.text == "1" && _selectedIndex == 2) {
              double contador = 0;

              contador = double.parse(_controller.text) + 1;

              finalito =
                  finalito + (widget.bingo!.bingo.precioPorCartilla * contador);
              _preciofinal.text = finalito.toStringAsFixed(2);
            }
          }
        }
      });

      setState(() {});
      return listasetresponseListcartilla;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
    listasetresponseList = [];
    listasetresponseListcartilla = null;

    _reponse.clear();
    _reponsevalores.clear();
    listaset = fetchShows();
    listasetcartilla = fetchShowscartilla();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
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
        finalito = finalito + widget.bingo!.bingo.precioPorCartilla;
        _preciofinal.text = finalito.toStringAsFixed(2);
      }
      if (cantidadunique.text == "1" && _selectedIndex == 2) {
        double contador = 0;

        contador = double.parse(_controller.text) + 1;

        finalito =
            finalito + (widget.bingo!.bingo.precioPorCartilla * contador);
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
        finalito = finalito + widget.bingo!.bingo.precioPorCartilla;
        _preciofinal.text = finalito.toStringAsFixed(2);
      }
      if (cantidadunique.text == "1" && _selectedIndex == 2) {
        double contador = 0;

        contador = double.parse(_controller.text) + 1;

        finalito =
            finalito + (widget.bingo!.bingo.precioPorCartilla * contador);
        _preciofinal.text = finalito.toStringAsFixed(2);
      }
    }
  }

  TextEditingController _controller = TextEditingController(text: "0");
  TextEditingController _preciofinal = TextEditingController();
  List<TextEditingController> _reponse = [];
  List<TextEditingController> _reponsevalores = [];

  int _value = 0;
  int _selectedIndex = 0; // Variable para rastrear el índice del seleccionado

  List<listasetconvert.Sala>? listasetresponseListbingo;

  Future<List<listasetconvert.Sala>?> fetchShowsbingo() async {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(widget.bingo!.bingo.fecha);

    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);

    final url = Uri.parse(ipController.text +
        "/api/BingoPremioDetalleInterno/GetAll?Estado=1&FechaInicio=" +
        formattedDate);

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListbingo =
            listasetconvert.salaFromMap(utf8.decode(response.bodyBytes));
        var resultado = listasetresponseListbingo!.firstWhere(
          (elemento) => elemento.bingo.bingoId == widget.bingo!.bingo.bingoId,
        );

        if (resultado != null) {
          print("Elemento encontrado: ${resultado.bingo.bingoId}");
          setState(() {
            widget.bingo = resultado;
          });
        } else {}
      });

      return listasetresponseListbingo;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.transparent,
        body: SingleChildScrollView(
            child: Column(children: [
          Padding(
              padding: EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
              child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                      padding:
                          EdgeInsets.only(left: 0, right: 0, top: 0, bottom: 0),
                      child: Column(
                        children: [
                          Column(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                    height: size.height * 0.36,
                                    width: size.width * 0.84,
                                    child: Column(
                                      children: [
                                        _reponse == null || _reponse.length == 0
                                            ? Container()
                                            : Column(
                                                children: [
                                                  Container(
                                                      height:
                                                          size.height * 0.36,
                                                      child: ListView.builder(
                                                          scrollDirection:
                                                              Axis.vertical,
                                                          itemCount:
                                                              _reponse.length,
                                                          itemBuilder:
                                                              (context, index) {
                                                            return check(
                                                                _reponse[index],
                                                                _reponse[index]
                                                                    .text,
                                                                _reponsevalores[
                                                                    index],
                                                                _reponsevalores);
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Primer "Radio Button"
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedIndex = 0; // Establecer el índice como 0
                    });
                    double finalito = 0.0;
                    _preciofinal.text = "0";
                    for (var cantidadunique in _reponsevalores) {
                      if (cantidadunique.text == "1" && _selectedIndex == 0) {
                        finalito =
                            finalito + widget.bingo!.bingo.precioPorCartilla;
                        _preciofinal.text = finalito.toStringAsFixed(2);
                      }
                      if (cantidadunique.text == "1" && _selectedIndex == 2) {
                        double contador = 0;

                        contador = double.parse(_controller.text) + 1;

                        finalito = finalito +
                            (widget.bingo!.bingo.precioPorCartilla * contador);
                        _preciofinal.text = finalito.toStringAsFixed(2);
                      }
                    }
                  },
                  child: Column(children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: _selectedIndex == 0
                              ? Color(0xFF03045e)
                              : Colors.black,
                          width: 2,
                        ),
                        color: _selectedIndex == 0
                            ? Color(0xFF03045e)
                            : Colors.transparent,
                      ),
                      padding: EdgeInsets.all(12),
                      child: _selectedIndex == 0
                          ? Icon(Icons.check, color: Color(0xFFcaf0f8))
                          : SizedBox(),
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
                SizedBox(width: 3.5), // Espacio entre los "Radio Buttons"
                // Segundo "Radio Button"
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 1; // Establecer el índice como 1
                      });
                      double finalito = 0.0;
                      _preciofinal.text = "0";
                      for (var cantidadunique in _reponsevalores) {
                        if (cantidadunique.text == "1" && _selectedIndex == 0) {
                          finalito =
                              finalito + widget.bingo!.bingo.precioPorCartilla;
                          _preciofinal.text = finalito.toStringAsFixed(2);
                        }
                        if (cantidadunique.text == "1" && _selectedIndex == 2) {
                          double contador = 0;

                          contador = double.parse(_controller.text) + 1;

                          finalito = finalito +
                              (widget.bingo!.bingo.precioPorCartilla *
                                  contador);
                          _preciofinal.text = finalito.toStringAsFixed(2);
                        }
                      }
                    },
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedIndex == 1
                                ? Color(0xFF03045e)
                                : Colors.black,
                            width: 2,
                          ),
                          color: _selectedIndex == 1
                              ? Color(0xFF03045e)
                              : Colors.transparent,
                        ),
                        padding: EdgeInsets.all(12),
                        child: _selectedIndex == 1
                            ? Icon(Icons.check, color: Color(0xFFcaf0f8))
                            : SizedBox(),
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
                      ))
                    ])),
                SizedBox(width: 3.5), // Espacio entre los "Radio Buttons"
                // Tercer "Radio Button"
                GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedIndex = 2; // Establecer el índice como 2
                      });
                      double finalito = 0.0;
                      _preciofinal.text = "0";
                      for (var cantidadunique in _reponsevalores) {
                        if (cantidadunique.text == "1" && _selectedIndex == 0) {
                          finalito =
                              finalito + widget.bingo!.bingo.precioPorCartilla;
                          _preciofinal.text = finalito.toStringAsFixed(2);
                        }
                        if (cantidadunique.text == "1" && _selectedIndex == 2) {
                          double contador = 0;

                          contador = double.parse(_controller.text) + 1;

                          finalito = finalito +
                              (widget.bingo!.bingo.precioPorCartilla *
                                  contador);
                          _preciofinal.text = finalito.toStringAsFixed(2);
                        }
                      }
                    },
                    child: Column(children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: _selectedIndex == 2
                                ? Color(0xFF03045e)
                                : Colors.black,
                            width: 2,
                          ),
                          color: _selectedIndex == 2
                              ? Color(0xFF03045e)
                              : Colors.transparent,
                        ),
                        padding: EdgeInsets.all(12),
                        child: _selectedIndex == 2
                            ? Icon(Icons.check, color: Color(0xFFcaf0f8))
                            : SizedBox(),
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
                      ))
                    ])),
                _selectedIndex == 2
                    ? Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.remove, color: Colors.amber),
                            onPressed: _decrement,
                          ),
                          Container(
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
                                border: OutlineInputBorder(),
                              ),
                              onChanged: (value) {
                                // Asegurarse de que el valor ingresado sea un número entero
                                if (value.isNotEmpty) {
                                  int? newValue = int.tryParse(value);
                                  if (newValue != null && newValue >= 0) {
                                    setState(() {
                                      _value = newValue;
                                    });
                                  } else {
                                    _controller.text = _value
                                        .toString(); // Reset al valor anterior
                                  }
                                }

                                double finalito = 0.0;
                                _preciofinal.text = "0";
                                for (var cantidadunique in _reponsevalores) {
                                  if (cantidadunique.text == "1" &&
                                      _selectedIndex == 0) {
                                    finalito = finalito +
                                        widget.bingo!.bingo.precioPorCartilla;
                                    _preciofinal.text =
                                        finalito.toStringAsFixed(2);
                                  }
                                  if (cantidadunique.text == "1" &&
                                      _selectedIndex == 2) {
                                    double contador = 0;

                                    contador =
                                        double.parse(_controller.text) + 1;

                                    finalito = finalito +
                                        (widget.bingo!.bingo.precioPorCartilla *
                                            contador);
                                    _preciofinal.text =
                                        finalito.toStringAsFixed(2);
                                  }
                                }
                              },
                            ),
                          ),
                          IconButton(
                            icon: Icon(Icons.add, color: Colors.amber),
                            onPressed: _increment,
                          ),
                        ],
                      )
                    : Container(),
              ],
            ),
          ),
          Padding(
              padding: EdgeInsets.only(top: 4, left: 0, right: 0, bottom: 0),
              child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedButton(
                        color: Color(0xFF03045e),
                        height: size.height * 0.05,
                        width: size.width * 0.4,
                        duration: 2,
                        onPressed: () async {
                          var size = MediaQuery.of(context).size;
                          await fetchShowsbingo();
                          if (widget.bingo!.bingo.estado == 2 ||
                              widget.bingo!.bingo.estado == 3) {
                            showAlerta(context, 'Mensaje Informativo',
                                'Para ventas el bingo debe estar en un estado diferente de jugando!!');
                          } else {
                            if (_selectedIndex == 0 ||
                                _selectedIndex == 2 ||
                                _selectedIndex == 1) {
                              if ((_preciofinal.text == "0" ||
                                      _preciofinal.text == "") &&
                                  _selectedIndex != 1) {
                                showAlerta(context, 'Mensaje Informativo',
                                    'Para ventas debes seleccionar una cartilla!!');
                              } else {
                                List<Map<String, int>> body = [];
                                for (int index = 0;
                                    index < _reponsevalores.length;
                                    index++) {
                                  var cantidadunique =
                                      _reponsevalores[index].text;
                                  var cantidaduniquecartilla =
                                      _reponse[index].text;
                                  if (cantidadunique == "1") {
                                    print(
                                        "Índice: $index, Valor: $cantidadunique");
                                    print(
                                        "Índice cartilla: $index, Valor: $cantidaduniquecartilla");
                                    body.add({
                                      "cartillaId":
                                          int.parse(cantidaduniquecartilla)
                                    });
                                  }
                                }

                                await fetchShowsupdate(body, context);
                                await fetchShows();
                              }
                            }
                          }
                          setState(() {});
                        },
                        child: Container(
                            padding: const EdgeInsets.only(
                                top: 0, left: 0, right: 0, bottom: 0),
                            child: Center(
                                child: Text(
                              "Valor Venta: " + _preciofinal.text,
                              style: TextStyle(
                                color: Color(0xFFcaf0f8),
                                fontSize: size.width * 0.034,
                                fontFamily: 'gotic',
                                fontWeight: FontWeight.bold,
                              ),
                            )))),
                  ])),
        ])));
  }

  Future<String> fetchShowsupdate(
      List<Map<String, int>> elemento, BuildContext context) async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = new IOClient(ioc);
//List<Map<String, int>> body = listaEnteros
//     .take(cantidadMaxima) // Limitar a los primeros N elementos
//     .map((numero) => {"cartillaId": numero})
//     .toList();
//
    print(jsonEncode({
      "ventaId": 0,
      "bingoId": widget.bingo!.bingo.bingoId,
      "clienteId": 0,
      "promotorId": widget.datosuser!.promotorId,
      "codigoModulo": widget.modulo!,
      "multiplicado": _controller.text,
      "tipo": _selectedIndex + 1,
      "ventasDetalle": elemento
    }));

    final url =
        Uri.parse(ipController.text + "/api/PromotorInterno/PostVentaManual");

    final response = await http.post(url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          "ventaId": 0,
          "bingoId": widget.bingo!.bingo.bingoId,
          "clienteId": 0,
          "promotorId": widget.datosuser!.promotorId,
          "codigoModulo": widget.modulo!,
          "multiplicado": _controller.text,
          "tipo": _selectedIndex + 1,
          "ventasDetalle": elemento
        }));

    if (response.statusCode == 200) {
      _controller.text = "0";
      final snackBar = SnackBar(content: Text("Se ha confirmado la venta.."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      var a = widget.actualizarElementos(true);
      return "si";
    } else {
      final snackBar =
          SnackBar(content: Text("No Se ha confirmado la venta.."));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      //     Navigator.of(context).pop();
      throw Exception('Failed to load shows');
    }
  }

  Widget check(TextEditingController controller, String title,
      TextEditingController valores, List<TextEditingController> cantidad) {
    Orientation deviceOrientation = MediaQuery.of(context).orientation;
    bool isLandscape = (deviceOrientation == Orientation.landscape);

    var size = MediaQuery.of(context).size;
    return Container(
        padding: EdgeInsets.only(left: 10),
        height: size.height * 0.06,
        width: size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/fongo.png"), fit: BoxFit.fill),
          border: Border.all(
              color: Color(0xFF1b6b93), width: 1.0), // Set border width
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            bottomLeft: Radius.circular(20),
            topLeft: Radius.circular(20),
            bottomRight: Radius.circular(20),
          ), // Set rounded corner radius
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Center(
              child: Text(
                  valores.text == "1"
                      ? "Cartilla:  " + controller.text + "  - SI".toUpperCase()
                      : "Cartilla:   " +
                          controller.text +
                          "  - NO".toUpperCase(),
                  style: TextStyle(
                    fontSize: size.width * 0.05,
                    color: Colors.white,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  )),
            ),
            Padding(
              padding: EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 0.0),
              child: Container(
                  decoration: BoxDecoration(
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
                    activeColor: Color(0xffffb703),
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
                              finalito + widget.bingo!.bingo.precioPorCartilla;
                          _preciofinal.text = finalito.toStringAsFixed(2);
                        }
                        if (cantidadunique.text == "1" && _selectedIndex == 2) {
                          double contador = 0;

                          contador = double.parse(_controller.text) + 1;

                          finalito = finalito +
                              (widget.bingo!.bingo.precioPorCartilla *
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

class VentasDetalle {
  int? cartillaId;

  VentasDetalle({
    this.cartillaId,
  });

  factory VentasDetalle.fromJson(Map<String, dynamic> json) => VentasDetalle(
        cartillaId: json["cartillaId"],
      );

  Map<String, dynamic> toJson() => {
        "cartillaId": cartillaId,
      };
}

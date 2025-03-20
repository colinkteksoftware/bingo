import 'dart:convert';
import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:bingo/models/modelCliente.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/models/pagosconvert.dart';
import 'package:bingo/models/uvtconvert.dart';
import 'package:bingo/utils/custom_back_button.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

class UvtWidget extends StatefulWidget {
  ModelCliente? datosuser;

  UvtWidget({super.key, required this.datosuser});

  @override
  State<UvtWidget> createState() => _UvtWidgetState();
}

class _UvtWidgetState extends State<UvtWidget> {
  String searchString = "";
  String searchStringproduct = "";
  String detectionInfo = "";
  final DateTime _selectedDate = DateTime.now();
  final ioc = HttpClient();
  final pf = Preferencias();
  Future<Uvt?>? listaset;
  Uvt? listasetresponseListpagos;

  Future<Uvt?> fetchShows() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    String _fecha =
        "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";

    final url = Uri.parse("${pf.getIp.toString()}/api/ParametroInterno/GetAll");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListpagos =
            uvtFromJson(utf8.decode(response.bodyBytes));
      });

      return listasetresponseListpagos;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
    //await pf.initPrefs();
    listaset = fetchShows();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //DateTime maxDate = _selectedDate.add(const Duration(days: 365));
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
                                      const SizedBox(height: 8),
                                      Text(
                                        'Valor Parametros UVT'.toUpperCase(),
                                        style: const TextStyle(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.black,
                                          fontSize: 20,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      listasetresponseListpagos == null
                                          ? Container()
                                          : SizedBox(
                                              height: size.height * 0.24,
                                              child: GestureDetector(
                                                  onTap: () async {},
                                                  child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 4,
                                                              right: 4,
                                                              top: 0),
                                                      child: Container(
                                                        width:
                                                            size.width * 0.94,
                                                        height:
                                                            size.height * 0.16,
                                                        decoration:
                                                            BoxDecoration(
                                                          image:
                                                              const DecorationImage(
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
                                                              const EdgeInsetsDirectional
                                                                  .fromSTEB(
                                                                  20, 0, 20, 0),
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
                                                                  Center(
                                                                    child: Text(
                                                                      'Contrato: ${listasetresponseListpagos!.contrato}'
                                                                          .toUpperCase(),
                                                                      style:
                                                                          const TextStyle(
                                                                        fontFamily:
                                                                            'Inter Tight',
                                                                        color: Color(
                                                                            0xFFcaf0f8),
                                                                        fontSize:
                                                                            12,
                                                                        letterSpacing:
                                                                            0.0,
                                                                        fontWeight:
                                                                            FontWeight.w800,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                  height: 8),
                                                              Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
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
                                                                              0.08,
                                                                          width: size.width *
                                                                              0.48,
                                                                          duration:
                                                                              2,
                                                                          onPressed:
                                                                              () async {},
                                                                          child: Container(
                                                                              padding: const EdgeInsets.only(top: 5),
                                                                              child: Center(
                                                                                  child: Column(
                                                                                children: [
                                                                                  Text(
                                                                                    "Valor Uvt: ${listasetresponseListpagos!.valorUvt}",
                                                                                    style: TextStyle(
                                                                                      color: const Color(0xFF0077b6),
                                                                                      fontSize: size.width * 0.034,
                                                                                      fontFamily: 'gotic',
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    "Cantidad Uvt: ${listasetresponseListpagos!.cantidadUvt}",
                                                                                    style: TextStyle(
                                                                                      color: const Color(0xFF0077b6),
                                                                                      fontSize: size.width * 0.030,
                                                                                      fontFamily: 'gotic',
                                                                                      fontWeight: FontWeight.bold,
                                                                                    ),
                                                                                  ),
                                                                                  Text(
                                                                                    "Valor Total: ${listasetresponseListpagos!.valorUvt! * double.parse(listasetresponseListpagos!.cantidadUvt.toString())}",
                                                                                    style: TextStyle(
                                                                                      color: const Color(0xFF0077b6),
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
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      const Padding(
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
                                                                        "Nit: ${listasetresponseListpagos!.nit}",
                                                                        style:
                                                                            const TextStyle(
                                                                          fontFamily:
                                                                              'Inter Tight',
                                                                          color:
                                                                              Color(0xFFcaf0f8),
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w600,
                                                                        ),
                                                                        textAlign: TextAlign.center,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                  const Column(
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
                                    ]))))),
                                    const BackButtonWidget(),
              ],
            )));
  }

  TextEditingController dniController = TextEditingController(text: "");
  Future<String> fetchShowsdelete(Pago elemento) async {
    String jsonBody = json.encode(elemento.toJson());
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    final url = Uri.parse(
        "${pf.getIp.toString()}/api/PromotorInterno/RegistrarGanadorForPromotor");

    final response = await http.put(url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonBody);

    if (response.statusCode == 200) {
      const snackBar = SnackBar(
        content: Center(child: Text("Se ha confirmado la eliminación..")),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      return "si";
    } else {
      const snackBar = SnackBar(
        content: Center(child: Text("No se ha confirmado la eliminación..")),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      throw Exception('Failed to load shows');
    }
  }
}

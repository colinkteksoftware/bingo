import 'dart:convert';
import 'dart:io';

import 'package:animated_button/animated_button.dart';
import 'package:bingo/models/modelCliente.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/models/clienteconvert.dart';
import 'package:bingo/models/pagosconvert.dart';
import 'package:bingo/utils/custom_back_button.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

class CustomerWidget extends StatefulWidget {
  ModelCliente? datosuser;

  CustomerWidget({super.key, required this.datosuser});

  @override
  State<CustomerWidget> createState() => _CustomerWidgetState();
}

class _CustomerWidgetState extends State<CustomerWidget> {
  String searchString = "";
  String searchStringproduct = "";
  String detectionInfo = "";
  final DateTime _selectedDate = DateTime.now();
  final ioc = HttpClient();
  final pf = Preferencias();
  Future<Cliente?>? listaset;
  Cliente? customer;
  bool finded = false;

  Future<Cliente?> findByDocument() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);

    final url = Uri.parse(
        "${pf.getIp.toString()}/api/ClienteInterno/GetClienteByDocumento/${dniController.text}");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Cliente data = clienteFromJson(utf8.decode(response.bodyBytes));

      if (data.clienteId != 0) {
        setState(() {
          customer = data;
          finded = true;
        });
      } else {
        setState(() {
          customer = null;
          finded = false;
        });
      }

      return customer;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
    //await pf.initPrefs();
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
                                      Padding(
                                        padding: const EdgeInsetsDirectional
                                            .fromSTEB(0, 0, 0, 0),
                                        child: Container(
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
                                      ),
                                      const SizedBox(height: 8),
                                      Text(
                                        'Cliente'.toUpperCase(),
                                        style: const TextStyle(
                                          fontFamily: 'Inter Tight',
                                          color: Colors.black,
                                          fontSize: 20,
                                          letterSpacing: 0.0,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .center,
                                        children: [
                                          SizedBox(
                                            width: size.width * 0.58,
                                            height: size.height * 0.08,
                                            child: TextField(
                                              controller: dniController,
                                              style: TextStyle(
                                                color: const Color(0xFF424242),
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
                                                  color:
                                                      const Color(0xFF424242),
                                                  fontSize: size.width * 0.04,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                    color: Color(0xFF03045e),
                                                    width: 2.0,
                                                  ),
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
                                          ),
                                          const SizedBox(
                                              width:
                                                  5),
                                          InkWell(
                                            onTap: () {
                                              setState(() {
                                                listaset = null;
                                                finded = false;
                                              });

                                              if (dniController.text == "") {
                                                const snackBar = SnackBar(
                                                  content: Center(
                                                    child: Text(
                                                        "Ingrese un DNI valido.."),
                                                  ),
                                                );
                                                ScaffoldMessenger.of(context)
                                                    .showSnackBar(snackBar);
                                              } else {
                                                setState(() {
                                                  listaset = findByDocument();
                                                });

                                                setState(() {
                                                  // order.detallePremioFigura!.first.estadoPago = 1;
                                                });
                                              }

                                              setState(() {});
                                            },
                                            splashColor:
                                                Colors.blue.withAlpha(30),
                                            highlightColor:
                                                Colors.blue.withAlpha(50),
                                            borderRadius:
                                                BorderRadius.circular(20),
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(12.0),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFF03045e),
                                                  width: 2.0,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withOpacity(0.1),
                                                    blurRadius: 5,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: const Icon(
                                                Icons.search,
                                                size: 20.0,
                                                color: Color(0xFF03045e),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),                                      
                                      !finded && customer == null
                                          ? const Center(
                                              child: Text(
                                                'Cliente no encontrado',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    color: Color(0xFF03045e),
                                                    fontSize: 20),
                                              ),
                                            )
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
                                                                  0, 10, 0, 0),
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
                                                                                  "Nombre:  ${customer?.nombres ?? ''}",
                                                                                  style: TextStyle(
                                                                                    color: const Color(0xFF0077b6),
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
                                                                                  "Apellidos:  ${customer?.apellidos ?? ''}",
                                                                                  style: TextStyle(
                                                                                    color: const Color(0xFF0077b6),
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
                                                                                  "Documento:  ${customer?.doi ?? ''}",
                                                                                  style: TextStyle(
                                                                                    color: const Color(0xFF0077b6),
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
                                                                                  "Documento:  ${customer?.doi ?? ''}",
                                                                                  style: TextStyle(
                                                                                    color: const Color(0xFF0077b6),
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
                                                                                  "Telefono:  ${customer?.telefono ?? ''}",
                                                                                  style: TextStyle(
                                                                                    color: const Color(0xFF0077b6),
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
                                                                                  "Correo:  ${customer?.email ?? ''}",
                                                                                  style: TextStyle(
                                                                                    color: const Color(0xFF0077b6),
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
                                                                                  "Direccion:  ${customer?.direccion ?? ''}",
                                                                                  style: TextStyle(
                                                                                    color: const Color(0xFF0077b6),
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
        content: Center(child: Text("No se ha confirmado la Eliminación..")),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      throw Exception('Failed to load shows');
    }
  }
}

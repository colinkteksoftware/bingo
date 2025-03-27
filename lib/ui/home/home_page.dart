import 'dart:io';
import 'package:bingo/providers/home_provider.dart';
import 'package:bingo/ui/bingo/widgets/bingo_create.dart';
import 'package:bingo/ui/home/widgets/customer_widget.dart';
import 'package:bingo/ui/home/widgets/payment_widget.dart';
import 'package:bingo/ui/home/widgets/uvt_widget.dart';
import 'package:bingo/ui/home/widgets/sale_widget.dart';
import 'package:bingo/utils/background.dart';
import 'package:animated_button/animated_button.dart';
import 'package:bingo/ui/home/widgets/headers_options.dart';
import 'package:bingo/models/bingoconvert.dart';
import 'package:bingo/utils/camera_permission.dart';
import 'package:bingo/utils/custom_back_button.dart';
import 'package:flutter/material.dart';
import 'package:bingo/models/modelCliente.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:provider/provider.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

late Future<void> _initializeControllerFuture;

// ignore: must_be_immutable
class HomePage extends StatefulWidget {
  ModelCliente? datosuser;
  Bingo? bingo;
  HomePage({super.key, required this.bingo, required this.datosuser});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  
  TextEditingController? qrcodeController = TextEditingController(text: "-1");

  @override
  void initState() {
    super.initState();
    _controller.text = _value.toString();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      PermissionUtils.requestCameraPermission(context);
      initializeCameras();
    });
  }

  Future<void> initializeCameras() async {
    if (await Permission.camera.isDenied) {
      PermissionUtils.requestCameraPermission(context);
    }
    if (await Permission.camera.isDenied) {
      PermissionUtils.requestCameraPermission(context);
    }
    try {} catch (e) {
      openAppSettings();

      print('Error initializing camera: $e');
    }
  }

  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFcaf0f8), Color(0xFF00b4d8)],
          stops: [0.3, 0.9]));

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    final homeProvider = Provider.of<HomeProvider>(context);
    final bingoList = homeProvider.bingoList;
    final isLoading = homeProvider.isLoading;
    final errorMessage = homeProvider.errorMessage;
    return Scaffold(
      body: SafeArea(
          top: true,
          child: Container(
            height: double.infinity,
            width: size.width,
            decoration: const BoxDecoration(
              color: Color(0xFFcaf0f8),
            ),
            alignment: const AlignmentDirectional(0.0, -1.0),
            child: SingleChildScrollView(
                child: Stack(
              children: <Widget>[
                Container(
                  decoration: boxDecoration,
                ),
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
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            Column(
                                              children: [
                                                Text(
                                                  "Bienvenido: ${widget.datosuser!.nombres!}",
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF03045e),
                                                    fontSize: size.width * 0.03,
                                                    fontFamily: 'gotic',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                Text(
                                                  'Usuario: ${widget.datosuser!.usuario!.toString()}',
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFF03045e),
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
                                                            color: const Color(
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
                                                                  return PaymentWidget(
                                                                      datosuser:
                                                                          widget
                                                                              .datosuser,
                                                                      bingo: widget
                                                                          .bingo!);
                                                                },
                                                              );
                                                              setState(() {});
                                                            },
                                                            child:
                                                                HeadersOptionsWidget(
                                                                    size:
                                                                        size)),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.05,
                                                        ),
                                                        AnimatedButton(
                                                            color: const Color(
                                                                0xFF03045e),
                                                            height:
                                                                size.height *
                                                                    0.05,
                                                            width: size.width *
                                                                0.16,
                                                            duration: 2,
                                                            onPressed:
                                                                () async {
                                                              //await fetchShowsbingo();

                                                              /* inicio */

                                                              Center(
                                                                child: isLoading
                                                                    ? const CircularProgressIndicator()
                                                                    : errorMessage !=
                                                                            null
                                                                        ? Text(
                                                                            errorMessage!)
                                                                        : bingoList == null ||
                                                                                bingoList.isEmpty
                                                                            ? const Text('No hay bingo disponibles')
                                                                            : ListView.builder(
                                                                                itemCount: bingoList.length,
                                                                                itemBuilder: (context, index) {
                                                                                  final bingoSala = bingoList[index];
                                                                                  return ListTile(
                                                                                    title: Text('ID: ${bingoSala.bingo.bingoId}'),
                                                                                    subtitle: Text('${bingoSala.bingo.fecha}'),
                                                                                  );
                                                                                },
                                                                              ),
                                                              );

                                                              /* fin */

                                                              if (widget.bingo!
                                                                      .estado ==
                                                                  3) {
                                                                showAlerta(
                                                                    context,
                                                                    'Juego Finalizado',
                                                                    'El bingo ya ha sido finalizado!!!');
                                                              }
                                                              else {
                                                                await showDialog(
                                                                  context:
                                                                      context,
                                                                  builder:
                                                                      (BuildContext
                                                                          context) {
                                                                    return SaleWidget(
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
                                                            child: Center(
                                                                child: Text(
                                                              "Ventas",
                                                              style: TextStyle(
                                                                color: const Color(
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
                                                            ))),
                                                        SizedBox(
                                                          width:
                                                              size.width * 0.05,
                                                        ),
                                                        AnimatedButton(
                                                            color: const Color(
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
                                                                              .datosuser);
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
                                                                    color: const Color(
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
                                                            color: const Color(
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
                                                                  return CustomerWidget(
                                                                      datosuser:
                                                                          widget
                                                                              .datosuser);
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
                                                                    color: const Color(
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
                                        child: Container(
                                          height: qrcodeController!.text != "-1"
                                              ? size.height * 0.15
                                              : size.height * 0.15,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Container(
                                                  height:
                                                      qrcodeController!.text !=
                                                              "-1"
                                                          ? size.height * 0.15
                                                          : size.height * 0.15,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30),
                                                    image: DecorationImage(
                                                      image: const AssetImage(
                                                          'assets/images/bingo.jpg'),
                                                      fit: BoxFit.cover,
                                                      colorFilter:
                                                          ColorFilter.mode(
                                                        Colors.black
                                                            .withOpacity(0.4),
                                                        BlendMode.darken,
                                                      ),
                                                    ),
                                                  ),
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        width: size.width * 0.6,
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                left: 10,
                                                                right: 10),
                                                        decoration:
                                                            BoxDecoration(
                                                          color: Colors.black
                                                              .withOpacity(0.4),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(8),
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
                                                              Row(
                                                                mainAxisSize:
                                                                    MainAxisSize
                                                                        .max,
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .spaceBetween,
                                                                children: [
                                                                  Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      Padding(
                                                                        padding: const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            0,
                                                                            2,
                                                                            0,
                                                                            2),
                                                                        child:
                                                                            Text(
                                                                          'Bingo ID',
                                                                          style:
                                                                              TextStyle(
                                                                            fontFamily:
                                                                                'Cera Pro',
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize:
                                                                                size.width * 0.030,
                                                                            letterSpacing:
                                                                                0.0,
                                                                            fontWeight:
                                                                                FontWeight.w500,
                                                                          ),
                                                                        ),
                                                                      ),
                                                                      Text(
                                                                        '${widget.bingo!.bingoId}'
                                                                            .toUpperCase(),
                                                                        style:
                                                                            TextStyle(
                                                                          fontFamily:
                                                                              'Cera Pro',
                                                                          color:
                                                                              Colors.white,
                                                                          fontSize:
                                                                              size.width * 0.050,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.w500,
                                                                        ),
                                                                      ),
                                                                    ],
                                                                  ),
                                                                ],
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsetsDirectional
                                                                        .fromSTEB(
                                                                        0,
                                                                        0,
                                                                        25,
                                                                        0),
                                                                child: Text(
                                                                  'Valor \$${widget.bingo!.precioPorCartilla.toStringAsFixed(2)}',
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
                                                                        FontWeight
                                                                            .w500,
                                                                  ),
                                                                ),
                                                              ),
                                                              Row(
                                                                children: [
                                                                  Text(
                                                                    widget
                                                                        .bingo!
                                                                        .fecha
                                                                        .toString()
                                                                        .substring(
                                                                            0,
                                                                            16),
                                                                    style:
                                                                        TextStyle(
                                                                      fontFamily:
                                                                          'Gilroy',
                                                                      color: Colors
                                                                          .white,
                                                                      fontSize:
                                                                          size.width *
                                                                              0.030,
                                                                      letterSpacing:
                                                                          1.5,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w500,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ),
                                                      widget.bingo!.estado ==
                                                                  1 ||
                                                              widget.bingo!
                                                                      .estado ==
                                                                  2
                                                          ? Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 10,
                                                                      right:
                                                                          10),
                                                              child:
                                                                  GestureDetector(
                                                                onTap:
                                                                    () async {
                                                                  //await fetchShowsbingo();

                                                                  /* inicio */

                                                                  Center(
                                                                    child: isLoading
                                                                        ? const CircularProgressIndicator()
                                                                        : errorMessage != null
                                                                            ? Text(errorMessage!)
                                                                            : bingoList == null || bingoList.isEmpty
                                                                                ? const Text('No hay bingo disponibles')
                                                                                : ListView.builder(
                                                                                    itemCount: bingoList.length,
                                                                                    itemBuilder: (context, index) {
                                                                                      final bingoSala = bingoList[index];
                                                                                      return ListTile(
                                                                                        title: Text('ID: ${bingoSala.bingo.bingoId}'),
                                                                                        subtitle: Text('${bingoSala.bingo.fecha}'),
                                                                                      );
                                                                                    },
                                                                                  ),
                                                                  );

                                                                  /* fin */

                                                                  if (/*widget.bingo!
                                                                              .estado ==
                                                                          2 ||*/
                                                                      widget.bingo!
                                                                              .estado ==
                                                                          3) {
                                                                    showAlerta(
                                                                      context,
                                                                      'Mensaje Informativo',
                                                                      'El bingo ya se encuentra finalizado',
                                                                    );
                                                                  } else {
                                                                    qrcodeController!
                                                                            .text =
                                                                        "-1";
                                                                    setState(
                                                                        () {});
                                                                    final PermissionStatus
                                                                        status =
                                                                        await Permission
                                                                            .camera
                                                                            .request();
                                                                    if (status
                                                                        .isDenied) {
                                                                      await _initializeControllerFuture;
                                                                    } else {
                                                                      var res =
                                                                          await Navigator
                                                                              .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                          builder: (context) =>
                                                                              const SimpleBarcodeScannerPage(),
                                                                        ),
                                                                      );
                                                                      setState(
                                                                          () {
                                                                        if (res ==
                                                                            "-1") {
                                                                          setState(
                                                                              () {});
                                                                        } else {
                                                                          qrcodeController!.text =
                                                                              res;
                                                                        }
                                                                      });
                                                                    }
                                                                  }
                                                                },
                                                                child: widget.bingo!.estado ==
                                                                            1 ||
                                                                        widget.bingo!.estado ==
                                                                            2
                                                                    ? Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.qr_code,
                                                                            color:
                                                                                Colors.white,
                                                                            size:
                                                                                size.width * 0.14,
                                                                          ),
                                                                        ],
                                                                      )
                                                                    : const SizedBox(),
                                                              ),
                                                            )
                                                          : widget.bingo!
                                                                      .estado ==
                                                                  3
                                                              ? Padding(
                                                                  padding: const EdgeInsets
                                                                      .only(
                                                                      left:
                                                                          10.0,
                                                                      right:
                                                                          10),
                                                                  child: Column(
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .center,
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Icon(
                                                                        Icons
                                                                            .monetization_on_outlined,
                                                                        color: Colors
                                                                            .green[600],
                                                                        size: size.width *
                                                                            0.14,
                                                                      ),
                                                                    ],
                                                                  ),
                                                                )
                                                              : widget.bingo!
                                                                          .estado ==
                                                                      3
                                                                  ? Padding(
                                                                      padding: const EdgeInsets
                                                                          .only(
                                                                          left:
                                                                              10.0,
                                                                          right:
                                                                              10),
                                                                      child:
                                                                          Column(
                                                                        crossAxisAlignment:
                                                                            CrossAxisAlignment.center,
                                                                        mainAxisAlignment:
                                                                            MainAxisAlignment.center,
                                                                        children: [
                                                                          Icon(
                                                                            Icons.cancel_outlined,
                                                                            color:
                                                                                Colors.red[600],
                                                                            size:
                                                                                size.width * 0.14,
                                                                          ),
                                                                        ],
                                                                      ),
                                                                    )
                                                                  : const SizedBox(),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 5),
                                      SingleChildScrollView(
                                          child: Container(
                                              height:
                                                  qrcodeController!.text != "-1"
                                                      ? size.height * 0.5
                                                      : size.height * 0.2,
                                              alignment:
                                                  const AlignmentDirectional(
                                                      0.0, -1.0),
                                              child: qrcodeController!.text !=
                                                      "-1"
                                                  ? Scaffold(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      body: CreateBingoPage(
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
                                    ]))))),
                const BackButtonWidget(),
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

  final TextEditingController _controller = TextEditingController();
  int _value = 0;
  //final int _selectedIndex = -1;
}

import 'package:animated_button/animated_button.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/models/promotorconvert.dart';
import 'package:flutter/material.dart';

class PromotorPage extends StatefulWidget {
  Promotor? listasetresponseList;

  PromotorPage({
    super.key,
    required this.listasetresponseList,
  });

  @override
  State<PromotorPage> createState() => _PromotorPageState();
}

class _PromotorPageState extends State<PromotorPage> {
  String searchString = "";
  String searchStringproduct = "";
  String detectionInfo = "";
  //final DateTime _selectedDate = DateTime.now();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  final scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    //DateTime maxDate = _selectedDate.add(const Duration(days: 365));
    return Scaffold(
        key: scaffoldKey,
        backgroundColor: const Color(0xFFe7e8e9),
        body: Stack(
          children: [
            Positioned(
              top: -130,
              left: -15,
              child: Column(
                children: [
                  customBox(),
                ],
              ),
            ),
            Positioned(
              top: 340,
              left: 105,
              child: Column(
                children: [
                  customBox2(),
                ],
              ),
            ),
            Align(
                alignment: const AlignmentDirectional(0, 0),
                child: Container(
                    height: double.infinity,
                    width: double.infinity,
                    constraints: const BoxConstraints(
                      maxWidth: 570,
                    ),
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
                                  widget.listasetresponseList == null
                                      ? Container()
                                      : GestureDetector(
                                          onTap: () async {},
                                          child: Container(
                                              height: size.height * 0.74,
                                              width: size.width,
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF023e8a)
                                                    .withOpacity(0.6),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: ListTile(
                                                contentPadding:
                                                    const EdgeInsets.only(
                                                        left: 4,
                                                        right: 4,
                                                        top: 0),
                                                title: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Text(
                                                      'Total Clientes: ${widget.listasetresponseList!.clientes}'
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        color: const Color(
                                                            0xFFcaf0f8),
                                                        fontSize:
                                                            size.width * 0.038,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    AnimatedButton(
                                                        color: Colors.green,
                                                        height:
                                                            size.height * 0.06,
                                                        width: size.width * 0.4,
                                                        duration: 2,
                                                        onPressed: () async {},
                                                        child: Container(
                                                            padding:
                                                                const EdgeInsets
                                                                    .only(
                                                                    top: 0,
                                                                    left: 0,
                                                                    right: 0,
                                                                    bottom: 0),
                                                            child: Center(
                                                                child: Text(
                                                              "Total Ventas ${widget.listasetresponseList!.totalVentaGanancia!.totalVenta}",
                                                              style: TextStyle(
                                                                color: const Color(
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
                                                subtitle: SingleChildScrollView(
                                                    child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Row(children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          2,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                    " ${widget.listasetresponseList!.crecimiento!}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: const Color(
                                                                          0xFFcaf0f8),
                                                                      fontSize:
                                                                          size.width *
                                                                              0.08,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                  )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                        "Crecimiento",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              const Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.04,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
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
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          2,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                    " ${widget.listasetresponseList!.totalVentaGanancia!.ganancias}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: const Color(
                                                                          0xFFcaf0f8),
                                                                      fontSize:
                                                                          size.width *
                                                                              0.08,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                  )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                        "Total",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              const Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.04,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      )),
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                        "Ganancia",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              const Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.04,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
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
                                                      thickness: 0.4,
                                                      height: 5,
                                                      color: Color(0xFFe5f8ff),
                                                    ),
                                                    Row(children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          2,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                    " ${widget.listasetresponseList!.promedioIngresoMensual!}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: const Color(
                                                                          0xFFcaf0f8),
                                                                      fontSize:
                                                                          size.width *
                                                                              0.08,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                  )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                        "Promedio Ingreso",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              const Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.04,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      )),
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                        "Mensual",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              const Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.04,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
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
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          2,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                    "${widget.listasetresponseList!.totalVentaGanancia!.ganancias}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: const Color(
                                                                          0xFFcaf0f8),
                                                                      fontSize:
                                                                          size.width *
                                                                              0.08,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                  )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                        "Total",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              const Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.04,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
                                                                        ),
                                                                      )),
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                        "Ganancia",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              const Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.04,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
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
                                                      thickness: 0.4,
                                                      height: 5,
                                                      color: Color(0xFFe5f8ff),
                                                    ),
                                                    Row(children: [
                                                      Column(
                                                        mainAxisSize:
                                                            MainAxisSize.max,
                                                        children: [
                                                          Padding(
                                                            padding:
                                                                const EdgeInsets
                                                                    .all(4),
                                                            child: Row(
                                                              mainAxisSize:
                                                                  MainAxisSize
                                                                      .max,
                                                              children: [
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          2,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child:
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                    "${widget.listasetresponseList!.ventaHoy!}",
                                                                    style:
                                                                        TextStyle(
                                                                      color: const Color(
                                                                          0xFFcaf0f8),
                                                                      fontSize:
                                                                          size.width *
                                                                              0.08,
                                                                      letterSpacing:
                                                                          0.0,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .w300,
                                                                    ),
                                                                  )),
                                                                ),
                                                                Padding(
                                                                  padding:
                                                                      const EdgeInsetsDirectional
                                                                          .fromSTEB(
                                                                          8,
                                                                          0,
                                                                          0,
                                                                          0),
                                                                  child: Column(
                                                                    mainAxisSize:
                                                                        MainAxisSize
                                                                            .max,
                                                                    crossAxisAlignment:
                                                                        CrossAxisAlignment
                                                                            .start,
                                                                    children: [
                                                                      SelectionArea(
                                                                          child:
                                                                              Text(
                                                                        "Venta Hoy",
                                                                        style:
                                                                            TextStyle(
                                                                          color:
                                                                              const Color(0xFFcaf0f8),
                                                                          fontSize:
                                                                              size.width * 0.04,
                                                                          letterSpacing:
                                                                              0.0,
                                                                          fontWeight:
                                                                              FontWeight.normal,
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
                                                      thickness: 0.4,
                                                      height: 5,
                                                      color: Color(0xFFe5f8ff),
                                                    ),
                                                    Column(children: [
                                                      SizedBox(
                                                          width:
                                                              size.width * 0.8,
                                                          height:
                                                              size.height * 0.4,
                                                          child:
                                                              ListView.builder(
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
                                                                            mainAxisSize:
                                                                                MainAxisSize.max,
                                                                            children: [
                                                                              Padding(
                                                                                padding: const EdgeInsets.all(4),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                                                                                      child: SelectionArea(
                                                                                          child: Text(
                                                                                        "Mes:",
                                                                                        style: TextStyle(
                                                                                          color: const Color(0xFFcaf0f8),
                                                                                          fontSize: size.width * 0.04,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w300,
                                                                                        ),
                                                                                      )),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          SelectionArea(
                                                                                              child: Text(
                                                                                            "${widget.listasetresponseList!.ventasIngresosMensuales![index].mes}  ",
                                                                                            style: TextStyle(
                                                                                              color: const Color(0xFFcaf0f8),
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
                                                                                    padding: const EdgeInsets.all(4),
                                                                                    child: Row(
                                                                                      mainAxisSize: MainAxisSize.max,
                                                                                      children: [
                                                                                        Padding(
                                                                                          padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                                                                                          child: SelectionArea(
                                                                                              child: Text(
                                                                                            "Venta:",
                                                                                            style: TextStyle(
                                                                                              color: const Color(0xFFcaf0f8),
                                                                                              fontSize: size.width * 0.04,
                                                                                              letterSpacing: 0.0,
                                                                                              fontWeight: FontWeight.w300,
                                                                                            ),
                                                                                          )),
                                                                                        ),
                                                                                        Padding(
                                                                                          padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                                                                          child: Column(
                                                                                            mainAxisSize: MainAxisSize.max,
                                                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                                                            children: [
                                                                                              SelectionArea(
                                                                                                  child: Text(
                                                                                                "${widget.listasetresponseList!.ventasIngresosMensuales![index].venta}",
                                                                                                style: TextStyle(
                                                                                                  color: const Color(0xFFcaf0f8),
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
                                                                                padding: const EdgeInsets.all(4),
                                                                                child: Row(
                                                                                  mainAxisSize: MainAxisSize.max,
                                                                                  children: [
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(2, 0, 0, 0),
                                                                                      child: SelectionArea(
                                                                                          child: Text(
                                                                                        " Ingreso:",
                                                                                        style: TextStyle(
                                                                                          color: const Color(0xFFcaf0f8),
                                                                                          fontSize: size.width * 0.04,
                                                                                          letterSpacing: 0.0,
                                                                                          fontWeight: FontWeight.w300,
                                                                                        ),
                                                                                      )),
                                                                                    ),
                                                                                    Padding(
                                                                                      padding: const EdgeInsetsDirectional.fromSTEB(8, 0, 0, 0),
                                                                                      child: Column(
                                                                                        mainAxisSize: MainAxisSize.max,
                                                                                        crossAxisAlignment: CrossAxisAlignment.start,
                                                                                        children: [
                                                                                          SelectionArea(
                                                                                              child: Text(
                                                                                            " ${widget.listasetresponseList!.ventasIngresosMensuales![index].ingreso}",
                                                                                            style: TextStyle(
                                                                                              color: const Color(0xFFcaf0f8),
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
                                              )))
                                ])))))
          ],
        ));
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:bingo/ui/home/widgets/payment_widget.dart';
import 'package:bingo/models/bingoconvert.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/routes.dart';
import 'package:intl/intl.dart';
import 'package:bingo/models/modelCliente.dart';
import 'package:bingo/ui/user/update_person_page.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
import 'package:http/io_client.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

final ipController = TextEditingController(text: "0.0.0.0");

// ignore: must_be_immutable
class BingoPage extends StatefulWidget {
  ModelCliente? datosuser;

  BingoPage({super.key, required this.datosuser});

  @override
  State<BingoPage> createState() => _BingoPageState();
}

class _BingoPageState extends State<BingoPage> {
  final pf = Preferencias();
  final ioc = HttpClient();
  Future<List<BingoSala>?>? listaset;
  List<BingoSala>? listasetresponseList;
  DateTime _selectedDate = DateTime.now();
  String searchString = "";
  String searchStringproduct = "";
  String detectionInfo = "";
  int _selectedIndex = 0;

  @override
  void initState() {
    listaset = fetchShows();
    super.initState();
  }

  iniciarPreferencias() async {
    await pf.initPrefs();
    ipController.text = pf.getIp;
    setState(() {});
  }

  Future<List<BingoSala>?> fetchShows() async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(_selectedDate);
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    await iniciarPreferencias();
    final url = Uri.parse(
        "${ipController.text}/api/BingoPremioDetalleInterno/GetAll?Estado=1&FechaInicio=$formattedDate");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseList =
            bingoSalaFromMap(utf8.decode(response.bodyBytes));
      });
      setState(() {});
      return listasetresponseList;
    } else {
      throw Exception('Failed to load shows');
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
    DateTime maxDate = _selectedDate.add(const Duration(days: 365));

    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFcaf0f8),
        body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Stack(children: [
              Container(
                decoration: boxDecoration,
              ),
              const Positioned(
                top: -130,
                left: -15,
                child: Column(
                  children: [
                    customBox(),
                  ],
                ),
              ),
              const Positioned(
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
                      height: size.height,
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
                              padding: const EdgeInsets.only(top: 32),
                              child: Column(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        IconButton(
                                          icon: Icon(Icons.logout,
                                              color: const Color(0xFF03045e),
                                              size: size.width * 0.07),
                                          onPressed: () => Navigator.pushNamed(
                                              context, AppRoutes.login),
                                        ),
                                      ],
                                    ),
                                    Padding(
                                      padding:
                                          const EdgeInsetsDirectional.fromSTEB(
                                              30, 10, 30, 0),
                                      child: Container(
                                        height: 100,
                                        width: 300,
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
                                    const SizedBox(height: 10),
                                    Padding(
                                        padding: const EdgeInsets.only(
                                            left: 30, right: 30, bottom: 10),
                                        child: Container(
                                          width: size.width * 0.62,
                                          padding: const EdgeInsets.only(
                                              top: 0, bottom: 0),
                                          height: size.height * 0.06,
                                          child: TextField(
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
                                                color: const Color(0xFF424242),
                                                fontSize: size.width * 0.04,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              enabledBorder: OutlineInputBorder(
                                                borderSide: const BorderSide(
                                                    color: Color(0xFF03045e),
                                                    width: 2.0),
                                                borderRadius:
                                                    BorderRadius.circular(10.0),
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
                                                color: const Color(0xFF424242),
                                                fontSize: size.width * 0.04,
                                              ),
                                              isDense: true,
                                              filled: true,
                                              fillColor:
                                                  const Color(0xFFcaf0f8),
                                            ),
                                          ),
                                        )),
                                    SizedBox(
                                      height: size.height * 0.09,
                                      child: ScrollDatePicker(
                                        options: const DatePickerOptions(
                                            backgroundColor: Color(0xFFcaf0f8)),
                                        maximumDate: maxDate,
                                        selectedDate: _selectedDate,
                                        locale: const Locale('es'),
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
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, right: 30),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      await fetchShows();
                                                      setState(() {
                                                        _selectedIndex = 0;
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
                                                                    0
                                                                ? const Color(
                                                                    0xFF03045e)
                                                                : Colors.black,
                                                            width: 2,
                                                          ),
                                                          color: _selectedIndex ==
                                                                  0
                                                              ? const Color(
                                                                  0xFF03045e)
                                                              : Colors
                                                                  .transparent,
                                                        ),
                                                        padding:
                                                            const EdgeInsets
                                                                .all(12),
                                                        child: _selectedIndex ==
                                                                0
                                                            ? const Icon(
                                                                Icons.check,
                                                                color: Color(
                                                                    0xFFcaf0f8))
                                                            : const SizedBox(),
                                                      ),
                                                      Center(
                                                          child: Text(
                                                        "Inactivo",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: size.width *
                                                              0.030,
                                                          fontFamily: 'gotic',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ))
                                                    ]),
                                                  ),
                                                  const SizedBox(width: 3.5),
                                                  GestureDetector(
                                                      onTap: () async {
                                                        await fetchShows();
                                                        setState(() {
                                                          _selectedIndex = 1;
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
                                                                  ? const Color(
                                                                      0xFF03045e)
                                                                  : Colors
                                                                      .black,
                                                              width: 2,
                                                            ),
                                                            color: _selectedIndex ==
                                                                    1
                                                                ? const Color(
                                                                    0xFF03045e)
                                                                : Colors
                                                                    .transparent,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          child: _selectedIndex ==
                                                                  1
                                                              ? const Icon(
                                                                  Icons.check,
                                                                  color: Color(
                                                                      0xFFcaf0f8))
                                                              : const SizedBox(),
                                                        ),
                                                        Center(
                                                            child: Text(
                                                          "Activo",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                size.width *
                                                                    0.030,
                                                            fontFamily: 'gotic',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ))
                                                      ])),
                                                  const SizedBox(width: 3.5),
                                                  GestureDetector(
                                                      onTap: () async {
                                                        await fetchShows();
                                                        setState(() {
                                                          _selectedIndex = 2;
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
                                                                  ? const Color(
                                                                      0xFF03045e)
                                                                  : Colors
                                                                      .black,
                                                              width: 2,
                                                            ),
                                                            color: _selectedIndex ==
                                                                    2
                                                                ? const Color(
                                                                    0xFF03045e)
                                                                : Colors
                                                                    .transparent,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          child: _selectedIndex ==
                                                                  2
                                                              ? const Icon(
                                                                  Icons.check,
                                                                  color: Color(
                                                                      0xFFcaf0f8))
                                                              : const SizedBox(),
                                                        ),
                                                        Center(
                                                            child: Text(
                                                          "Jugando",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                size.width *
                                                                    0.030,
                                                            fontFamily: 'gotic',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ))
                                                      ])),
                                                  const SizedBox(width: 3.5),
                                                  GestureDetector(
                                                      onTap: () async {
                                                        await fetchShows();
                                                        setState(() {
                                                          _selectedIndex = 3;
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
                                                                  ? const Color(
                                                                      0xFF03045e)
                                                                  : Colors
                                                                      .black,
                                                              width: 2,
                                                            ),
                                                            color: _selectedIndex ==
                                                                    3
                                                                ? const Color(
                                                                    0xFF03045e)
                                                                : Colors
                                                                    .transparent,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          child: _selectedIndex ==
                                                                  3
                                                              ? const Icon(
                                                                  Icons.check,
                                                                  color: Color(
                                                                      0xFFcaf0f8))
                                                              : const SizedBox(),
                                                        ),
                                                        Center(
                                                            child: Text(
                                                          "Finalizado",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                size.width *
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
                                                          _selectedIndex = 4;
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
                                                                  ? const Color(
                                                                      0xFF03045e)
                                                                  : Colors
                                                                      .black,
                                                              width: 2,
                                                            ),
                                                            color: _selectedIndex ==
                                                                    4
                                                                ? const Color(
                                                                    0xFF03045e)
                                                                : Colors
                                                                    .transparent,
                                                          ),
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(12),
                                                          child: _selectedIndex ==
                                                                  4
                                                              ? const Icon(
                                                                  Icons.check,
                                                                  color: Color(
                                                                      0xFFcaf0f8))
                                                              : const SizedBox(),
                                                        ),
                                                        Center(
                                                            child: Text(
                                                          "Cancelado",
                                                          style: TextStyle(
                                                            color: Colors.black,
                                                            fontSize:
                                                                size.width *
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
                                                color: _selectedIndex == 2 && listasetresponseList?.isNotEmpty == true
                                                    ? const Color(0xFF03045e)
                                                    : Colors.grey,
                                                height: size.height * 0.05,
                                                width: size.width * 0.16,
                                                duration: 2,
                                                onPressed: _selectedIndex == 2
                                                    ? () {
                                                        _handlePayments();
                                                      }
                                                    : () {},
                                                child: Center(
                                                    child: Text(
                                                  "Pagos",
                                                  style: TextStyle(
                                                    color:
                                                        const Color(0xFFcaf0f8),
                                                    fontSize: size.width * 0.03,
                                                    fontFamily: 'gotic',
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ))),
                                          ]),
                                    ),
                                    listasetresponseList == null
                                        ? Container()
                                        : SizedBox(
                                            height: size.height * 0.44,
                                            child: ListView.separated(
                                                separatorBuilder: (context,
                                                        index) =>
                                                    const Divider(
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
                                                            Bingo playing =
                                                                order.bingo;
                                                            await Navigator
                                                                .pushNamed(
                                                                    context,
                                                                    AppRoutes
                                                                        .home,
                                                                    arguments: {
                                                                  'bingo':
                                                                      playing,
                                                                  'datosuser':
                                                                      widget
                                                                          .datosuser
                                                                });
                                                            await fetchShows();
                                                          },
                                                          child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                      left: 8,
                                                                      right: 8,
                                                                      top: 3),
                                                              child: Container(
                                                                width:
                                                                    size.width *
                                                                        0.9,
                                                                height:
                                                                    size.height *
                                                                        0.18,
                                                                decoration:
                                                                    BoxDecoration(
                                                                  borderRadius:
                                                                      BorderRadius
                                                                          .circular(
                                                                              30),
                                                                  image:
                                                                      DecorationImage(
                                                                    image: const AssetImage(
                                                                        'assets/images/bingo.jpg'),
                                                                    fit: BoxFit
                                                                        .cover,
                                                                    colorFilter:
                                                                        ColorFilter
                                                                            .mode(
                                                                      Colors
                                                                          .black
                                                                          .withOpacity(
                                                                              0.4),
                                                                      BlendMode
                                                                          .darken,
                                                                    ),
                                                                  ),
                                                                ),
                                                                child:
                                                                    Container(
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: Colors
                                                                        .black
                                                                        .withOpacity(
                                                                            0.4),
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            30),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsets
                                                                            .all(
                                                                            20),
                                                                    child:
                                                                        Column(
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
                                                                              mainAxisSize: MainAxisSize.min,
                                                                              crossAxisAlignment: CrossAxisAlignment.start,
                                                                              children: [
                                                                                Padding(
                                                                                  padding: const EdgeInsetsDirectional.fromSTEB(0, 1, 0, 1),
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
                                                                          "Descripción: ${order.bingo.descripcion}",
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
                                                                                padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 25, 0),
                                                                                child: Column(
                                                                                  children: [
                                                                                    Text(
                                                                                      'Valor c/u \$${order.bingo.precioPorCartilla.toStringAsFixed(2)}',
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Cera Pro',
                                                                                        color: Colors.white,
                                                                                        fontSize: size.width * 0.030,
                                                                                        letterSpacing: 1.5,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      'Valor Total \$${(order.bingo.precioPorCartilla * 6).toStringAsFixed(2)}',
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
                                                                              order.bingo.fecha.toString().substring(0, 16),
                                                                              style: TextStyle(
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
                        UpdatePersonPage(datosuser: widget.datosuser),
                  ));
            },
            child: Container(
              width: size.width * 0.4,
              color: const Color(0xFF03045e),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Text(
                          "Modificar Usuario",
                          style: TextStyle(
                            color: const Color(0xFFcaf0f8),
                            fontSize: size.width * 0.042,
                            fontFamily: 'gotic',
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Icon(
                          Icons.supervised_user_circle,
                          size: size.width * 0.059,
                          color: const Color(0xFFcaf0f8),
                        ),
                      ],
                    )
                  ]),
            )));
  }

  void _handlePayments() {
    _payments();
  }

  Future<void> _payments() async {
    print('bingos = > ${bingoSalaToMap(listasetresponseList!)}');
    if (listasetresponseList?.isNotEmpty == true) {
      Bingo? playing = listasetresponseList?.first.bingo;
      await showDialog(
        context: context,
        builder: (BuildContext context) {
          return PaymentWidget(datosuser: widget.datosuser, bingo: playing);
        },
      );
    }
    setState(() {});
  }
}

import 'dart:io';
import 'package:bingo/services/bingo_service.dart';
import 'package:bingo/ui/home/widgets/payment_widget.dart';
import 'package:bingo/models/bingoconvert.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/routes.dart';
import 'package:bingo/models/modelCliente.dart';
import 'package:bingo/ui/user/update_person_page.dart';
import 'package:flutter/material.dart';
import 'package:animated_button/animated_button.dart';
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
  final ioc = HttpClient();
  DateTime _selectedDate = DateTime.now();
  String searchString = "";
  String searchStringproduct = "";
  String detectionInfo = "";
  int _selectedIndex = 0;

  late List<Bingo> bingosList = [];

  @override
  void initState() {
    loadBingos();
    super.initState();
  }

  Future<void> loadBingos() async {
    try {
      List<Bingo> bingos = await BingoService().getBingosAvailaibles();
      if (bingos.isNotEmpty) {
        BingoService().updateBingoState(bingos);
        setState(() {
          bingosList = bingos;
        });
      }
    } catch (e) {
      print('Error al cargar los bingos: $e');
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

                                          //await fetchShows();
                                          /*listasetresponseList!.sort((a, b) {
                                            int diffA = (a.bingo.fecha.day -
                                                    _selectedDate.day)
                                                .abs();
                                            int diffB = (b.bingo.fecha.day -
                                                    _selectedDate.day)
                                                .abs();
                                            return diffA.compareTo(diffB);
                                          });
                                          setState(() {});*/

                                          orderBingosByDate(_selectedDate);
                                          setState(() {});
                                        },
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 30, top: 5, right: 30),
                                      child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Center(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  /*Center(
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        // Aquí agregamos el ListView horizontal para los estados
                                                        Container(
                                                          height:
                                                              60, // Altura del selector
                                                          margin: EdgeInsets
                                                              .symmetric(
                                                                  vertical: 10),
                                                          child:
                                                              ListView.builder(
                                                            scrollDirection:
                                                                Axis.horizontal,
                                                            itemCount: bingoStates
                                                                .length, // bingoStates tiene los nombres de los estados
                                                            itemBuilder:
                                                                (context,
                                                                    index) {
                                                              return GestureDetector(
                                                                onTap: () {
                                                                  setState(() {
                                                                    _selectedIndex =
                                                                        index; // Cambiar el índice seleccionado
                                                                  });
                                                                },
                                                                child:
                                                                    Container(
                                                                  margin: EdgeInsets
                                                                      .symmetric(
                                                                          horizontal:
                                                                              8),
                                                                  padding:
                                                                      EdgeInsets
                                                                          .all(
                                                                              10),
                                                                  decoration:
                                                                      BoxDecoration(
                                                                    color: _selectedIndex ==
                                                                            index
                                                                        ? Color(
                                                                            0xFF03045e) // Color azul para el estado seleccionado
                                                                        : Colors
                                                                            .transparent,
                                                                    borderRadius:
                                                                        BorderRadius
                                                                            .circular(8),
                                                                    border:
                                                                        Border
                                                                            .all(
                                                                      color: _selectedIndex ==
                                                                              index
                                                                          ? Color(
                                                                              0xFF03045e) // Borde azul para el estado seleccionado
                                                                          : Colors
                                                                              .black,
                                                                      width: 2,
                                                                    ),
                                                                  ),
                                                                  child: Center(
                                                                    child: Text(
                                                                      bingoStates[
                                                                          index], // Mostrar el nombre del estado
                                                                      style:
                                                                          TextStyle(
                                                                        color: _selectedIndex ==
                                                                                index
                                                                            ? Color(0xFFcaf0f8) // Texto blanco cuando está seleccionado
                                                                            : Colors.black, // Texto negro para los demás
                                                                        fontSize:
                                                                            size.width *
                                                                                0.03,
                                                                        fontFamily:
                                                                            'gotic',
                                                                        fontWeight:
                                                                            FontWeight.bold,
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              );
                                                            },
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ),

                                                  // Aquí está tu AnimatedButton
                                                  AnimatedButton(
                                                    color: _selectedIndex == 2
                                                        ? const Color(
                                                            0xFF03045e) // Color azul cuando el estado seleccionado es 2
                                                        : Colors.grey,
                                                    height: size.height * 0.05,
                                                    width: size.width * 0.16,
                                                    duration: 2,
                                                    onPressed:
                                                        _selectedIndex == 2
                                                            ? () {
                                                                print(
                                                                    'pagos desde bingo');
                                                                _handlePayments(); // Llamada al método para procesar pagos
                                                              }
                                                            : () {},
                                                    child: Center(
                                                      child: Text(
                                                        "Pagos",
                                                        style: TextStyle(
                                                          color: const Color(
                                                              0xFFcaf0f8),
                                                          fontSize:
                                                              size.width * 0.03,
                                                          fontFamily: 'gotic',
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                      ),
                                                    ),
                                                  ),*/

                                                  GestureDetector(
                                                    onTap: () async {
                                                      //await fetchShows();
                                                      await loadBingos();
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
                                                        ///await fetchShows();
                                                        await loadBingos();
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
                                                        //await fetchShows();
                                                        await loadBingos();
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
                                                        //await fetchShows();
                                                        await loadBingos();
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
                                                        //await fetchShows();
                                                        await loadBingos();
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
                                                color: _selectedIndex ==
                                                        2 /*&&
                                                        bingosList.isNotEmpty ==
                                                            true*/
                                                    ? const Color(0xFF03045e)
                                                    : Colors.grey,
                                                height: size.height * 0.05,
                                                width: size.width * 0.16,
                                                duration: 2,
                                                onPressed: _selectedIndex == 2
                                                    ? () {
                                                        print(
                                                            'pagos desde bingo');
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
                                    bingosList.isEmpty
                                        ? const Center(
                                            child: CircularProgressIndicator())
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
                                                itemCount: bingosList.length,
                                                itemBuilder: ((ctx, index) {
                                                  final order =
                                                      bingosList[index];
                                                  
                                                  String year = order.fecha?.year
                                                              .toString().toLowerCase() ?? '';
                                                  String month = order.fecha?.month
                                                              .toString().toLowerCase() ?? '';

                                                  return year.contains(
                                                                  _selectedDate
                                                                      .year
                                                                      .toString()) &&
                                                          order.estado
                                                              .toString()
                                                              .toLowerCase()
                                                              .contains(
                                                                  _selectedIndex
                                                                      .toString()) &&
                                                          month.contains(
                                                                  _selectedDate
                                                                      .month
                                                                      .toString())
                                                      ? GestureDetector(
                                                          onTap: () async {
                                                            Bingo playing =
                                                                order;
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
                                                            //await fetchShows();
                                                            await loadBingos();
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
                                                                        0.19,
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
                                                                                  '${order.bingoId}'.toUpperCase(),
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
                                                                          "Descripción: ${order.descripcion}",
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
                                                                                      'Valor c/u \$${order.precioPorCartilla?.toStringAsFixed(2) ?? 0}',
                                                                                      style: TextStyle(
                                                                                        fontFamily: 'Cera Pro',
                                                                                        color: Colors.white,
                                                                                        fontSize: size.width * 0.030,
                                                                                        letterSpacing: 1.5,
                                                                                        fontWeight: FontWeight.w500,
                                                                                      ),
                                                                                    ),
                                                                                    Text(
                                                                                      'Valor Total \$${(order.precioPorCartilla ?? 0 * 6).toStringAsFixed(2)}',
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
                                                                              order.fecha.toString().substring(0, 16),
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
                                                })),
                                          )
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

  List<Bingo> orderBingosByDate(DateTime selectedDate) {
    bingosList.sort((a, b) {
      int diffA = (a.fecha?.day ?? 0 - selectedDate.day).abs();
      int diffB = (b.fecha?.day ?? 0 - selectedDate.day).abs();
      return diffA.compareTo(diffB);
    });
    return bingosList;
  }

  void _handlePayments() {
    _payments();
  }

  Future<void> _payments() async {
    for (var bingo in bingosList) {
      print('pagos = > ${bingo.bingoToMap()}');
    }
    if (bingosList.isNotEmpty == true) {
      Bingo? playing = bingosList.first;
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

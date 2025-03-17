import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:animated_button/animated_button.dart';
import 'package:bingo/models/modelCliente.dart';
import 'package:bingo/ui/bingo/widgets/bingo_edit.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:bingo/models/bingoconvert.dart';
import 'package:bingo/models/ventasconvert.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'package:scroll_date_picker/scroll_date_picker.dart';

class SaleWidget extends StatefulWidget {
  ModelCliente? datosuser;
  Bingo? bingo;

  SaleWidget({super.key, required this.bingo, required this.datosuser});

  @override
  State<SaleWidget> createState() => _SaleWidgetState();
}

class _SaleWidgetState extends State<SaleWidget> {
  String searchString = '';
  String searchStringproduct = '';
  String detectionInfo = '';
  DateTime _selectedDate = DateTime.now();
  final ioc = HttpClient();
  final pf = Preferencias();
  Future<List<Venta>?>? listaset;
  List<Venta>? listasetresponseList;

  Future<List<Venta>?> fetchShows() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    String _fecha =
        "${_selectedDate.year}-${_selectedDate.month}-${_selectedDate.day}";

    final url = Uri.parse(
        "${pf.getIp.toString()}/api/PromotorInterno/GetMisVentasByPromotor?PromotorId=${widget.datosuser!.promotorId}&FechaCompra=$_fecha");

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
    //await pf.initPrefs();
    listaset = fetchShows();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  List<BingoSala>? listasetresponseListbingo;

  Future<List<BingoSala>?> fetchShowsbingo() async {
    String formattedDate =
        DateFormat('yyyy-MM-dd').format(widget.bingo!.fecha);

    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);

    final url = Uri.parse(
        "${pf.getIp.toString()}/api/BingoPremioDetalleInterno/GetAll?Estado=1&FechaInicio=$formattedDate");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListbingo =
            bingoSalaFromMap(utf8.decode(response.bodyBytes));
        var resultado = listasetresponseListbingo!.firstWhere(
          (elemento) => elemento.bingo.bingoId == widget.bingo!.bingoId,
        );

        if (resultado != null) {
          print("Elemento encontrado: ${resultado.bingo.bingoId}");
          setState(() {
            widget.bingo = resultado.bingo;
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
    DateTime maxDate = _selectedDate.add(const Duration(days: 365));
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
                                      Container(
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
                                      SizedBox(
                                        height: size.height * 0.09,
                                        child: ScrollDatePicker(
                                          options: const DatePickerOptions(
                                            backgroundColor: Color(0xFFcaf0f8),
                                          ),
                                          maximumDate: maxDate,
                                          selectedDate: _selectedDate,
                                          locale: const Locale('es'),
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
                                          padding: const EdgeInsets.all(4),
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
                                                  color:
                                                      const Color(0xFF424242),
                                                  fontSize: size.width * 0.04,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                enabledBorder:
                                                    const UnderlineInputBorder(
                                                  borderSide: BorderSide(
                                                    color: Colors.black,
                                                    width: 2.0,
                                                  ),
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
                                          )),
                                      listasetresponseList == null
                                          ? Container()
                                          : SizedBox(
                                              height: size.height * 0.54,
                                              child: ListView.separated(
                                                  separatorBuilder: (context,
                                                          index) =>
                                                      const Divider(
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
                                                                padding:
                                                                    const EdgeInsets
                                                                        .only(
                                                                        left: 4,
                                                                        right:
                                                                            4,
                                                                        top: 0),
                                                                child:
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
                                                                        const DecorationImage(
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
                                                                    padding:
                                                                        const EdgeInsetsDirectional
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
                                                                            padding: const EdgeInsetsDirectional.fromSTEB(
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
                                                                                  style: const TextStyle(
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
                                                                                            color: const Color(0xFF0077b6),
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
                                                                                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                                                                                    child: Row(
                                                                                      children: [
                                                                                        Text(
                                                                                          'Descripción: ${order.ventaId}',
                                                                                          style: const TextStyle(
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

                                                                                                  if (widget.bingo!.estado == 2 || widget.bingo!.estado == 3) {
                                                                                                    showAlerta(context, 'Mensaje Informativo', 'Para ventas el bingo debe estar en un estado diferente de jugando!!');
                                                                                                  } else {
                                                                                                    await showDialog(
                                                                                                      context: context,
                                                                                                      builder: (BuildContext context) {
                                                                                                        return AlertDialog(
                                                                                                          backgroundColor: const Color(0xFFcaf0f8).withOpacity(1),
                                                                                                          title: const Text(
                                                                                                            'Desea editar este registro?',
                                                                                                            style: TextStyle(color: Color(0xFF03045e)),
                                                                                                          ),
                                                                                                          content: const Text('confirmar edición.'),
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
                                                                                                                        backgroundColor: const Color(0xFF03045e),
                                                                                                                      ),
                                                                                                                      child: Text(
                                                                                                                        'Confirmar',
                                                                                                                        style: TextStyle(fontSize: size.width * 0.03, color: const Color(0xFFcaf0f8)),
                                                                                                                      ),
                                                                                                                      onPressed: () async {
                                                                                                                        //   await fetchShowsdelete(order.ventaId.toString());
                                                                                                                        //   listaset = fetchShows();
                                                                                                                        await showDialog(
                                                                                                                          context: context,
                                                                                                                          builder: (BuildContext context) {
                                                                                                                            return EditBingo(datosuser: widget.datosuser, bingo: widget.bingo, venta: order);
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
                                                                                                      color: const Color(0xFFcaf0f8),
                                                                                                    ),
                                                                                                    const Text(
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
                                                                                  'Modulo: ${order.codigoModulo} Valor: \$${order.precioTotalCartilla!.toStringAsFixed(2)}',
                                                                                  style: const TextStyle(
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
                                                                                                      "Registro eliminado",
                                                                                                      style: TextStyle(
                                                                                                        color: const Color(0xFFcaf0f8),
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
                                                                                                        backgroundColor: const Color(0xFFcaf0f8).withOpacity(1),
                                                                                                        title: const Text(
                                                                                                          'Desea eliminar este registro?',
                                                                                                          style: TextStyle(color: Color(0xFF03045e)),
                                                                                                        ),
                                                                                                        content: const Text('confirmar eliminación.'),
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
                                                                                                                      backgroundColor: const Color(0xFF03045e),
                                                                                                                    ),
                                                                                                                    child: Text(
                                                                                                                      'Confirmar',
                                                                                                                      style: TextStyle(
                                                                                                                        fontSize: size.width * 0.03,
                                                                                                                        color: const Color(0xFFcaf0f8),
                                                                                                                      ),
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
    final http = IOClient(ioc);
    final url =
        Uri.parse('${pf.getIp.toString()}/api/PromotorInterno/Delete/$elemento');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      const snackBar =
          SnackBar(content: Center(child: Text("Se ha confirmado la eliminación..")), backgroundColor: Colors.green,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      return "si";
    } else {
      const snackBar =
          SnackBar(content: Center(child: Text("No se ha confirmado la eliminación..")), backgroundColor: Colors.red,);
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      throw Exception('Failed to load shows');
    }
  }
}
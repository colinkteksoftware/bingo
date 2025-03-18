import 'dart:convert';
import 'dart:io';
import 'package:intl/intl.dart';
import 'package:animated_button/animated_button.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:bingo/models/modelCliente.dart';
import 'package:bingo/ui/user/update_user_page.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/models/bingoconvert.dart';
import 'package:bingo/models/clienteconvert.dart';
import 'package:bingo/models/pagosconvert.dart';
import 'package:bingo/models/uvtconvert.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';

class PaymentWidget extends StatefulWidget {
  ModelCliente? datosuser;

  BingoSala? bingo;
  PaymentWidget({super.key, required this.datosuser});

  @override
  State<PaymentWidget> createState() => _PaymentWidgetState();
}

class _PaymentWidgetState extends State<PaymentWidget> {
  final ioc = HttpClient();
  final pf = Preferencias();
  Future<List<Pago>?>? listWinners;
  List<Pago>? listasetresponseListpagos = [];

  Future<List<Pago>?> getWinners() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    final url = Uri.parse(
        "${pf.getIp.toString()}/api/PromotorInterno/GetGanadoresForPromotor/${widget.datosuser!.promotorId}");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListpagos =
            pagoFromJson(utf8.decode(response.bodyBytes));
      });

      return listasetresponseListpagos;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  @override
  void initState() {
    listWinners = getWinners();
    listasetuvt = getAmountUVT();
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {});
  }

  @override
  Widget build(BuildContext context) {
    double totaluvt = 0;
    //double amount = 0;
    //double sumAward = 0;
    //double totalPremioAdicional = 0;
    var size = MediaQuery.of(context).size;
    return Scaffold(
        backgroundColor: const Color(0xFFcaf0f8),
        body: SingleChildScrollView(
            physics: const NeverScrollableScrollPhysics(),
            child: Stack(children: [
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
                                              0, 0, 0, 0),
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
                                    const SizedBox(height: 5),
                                    Text(
                                      'Lista de Ganadores del Bingo'
                                          .toUpperCase(),
                                      style: const TextStyle(
                                        fontFamily: 'Inter Tight',
                                        color: Colors.black,
                                        fontSize: 20,
                                        letterSpacing: 0.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    const SizedBox(height: 5),

                                    listasetresponseListpagos == null ||
                                              listasetresponseListpagos!.isEmpty
                                          ? Center(
                                              child: AnimatedTextKit(
                                              animatedTexts: [
                                                TypewriterAnimatedText(
                                                    'No hay Resultados.',
                                                    textStyle: const TextStyle(
                                                      fontSize: 30,
                                                      color: Colors.white,
                                                      backgroundColor:
                                                          Color(0xFF427382),
                                                    )),
                                              ],
                                              isRepeatingAnimation: true,
                                              repeatForever: true,
                                              pause: const Duration(
                                                  milliseconds: 1000),
                                            ))
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
                                                      listasetresponseListpagos!
                                                          .length,
                                                  itemBuilder: ((ctx, index) {
                                                    final order =
                                                        listasetresponseListpagos![
                                                            index];
                                                    double
                                                        totalPremioAdicional =
                                                        0;
                                                    double amount = 0;                                                    

                                                    if (order
                                                        .detallePremioFigura!
                                                        .first
                                                        .listaAdicionales!
                                                        .isEmpty) {
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

                                                    amount = (order
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
                                                                          0.18,
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
                                                                            20),
                                                                  ),
                                                                  child:
                                                                      Padding(
                                                                    padding:
                                                                        const EdgeInsetsDirectional
                                                                            .fromSTEB(
                                                                            10,
                                                                            5,
                                                                            10,
                                                                            0),
                                                                    child:
                                                                        Column(
                                                                      children: [
                                                                        Padding(
                                                                          padding: const EdgeInsetsDirectional
                                                                              .fromSTEB(
                                                                              0,
                                                                              0,
                                                                              0,
                                                                              10),
                                                                          child:
                                                                              Column(
                                                                            children: [
                                                                              Column(
                                                                                children: [
                                                                                  Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      const Text(
                                                                                        "MODULO:",
                                                                                        style: TextStyle(fontFamily: 'Inter Tight', color: Color(0xFFcaf0f8), letterSpacing: 0.0, fontWeight: FontWeight.w800, fontSize: 18),
                                                                                      ),
                                                                                      const SizedBox(width: 5),
                                                                                      Text(
                                                                                        '${order.codigoModulo}',
                                                                                        style: const TextStyle(fontFamily: 'Inter Tight', color: Color(0xFFcaf0f8), letterSpacing: 0.0, fontWeight: FontWeight.w800, fontSize: 18),
                                                                                      ),
                                                                                    ],
                                                                                  ),
                                                                                  const SizedBox(height: 5),
                                                                                  Row(
                                                                                    crossAxisAlignment: CrossAxisAlignment.center,
                                                                                    mainAxisAlignment: MainAxisAlignment.center,
                                                                                    children: [
                                                                                      AnimatedButton(
                                                                                          color: const Color.fromARGB(255, 210, 193, 3), //Colors.amber,
                                                                                          height: size.height * 0.07,
                                                                                          width: size.width * 0.48,
                                                                                          duration: 2,
                                                                                          onPressed: () async {},
                                                                                          child: Container(
                                                                                              padding: const EdgeInsets.only(top: 2, left: 0, right: 0, bottom: 2),
                                                                                              child: Center(
                                                                                                  child: Column(
                                                                                                children: [
                                                                                                  Text(
                                                                                                    "Valor Total:  ${NumberFormat('#,##0', 'en_US').format(amount)}",
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.black, //const Color(0xFF0077b6),
                                                                                                      fontSize: size.width * 0.034,
                                                                                                      fontFamily: 'gotic',
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "Valor Premio:  ${NumberFormat('#,##0', 'en_US').format(order.detallePremioFigura!.first.valorPremio)}",
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontSize: size.width * 0.030,
                                                                                                      fontFamily: 'gotic',
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                    ),
                                                                                                  ),
                                                                                                  Text(
                                                                                                    "Valor Adicionales:  ${NumberFormat('#,##0', 'en_US').format(totalPremioAdicional)}",
                                                                                                    style: TextStyle(
                                                                                                      color: Colors.black,
                                                                                                      fontSize: size.width * 0.030,
                                                                                                      fontFamily: 'gotic',
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                    ))]))))])])])),
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
                                                                                const Padding(
                                                                                    padding: EdgeInsetsDirectional.fromSTEB(0, 0, 0, 5),
                                                                                    child: Row(
                                                                                      children: [],
                                                                                    )),
                                                                                Text(
                                                                                  '${order.ventaId}'.toUpperCase(),
                                                                                  style: const TextStyle(
                                                                                    fontFamily: 'Inter Tight',
                                                                                    color: Color(0xFFcaf0f8),
                                                                                    fontSize: 12,
                                                                                    letterSpacing: 0.0,
                                                                                    fontWeight: FontWeight.w800,
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
                                                                                      onTap: listasetresponseListpagos!.isNotEmpty
                                                                                          ? () async {
                                                                                              var size = MediaQuery.of(context).size;
                                                                                              totaluvt = listasetresponseListpagosuvt!.cantidadUvt! == 0 ? 1 : double.parse(listasetresponseListpagosuvt!.cantidadUvt.toString());

                                                                                              collectPrize(context, order, amount, size, totalPremioAdicional, totaluvt);
                                                                                            }
                                                                                          : null,
                                                                                      child: InkWell(
                                                                                        onTap: listasetresponseListpagos!.isNotEmpty
                                                                                            ? () {
                                                                                                totaluvt = listasetresponseListpagosuvt!.cantidadUvt! == 0 ? 1 : double.parse(listasetresponseListpagosuvt!.cantidadUvt.toString());
                                                                                                collectPrize(context, order, amount, size, totalPremioAdicional, totaluvt);
                                                                                              }
                                                                                            : null,
                                                                                        child: Container(
                                                                                          padding: const EdgeInsets.all(8.0),
                                                                                          decoration: BoxDecoration(
                                                                                            color: listasetresponseListpagos!.isNotEmpty ? Colors.green[600] : Colors.grey[400],
                                                                                            borderRadius: BorderRadius.circular(10),
                                                                                          ),
                                                                                          child: Row(
                                                                                            children: [
                                                                                              Container(
                                                                                                padding: const EdgeInsets.all(0),
                                                                                                child: Center(
                                                                                                  child: Text(
                                                                                                    'Registrar Pago',
                                                                                                    style: TextStyle(
                                                                                                      color: listasetresponseListpagos!.isNotEmpty ? Colors.white : Colors.grey[600],
                                                                                                      fontSize: size.width * 0.032,
                                                                                                      fontFamily: 'gotic',
                                                                                                      fontWeight: FontWeight.bold,
                                                                                                    ),
                                                                                                  ),
                                                                                                ),
                                                                                              ),
                                                                                              Icon(
                                                                                                Icons.monetization_on_outlined,
                                                                                                size: size.width * 0.059,
                                                                                                color: listasetresponseListpagos!.isNotEmpty ? Colors.white : Colors.grey[600],
                                                                                              )]))))])])])])))))
                                                        : Container();
                                                  })))])))))])));                                  
  }

  Future<dynamic> collectPrize(BuildContext context, Pago order, double amount,
      Size size, double totalPremioAdicional, double totaluvt) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: const Color(0xFFcaf0f8).withOpacity(1),
          title: Text(
            'Desea Registrar este Pago del Modulo: ${order.codigoModulo}',
            style: const TextStyle(color: Color(0xFF03045e)),
          ),
          content: Text(
            "Valor Total:  ${NumberFormat('#,##0', 'en_US').format(amount)}",
            style: TextStyle(
              color: const Color(0xFF0077b6),
              fontSize: size.width * 0.034,
              fontFamily: 'gotic',
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                Column(children: [
                  Text(
                    "Premio: ${order.detallePremioFigura!.first.nombreFigura}",
                    style: TextStyle(
                      color: const Color(0xFF0077b6),
                      fontSize: size.width * 0.024,
                      fontFamily: 'gotic',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    "Valor Premio: ${NumberFormat('#,##0', 'en_US').format(order.detallePremioFigura!.first.valorPremio ?? 0)}",
                    style: TextStyle(
                      color: const Color(0xFF0077b6),
                      fontSize: size.width * 0.024,
                      fontFamily: 'gotic',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ]),
                for (var adicionales
                    in order.detallePremioFigura!.first.listaAdicionales!)
                  Column(children: [
                    Text(
                      "Premio Adicional: ${adicionales.categoria}",
                      style: TextStyle(
                        color: const Color(0xFF0077b6),
                        fontSize: size.width * 0.024,
                        fontFamily: 'gotic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " Valor Premio:  ${NumberFormat('#,##0', 'en_US').format(adicionales.premioAdicional ?? 0)}",
                      style: TextStyle(
                        color: const Color(0xFF0077b6),
                        fontSize: size.width * 0.024,
                        fontFamily: 'gotic',
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ]),
                Text(
                  "Valor Total Adicionales:  ${NumberFormat('#,##0', 'en_US').format(totalPremioAdicional ?? 0)}",
                  style: TextStyle(
                    color: const Color(0xFF0077b6),
                    fontSize: size.width * 0.024,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                amount >= (listasetresponseListpagosuvt!.valorUvt! * totaluvt)
                    ? Padding(
                        padding: const EdgeInsets.all(4),
                        child: SizedBox(
                          width: size.width * 0.62,
                          height: size.height * 0.06,
                          child: TextFormField(
                            controller: dniController,
                            style: TextStyle(
                              color: const Color(0xFF424242),
                              fontSize: size.width * 0.04,
                            ),
                            decoration: InputDecoration(
                              floatingLabelStyle: TextStyle(
                                color: const Color(0xFF424242),
                                fontSize: size.width * 0.04,
                                fontWeight: FontWeight.bold,
                              ),
                              enabledBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              focusedBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.black,
                                  width: 2.0,
                                ),
                              ),
                              errorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF7CBF4F),
                                  width: 2.0,
                                ),
                              ),
                              focusedErrorBorder: const UnderlineInputBorder(
                                borderSide: BorderSide(
                                  color: Color(0xFF7CBF4F),
                                  width: 2.0,
                                ),
                              ),
                              labelText: "Ingrese DNI",
                              labelStyle: TextStyle(
                                color: const Color(0xFF424242),
                                fontSize: size.width * 0.04,
                              ),
                              isDense: true,
                              filled: true,
                              fillColor: const Color(0xFFcaf0f8),
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
                        style: TextStyle(
                            fontSize: size.width * 0.03,
                            color: const Color(0xFFcaf0f8)),
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
                        'Confirmar ${NumberFormat('#,##0', 'en_US').format(amount ?? 0)}',
                        style: TextStyle(
                            fontSize: size.width * 0.03,
                            color: const Color(0xFFcaf0f8)),
                      ),
                      onPressed: () async {
                        await getAmountUVT();

                        if (amount >=
                            (listasetresponseListpagosuvt!.valorUvt! *
                                totaluvt)) {
                          if (dniController.text == "") {
                            const snackBar = SnackBar(
                                content: Center(
                                    child: Text("Ingrese un DNI valido..")));
                            ScaffoldMessenger.of(context)
                                .showSnackBar(snackBar);
                          } else {
                            setState(() {
                              order.clienteId = dniController.text;
                              //order.detallePremioFigura!.first.estadoPago = 1;
                            });

                            await fetchShowscliente();
                            if (listasetresponseListpagoscliente == null) {
                              const snackBar = SnackBar(
                                  content: Center(
                                      child: Text("Ingrese un DNI valido..")));
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(snackBar);
                            } else {
                              if (listasetresponseListpagoscliente!.doi ==
                                      dniController.text &&
                                  listasetresponseListpagoscliente!.doi !=
                                      null) {
                                await registerWinner(order);
                              } else {
                                await Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UpdateUserPage(
                                          doi: dniController.text),
                                    ));
                              }
                            }
                          }
                        } else {
                          await registerWinner(order);
                        }

                        listWinners = getWinners();
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

  Future<Uvt?>? listasetuvt;
  Uvt? listasetresponseListpagosuvt;

  Future<Uvt?> getAmountUVT() async {
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);

    final url = Uri.parse("${pf.getIp.toString()}/api/ParametroInterno/GetAll");

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        listasetresponseListpagosuvt =
            uvtFromJson(utf8.decode(response.bodyBytes));
      });

      return listasetresponseListpagosuvt;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  Cliente? listasetresponseListpagoscliente;

  Future<Cliente?> fetchShowscliente() async {
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
      setState(() {
        listasetresponseListpagoscliente =
            clienteFromJson(utf8.decode(response.bodyBytes));
      });

      return listasetresponseListpagoscliente;
    } else {
      throw Exception('Failed to load shows');
    }
  }

  TextEditingController dniController = TextEditingController(text: "");

  Future<String> registerWinner(Pago elemento) async {
    String jsonBody = json.encode(elemento.toJson());

    print(jsonBody);
    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);
    final url = Uri.parse(
        "${pf.getIp.toString()}/api/PromotorInterno/RegistrarGanadorForPromotor");
    try {
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonBody);

      if (response.statusCode == 200) {
        const snackBar = SnackBar(
          content: Center(child: Text("Se ha confirmado el pago..")),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
        return "si";
      } else {
        const snackBar = SnackBar(
          content: Center(
              child: Center(
                  child: Text(
                      "No se ha confirmado el pago. Valide el valor UVT.."))),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);

        throw Exception('Failed to load shows');
      }
    } catch (e) {
      const snackBar = SnackBar(
          content: Center(
              child: Center(
                  child:
                      Text("No se ha confirmado el pago valide conexión."))));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);

      throw Exception('Failed to load shows');
    }
  }
}

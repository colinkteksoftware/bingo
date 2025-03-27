import 'package:bingo/models/clienteconvert.dart';
import 'package:bingo/models/pagosconvert.dart';
import 'package:bingo/models/uvtconvert.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'dart:convert';
import 'dart:io';

class WinnerProvider with ChangeNotifier {
  final pf = Preferencias();
  final ioc = HttpClient();
  List<Pago>? paymentsList;
  Cliente? customer;
  Uvt? uvt;
  bool isLoadingWinners = false;
  Uri url = Uri.parse('');

  Future<List<Pago>?> getWinners(String promotorId) async {
    isLoadingWinners = true;
    notifyListeners();

    try {
      final http = IOClient(ioc);
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      url = Uri.parse(
          "${pf.getIp.toString()}/api/PromotorInterno/GetGanadoresForPromotor/$promotorId");

      final response = await http.get(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});

      if (response.statusCode == 200) {
        paymentsList = pagoFromJson(utf8.decode(response.bodyBytes));
        //print('PAGOS PENDIENTES => ${pagoToJson(paymentsList!)}');
        isLoadingWinners = false;
        notifyListeners();
        return paymentsList;
      } else {
        isLoadingWinners = false;
        paymentsList = [];
        notifyListeners();
        throw Exception('Failed to load winners');
      }
    } catch (error) {
      isLoadingWinners = false;
      paymentsList = [];
      notifyListeners();
      throw Exception('Failed to load winners: $error');
    }
  }

  Future<Cliente?> findCustomer(String dni) async {
    try {
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      final http = IOClient(ioc);

      url = Uri.parse(
          '${pf.getIp.toString()}/api/ClienteInterno/GetClienteByDocumento/$dni');

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        customer = clienteFromJson(utf8.decode(response.bodyBytes));
        notifyListeners();
        return customer;
      } else {
        throw Exception('Failed to load customer');
      }
    } catch (error) {
      throw Exception('Failed to load winners: $error');
    }
  }

  Future<Uvt?> getAmountUVT() async {
    try {
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      url = Uri.parse("${pf.getIp.toString()}/api/ParametroInterno/GetAll");

      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        uvt = uvtFromJson(utf8.decode(response.bodyBytes));
        notifyListeners();
        return uvt;
      } else {
        throw Exception('Failed to load uvt');
      }
    } catch (error) {
      throw Exception('Failed to load uvt: $error');
    }
  }

  Future<void> registerWinner(
      BuildContext context, Pago payment, String promotorId) async {
    String jsonBody = json.encode(payment.toJson());
    //print('Pago realizado => $jsonBody');

    //bool exists = payment.detallePremioFigura!.any((element) => element.premioId == );

    ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;
    final http = IOClient(ioc);

    final url = Uri.parse(
        '${pf.getIp.toString()}/api/PromotorInterno/RegistrarGanadorForPromotor');

    /*print('URL WINNER => $url');
    print('DATA WINNER => $jsonBody');*/
    try {
      final response = await http.put(url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: jsonBody);
      //print('RESPONSE CODE => ${response.statusCode}');
      if (response.statusCode == 200) {
        const snackBar = SnackBar(
          content: Center(child: Text("Se ha confirmado el pago..")),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        Navigator.of(context).pop();
      } else {
        const snackBar = SnackBar(
          content: Center(
              child: Center(child: Text("No se ha confirmado el pago."))),
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

    await getWinners(promotorId);
    notifyListeners();
  }
}

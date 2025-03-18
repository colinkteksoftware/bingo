import 'package:bingo/models/pagosconvert.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'dart:convert';
import 'dart:io';

class WinnerProvider with ChangeNotifier {
  List<Pago>? listasetresponseListpagos;
  bool isLoading = false;

  Future<List<Pago>?> getWinners(String promotorId) async {
    final pf = Preferencias();
    isLoading = true;
    notifyListeners();

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback = (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);
      final url = Uri.parse(
        "${pf.getIp.toString()}/api/PromotorInterno/GetGanadoresForPromotor/$promotorId");

      final response = await http.get(url, headers: {'Content-Type': 'application/json; charset=UTF-8'});

      if (response.statusCode == 200) {
        listasetresponseListpagos = pagoFromJson(utf8.decode(response.bodyBytes));
        print('PAGOS PENDIENTES => ${pagoToJson(listasetresponseListpagos!)}');
        isLoading = false;
        notifyListeners();
        return listasetresponseListpagos;
      } else {
        isLoading = false;
        notifyListeners();
        throw Exception('Failed to load winners');
      }
    } catch (error) {
      isLoading = false;
      listasetresponseListpagos = [];
      notifyListeners();
      throw Exception('Failed to load winners: $error');
    }
  }
}



/*class WinnerProvider with ChangeNotifier {
  List<Pago>? listasetresponseListpagos;
  bool isLoading = false;

  Future<void> getWinners(String promotorId) async {
    final pf = Preferencias();
    isLoading = true;
    notifyListeners();

    try {
      final ioc = HttpClient();
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      final url = Uri.parse(
          "${pf.getIp.toString()}/api/PromotorInterno/GetGanadoresForPromotor/$promotorId");

      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json; charset=UTF-8'},
      );

      if (response.statusCode == 200) {
        listasetresponseListpagos = pagoFromJson(utf8.decode(response.bodyBytes));
        isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load winners');
      }
    } catch (error) {
      isLoading = false;
      notifyListeners();
      throw Exception('Failed to load winners: $error');
    }
  }
}*/

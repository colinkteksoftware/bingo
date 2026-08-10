import 'package:bingo/core/data/models/pagosconvert.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:http/io_client.dart';
import 'dart:convert';
import 'dart:io';

class WinnerProvider with ChangeNotifier {
  final pf = Preferencias();
  final ioc = HttpClient();
  List<Pago>? paymentsList;
  //Cliente? customer;
  //Uvt? uvt;
  bool isLoadingWinners = false;
  Uri url = Uri.parse('');

  Future<List<Pago>?> getWinners() async {
    isLoadingWinners = true;
    notifyListeners();

    try {
      final http = IOClient(ioc);
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;

      print('ganadores x promotor => ${pf.getPromotorId}');

      url = Uri.parse(
          '${pf.getIp.toString()}/api/JuegoClienteManual/GetGanadoresForPromotor?promotorId=${pf.getPromotorId ?? 0}');

      final response = await http.get(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'});

      if (response.statusCode == 200) {
        final dynamic decoded = json.decode(utf8.decode(response.bodyBytes));
        final dynamic data =
            decoded is Map<String, dynamic> ? decoded['data'] : decoded;

        if (data is List) {
          paymentsList = data
              .map((x) => Pago.fromJson(x as Map<String, dynamic>))
              .toList();
        } else {
          paymentsList = [];
        }
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

  /*Future<Uvt?> getAmountUVT() async {
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
  }*/
  
}

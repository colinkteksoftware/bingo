import 'dart:convert';
import 'dart:io';

import 'package:bingo/core/data/models/bingo.dart';
import 'package:bingo/core/data/models/bingoResponse.dart';
import 'package:bingo/core/data/models/clienteconvert.dart';
import 'package:bingo/core/data/models/pagosconvert.dart';
import 'package:bingo/core/data/models/uvtconvert.dart';
import 'package:bingo/core/data/models/winner.dart';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';
import 'package:provider/provider.dart';

class PaymentProvider extends ChangeNotifier {
  final pf = Preferencias();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? errorMessage;

  DateTime? _currentDate;
  DateTime get currentDate => _currentDate ?? DateTime.now();

  Bingo _bingo = Bingo();
  Bingo get bingo => _bingo;

  Uvt _uvt = Uvt();
  Uvt get uvt => _uvt;

  double _totalUvt = 0;
  double get totalUvt => _totalUvt;

  Cliente _customer = Cliente();
  Cliente get customer => _customer;

  List<Pago> _winners = [];
  List<Pago> get listWinners => _winners;

  Uri url = Uri.parse('');

  /*Future<void> getWinnersByBingo(BuildContext context) async {
    _isLoading = true;
    notifyListeners();

    url = Uri.parse(
        '${pf.getIp.toString()}/api/PromotorInterno/GetWinnersByBingo');

    try {
      Bingo bingo = Provider.of<BingoProvider>(context, listen: false).bingo;

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: jsonEncode(
              {"bingoId": bingo.bingoId, "promotorId": pf.getPromotorId}));

      if (response.statusCode == 200) {
        final Map<String, dynamic> info = json.decode(response.body);
        final data = BingoResponse.fromJson(info);
        /*print(' // ================================= //');
        print('informacion de ganadores');
        print(' // ================================= //');
        print('lista ganadores => ${data.ganadores.map((w) => w.toJson()).toList()}');*/
        _winners = [];
        for (var ganador in data.ganadores) {
          Pago pago = Pago();
          pago.bingoId = data.bingo.bingoId ?? 0;
          pago.cartillaId = ganador.cartillaId ?? 0;
          pago.clienteId = ganador.clienteId;
          pago.codigoModulo = ganador.codigoModulo ?? '';
          pago.detallePremioFigura = ganador.detallePremioFigura;
          pago.multiplicado = ganador.multiplicado ?? 0;
          pago.promotorId = ganador.promotorId ?? 0;
          pago.ventaId = ganador.ventaId ?? 0;
          pago.tipo = 1;
          _winners.add(pago);
        }
        updateBingo(data.bingo);
        //print('ganadores => ${_winners.map((e) => e.toJson()).toList()}');
        //print("Bingo actual => ${data.bingo.toString()}");
        //print('lista de ganadores => ${pagoToJson(listWinners)}');
      } else {
        _winners = [];
        throw Exception('Failed to load winners');
      }
      _isLoading = false;
      notifyListeners();
    } catch (error) {
      _isLoading = false;
      _winners = [];
      notifyListeners();
      throw Exception('Failed to load winners: $error');
    }
  }*/

  Future<void> getWinners(BuildContext context) async {
    _isLoading = true;
    _winners.clear();
    notifyListeners();

    //String ip = changeIp(pf.getIp.toString(), pf.getPromotorId);
    /*url = Uri.parse(
        'https://192.168.1.50:7881/api/JuegoClienteManual/GetGanadoresForPromotor?promotorId=${pf.getPromotorId}');*/
    url = Uri.parse(changeIp(pf.getIp.toString(), pf.getPromotorId));  // api-bingo

    //url = Uri.parse('${pf.getIp}/api/PromotorInterno/GetGanadoresForPromotor/4');  // api-app 
    //print('url converted => $ip');
    //print('buscando ganadores en => $url');

    try {
      final client = IOClient(HttpClient());

      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        //print('response => ${response.statusCode}');

        final Map<String, dynamic> info = json.decode(response.body);
        //print('respuesta => ${info.toString()}');

        final List<Pago> pagos =
            (info['data'] as List).map((e) => Pago.fromJson(e)).toList();

        /*print(' // ================================= //');
        print('informacion de ganadores');
        print(' // ================================= //');
        print('total ganadores => ${pagos.length}');
        print('primer ganador => ${pagos.first.detallePremioFigura}');
        print('lista ganadores => ${pagos.toString()}');*/

        /*for (var ganador in pagos) {
         //print('ganador => ${ganador.toJson()}');
          _winners.add(ganador);
        }*/
        _winners = pagos;

        _isLoading = false;
        notifyListeners();
      } else {
        throw Exception('Failed to load winners');
      }
    } catch (error) {
      _isLoading = false;
      _winners = [];
      notifyListeners();
      throw Exception('Failed to load winners: $error');
    }
  }

  Future<void> getAmountUVT() async {
    url = Uri.parse("${pf.getIp.toString()}/api/ParametroInterno/GetAll");
    updateUvt(Uvt());
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        _uvt = uvtFromJson(utf8.decode(response.bodyBytes));
        final valor = _uvt.valorUvt ?? 0;
        final cantidad = _uvt.cantidadUvt ?? 0;
        _totalUvt = valor * cantidad;
        /*print('valor uvt unitario => \$${_uvt.valorUvt}');
        print('cantidad uvt => ${_uvt.cantidadUvt}');
        print('valor uvt actualizado => \$$_totalUvt');*/
        updateUvt(_uvt);
      } else {
        throw Exception('Failed to load uvt');
      }
    } catch (error) {
      throw Exception('Failed to load uvt: $error');
    }
  }

  Future<void> findCustomer(String dni) async {
    url = Uri.parse(
        '${pf.getIp.toString()}/api/ClienteInterno/GetClienteByDocumento/$dni');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        var customer = clienteFromJson(utf8.decode(response.bodyBytes));
        updateCustomer(customer);
      } else {
        throw Exception('Failed to load customer');
      }
    } catch (error) {
      throw Exception('Failed to load winners: $error');
    }
  }

  Future<bool> registerWinner(BuildContext context, Pago payment) async {
    //String jsonBody = json.encode(payment.toJson());
    //print('Pago realizado => $jsonBody');

    url = Uri.parse(
        '${pf.getIp.toString()}/api/PromotorInterno/RegistrarGanadorForPromotor');

    /*print('URL WINNER => $url');
    print('DATA WINNER => $jsonBody');*/
    try {
      final response = await http.post(url,
          headers: {
            'Content-Type': 'application/json; charset=UTF-8',
          },
          body: json.encode(payment.toJson()));
      //print('RESPONSE CODE => ${response.statusCode}');
      if (response.statusCode == 200) {
        //await getWinnersByBingo(context);                               // abrir
        await getWinners(context);
        const snackBar = SnackBar(
          content: Center(child: Text("Se ha confirmado el pago..")),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return true;
      } else {
        const snackBar = SnackBar(
          content: Center(
              child: Center(child: Text("No se ha confirmado el pago."))),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
        //throw Exception('Failed to load shows');
      }
    } catch (e) {
      const snackBar = SnackBar(
          content: Center(
              child: Center(
                  child:
                      Text("No se ha confirmado el pago valide conexión."))));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
      //throw Exception('Failed to load shows');
    }
  }

  void updateBingo(Bingo info) {
    _bingo = info;
    notifyListeners();
  }

  void updateUvt(Uvt uvt) {
    _uvt = uvt;
    notifyListeners();
  }

  void updateCustomer(Cliente customer) {
    _customer = customer;
    notifyListeners();
  }
}

import 'dart:convert';
import 'package:bingo/models/bingoconvert.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';
import 'dart:io';
import 'package:bingo/utils/preferencias.dart';
import 'dart:async';

class BingoService {
  final pf = Preferencias();
  final httpcli = HttpClient();
  final ioc = IOClient();

  // Singleton para tener una única instancia de BingoService
  static final BingoService _singleton = BingoService._internal();
  factory BingoService() => _singleton;
  BingoService._internal();

  // StreamController para emitir los cambios
  final _bingoController = StreamController<List<Bingo>>.broadcast();

  // Lista de bingos (puedes obtenerlos de una API o base de datos)
  List<Bingo> _bingos = [];

  // Obtener el estado actual de los bingos
  List<Bingo> get getBingos => _bingos;

  // Getter para el Stream
  Stream<List<Bingo>> get bingoStream => _bingoController.stream;

  // Actualizar la lista de bingos
  void updateBingoState(List<Bingo> updatedBingos) {
    _bingos = updatedBingos;
    //print('Actualizando BingoState con ${_bingos.length} bingos');
    //print('BINGOS => ${_bingos.toString()}');
    _bingoController.sink.add(_bingos);
  }

  // Cerrar el StreamController cuando ya no se necesite
  void dispose() {
    _bingoController.close();
  }

  Future<List<BingoSala>?> fetchShowBingos(DateTime bingoFecha) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(bingoFecha);

    /*ioc.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;*/ //validacion de certficado

    //final http = IOClient(ioc);
    final url = Uri.parse(
        '${pf.getIp.toString()}/api/BingoPremioDetalleInterno/GetAll?Estado=1&FechaInicio=$formattedDate');

    try {
      final response = await ioc.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<BingoSala> data =
            bingoSalaFromMap(utf8.decode(response.bodyBytes));
        _bingos = data.map((bingoSala) => bingoSala.bingo).toList();
        updateBingoState(_bingos);
        return bingoSalaFromMap(utf8.decode(response.bodyBytes));
      } else {
        throw Exception('Failed to load shows');
      }
    } catch (e) {
      throw Exception('Server have not found response. Failed to load shows');
    }
  }

  Future<List<Bingo>> getBingosAvailaibles() async {
    DateTime date = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd').format(date);
    httpcli.badCertificateCallback =
        (X509Certificate cert, String host, int port) => true;

    final http = IOClient(httpcli);
    final url = Uri.parse(
        "${pf.getIp}/api/BingoPremioDetalleInterno/GetAll?Estado=1&FechaInicio=$formattedDate");
    //print('SEARCH BINGOS...');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        final List<BingoSala> data =
            bingoSalaFromMap(utf8.decode(response.bodyBytes));
        _bingos = data.map((bingoSala) => bingoSala.bingo).toList();
        updateBingoState(_bingos);
        return _bingos;
      } else {
        print('Failed to load shows');
        return [];
        //throw Exception('Failed to load shows');
      }
    } catch (e) {
      print('Server have not found response. Failed to load shows');
      return [];
      //throw Exception('Server have not found response. Failed to load shows');
    }
  }

  List<BingoSala> bingoSalaFromMap(String str) {
    final jsonData = json.decode(str) as List;
    return jsonData.map((item) => BingoSala.fromMap(item)).toList();
  }

  
}

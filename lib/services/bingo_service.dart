// lib/services/bingo_service.dart
import 'dart:convert';
import 'package:bingo/models/bingoconvert.dart';
import 'package:http/io_client.dart';
import 'package:intl/intl.dart';

class BingoService {
  Future<List<BingoSala>?> fetchShowsBingo(DateTime bingoFecha, String ip) async {
    String formattedDate = DateFormat('yyyy-MM-dd').format(bingoFecha);
   
    final ioc = IOClient();

    final url = Uri.parse(
        "$ip/api/BingoPremioDetalleInterno/GetAll?Estado=1&FechaInicio=$formattedDate");

    final response = await ioc.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {      
      return bingoSalaFromMap(utf8.decode(response.bodyBytes));
    } else {
      throw Exception('Failed to load shows');
    }
  }
}

import 'dart:convert';

import 'package:bingo/core/data/models/bingo.dart';
import 'package:bingo/core/data/models/modelpremio.dart';

class BingoSala {
  Bingo bingo;
  List<Premio> premios;

  BingoSala({required this.bingo, required this.premios});

  factory BingoSala.fromMap(Map<String, dynamic> map) {
    return BingoSala(
      bingo: Bingo.fromMap(map['bingo']),
      premios: List<Premio>.from(map['premios'].map((x) => Premio.fromMap(x))),
    );
  }

  Map<String, dynamic> toMap() => {
        "bingo": bingo.bingoToMap(),
        "premios": List<dynamic>.from(premios.map((x) => x.toMap())),
      };
}

List<BingoSala> bingoSalaFromMap(String str) {
  final jsonData = json.decode(str);
  var data = jsonData;
  if (data is! List) {
    data = [];
  }  
  print("Data procesada: $data");
  return data.map((item) {
    try {
      return BingoSala.fromMap(item);
    } catch (e) {
      print("Error al convertir item a BingoSala: $e");
      rethrow;
    }
  }).toList();
}

List<Bingo> obtenerBingos(List<BingoSala> bingosSala) {
  return bingosSala.map((bingoSala) => bingoSala.bingo).toList();
}

import 'dart:convert';

List<BingoSala> bingoSalaFromMap(String str) => List<BingoSala>.from(json.decode(str).map((x) => BingoSala.fromMap(x)));

String bingoSalaToMap(List<BingoSala> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class BingoSala {
    Bingo bingo;
 
    BingoSala({
        required this.bingo   
    });

    factory BingoSala.fromMap(Map<String, dynamic> json) => BingoSala(
        bingo: Bingo.fromMap(json["bingo"]),

    );

    Map<String, dynamic> toMap() => {
        "bingo": bingo.toMap()
    };
}

class Bingo {
    int bingoId;
    DateTime fecha;
    String descripcion;
    double precioPorCartilla;
    int presupuestoPremio;
    int tipoBalotario;
    int tipoOrigen;
    String tipo;
    int estado;

    Bingo({
        required this.bingoId,
        required this.fecha,
        required this.descripcion,
        required this.precioPorCartilla,
        required this.presupuestoPremio,
        required this.tipoBalotario,
        required this.tipoOrigen,
        required this.tipo,
        required this.estado,
    });

    factory Bingo.fromMap(Map<String, dynamic> json) => Bingo(
        bingoId: json["bingoId"],
        fecha: DateTime.parse(json["fecha"]),
        descripcion: json["descripcion"],
        precioPorCartilla: json["precioPorCartilla"]?.toDouble(),
        presupuestoPremio: json["presupuestoPremio"],
        tipoBalotario: json["tipoBalotario"],
        tipoOrigen: json["tipoOrigen"],
        tipo: json["tipo"],
        estado: json["estado"],
    );

    Map<String, dynamic> toMap() => {
        "bingoId": bingoId,
        "fecha": fecha.toIso8601String(),
        "descripcion": descripcion,
        "precioPorCartilla": precioPorCartilla,
        "presupuestoPremio": presupuestoPremio,
        "tipoBalotario": tipoBalotario,
        "tipoOrigen": tipoOrigen,
        "tipo": tipo,
        "estado": estado,
    };
}
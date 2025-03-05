// To parse this JSON data, do
//
//     final show = showFromJson(jsonString);

import 'dart:convert';


List<Sala> salaFromMap(String str) => List<Sala>.from(json.decode(str).map((x) => Sala.fromMap(x)));

String salaToMap(List<Sala> data) => json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Sala {
    Bingo bingo;
 

    Sala({
        required this.bingo,
   
    });

    factory Sala.fromMap(Map<String, dynamic> json) => Sala(
        bingo: Bingo.fromMap(json["bingo"]),

    );

    Map<String, dynamic> toMap() => {
        "bingo": bingo.toMap(),

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
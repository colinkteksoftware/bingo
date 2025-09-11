import 'dart:convert';

class ModelGanadoresEstadistica {
  ModelGanadoresEstadistica({
    required this.nomSala,
    required this.progresivoId,
    required this.cantidad,
    required this.monto,
    required this.pozoId,
    required this.nombrePozo,
    required this.estadoPago,
    required this.estadoP,
  });

  String nomSala;
  int progresivoId;
  int cantidad;
  double monto;
  int pozoId;
  String nombrePozo;
  int estadoPago;
  String estadoP;

  factory ModelGanadoresEstadistica.fromJson(String str) =>
      ModelGanadoresEstadistica.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelGanadoresEstadistica.fromMap(Map<String, dynamic> json) =>
      ModelGanadoresEstadistica(
        nomSala: json["nomSala"],
        progresivoId: json["progresivoID"],
        cantidad: json["cantidad"],
        monto: json["monto"].toDouble(),
        pozoId: json["pozoId"],
        nombrePozo: json["nombrePozo"],
        estadoPago: json["estadoPago"],
        estadoP: json["estadoP"],
      );

  Map<String, dynamic> toMap() => {
        "nomSala": nomSala,
        "progresivoID": progresivoId,
        "cantidad": cantidad,
        "monto": monto,
        "pozoId": pozoId,
        "nombrePozo": nombrePozo,
        "estadoPago": estadoPago,
        "estadoP": estadoP,
      };
}

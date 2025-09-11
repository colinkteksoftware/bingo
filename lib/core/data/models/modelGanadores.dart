import 'dart:convert';

class ModelGanadores {
  ModelGanadores({
    required this.nomSala,
    required this.slotId,
    required this.fecha,
    required this.fechaPago,
    required this.monto,
    required this.dniGanador,
    required this.nombreGanador,
    required this.estadoPago,
    required this.pozoId,
    required this.nombrePozo,
    required this.estadoP,
  });

  String nomSala;
  String slotId;
  DateTime fecha;
  DateTime fechaPago;
  double monto;
  String dniGanador;
  String nombreGanador;
  int estadoPago;
  int pozoId;
  String nombrePozo;
  String estadoP;

  factory ModelGanadores.fromJson(String str) =>
      ModelGanadores.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelGanadores.fromMap(Map<String, dynamic> json) => ModelGanadores(
        nomSala: json["nomSala"],
        slotId: json["slotID"],
        fecha: DateTime.parse(json["fecha"]),
        fechaPago: DateTime.parse(json["fechaPago"]),
        monto: json["monto"].toDouble(),
        dniGanador: json["dniGanador"],
        nombreGanador: json["nombreGanador"],
        estadoPago: json["estadoPago"],
        pozoId: json["pozoId"],
        nombrePozo: json["nombrePozo"],
        estadoP: json["estadoP"],
      );

  Map<String, dynamic> toMap() => {
        "nomSala": nomSala,
        "slotID": slotId,
        "fecha": fecha.toIso8601String(),
        "fechaPago": fechaPago.toIso8601String(),
        "monto": monto,
        "dniGanador": dniGanador,
        "nombreGanador": nombreGanador,
        "estadoPago": estadoPago,
        "pozoId": pozoId,
        "nombrePozo": nombrePozo,
        "estadoP": estadoP,
      };
}

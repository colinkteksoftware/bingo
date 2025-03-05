import 'dart:convert';

class Modelpozos {
  Modelpozos(
      {required this.nomsala,
      required this.pozoId,
      required this.detalleProgresivoId,
      required this.montoActual,
      required this.fecha,
      required this.tipoPozo,
      required this.nombrePozo,
      required this.progresivoID});

  String nomsala;
  int pozoId;
  int detalleProgresivoId;
  double montoActual;
  DateTime fecha;
  int tipoPozo;
  String nombrePozo;
  int progresivoID;

  factory Modelpozos.fromJson(String str) =>
      Modelpozos.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory Modelpozos.fromMap(Map<String, dynamic> json) => Modelpozos(
        nomsala: json["nomsala"],
        pozoId: json["pozoId"],
        detalleProgresivoId: json["detalleProgresivoID"],
        montoActual: json["montoActual"].toDouble(),
        fecha: DateTime.parse(json["fecha"]),
        tipoPozo: json["tipoPozo"],
        nombrePozo: json["nombrePozo"],
        progresivoID: json["progresivoID"],
      );

  Map<String, dynamic> toMap() => {
        "nomsala": nomsala,
        "pozoId": pozoId,
        "detalleProgresivoID": detalleProgresivoId,
        "montoActual": montoActual,
        "fecha": fecha.toIso8601String(),
        "tipoPozo": tipoPozo,
        "nombrePozo": nombrePozo,
        "progresivoID": progresivoID,
      };




}

class ModelpozosMaster {
  ModelpozosMaster(
      {required this.nombrePozo,
      required this.mini,
      required this.maxi,
      required this.mega,
      required this.idPozo,
      required this.progresivoID});

  String nombrePozo;
  double mini;
  double maxi;
  double mega;
  int idPozo;
  int progresivoID;
}

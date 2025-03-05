// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

List<Detalle> chatFromJson(String str) => List<Detalle>.from(json.decode(str).map((x) => Detalle.fromJson(x)));

String chatToJson(List<Detalle> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Detalle {
    int? id_sala;
    String? contrato;
    int? tipoProceso;
   DateTime? fecha;
    int? estado;
    String? descripcionProceso;


    Detalle({
        this.id_sala,
        this.contrato,
        this.tipoProceso,
        this.fecha,
        this.estado,
        this.descripcionProceso,
     
    });

    factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        id_sala: json["id_sala"] == null ?0:json["id_sala"],
        contrato: json["contrato"] == null ?"":json["contrato"],
        tipoProceso: json["tipoProceso"] == null ?0:json["tipoProceso"],
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        estado: json["estado"] == null ?0:json["estado"],
        descripcionProceso: json["descripcionProceso"] == null ?"":json["descripcionProceso"],
    
    );

    Map<String, dynamic> toJson() => {
        "id_sala": id_sala,
        "contrato": contrato,
        "tipoProceso": tipoProceso,
        "fecha": fecha?.toIso8601String(),
        "estado": estado,
        "descripcionProceso": descripcionProceso,
   
    };
}

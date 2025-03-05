// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

List<Proceso> chatFromJson(String str) => List<Proceso>.from(json.decode(str).map((x) => Proceso.fromJson(x)));

String chatToJson(List<Proceso> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Proceso {
    int? id_sala;
    String? contrato;
    int? tipoProceso;
    String? foto;
    int? estado;
    String? nombreproceso;


    Proceso({
        this.id_sala,
        this.contrato,
        this.tipoProceso,
        this.foto,
        this.estado,
        this.nombreproceso,
     
    });

    factory Proceso.fromJson(Map<String, dynamic> json) => Proceso(
        id_sala: json["id_sala"] == null ?0:json["id_sala"],
        contrato: json["contrato"] == null ?"":json["contrato"],
        tipoProceso: json["tipoProceso"] == null ?0:json["tipoProceso"],
        foto: json["foto"] == null ?"":json["foto"],
        estado: json["estado"] == null ?0:json["estado"],
        nombreproceso: json["nombreproceso"] == null ?"":json["nombreproceso"],
    
    );

    Map<String, dynamic> toJson() => {
        "id_sala": id_sala,
        "contrato": contrato,
        "tipoProceso": tipoProceso,
        "foto": foto,
        "estado": estado,
        "nombreproceso": nombreproceso,
   
    };
}

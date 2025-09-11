// To parse this JSON data, do
//
//     final promotor = promotorFromJson(jsonString);

import 'dart:convert';

Cliente clienteFromJson(String str) => Cliente.fromJson(json.decode(str));

String clienteToJson(Cliente data) => json.encode(data.toJson());

class Cliente {
    int? clienteId;
    int? extranetId;
    int? synchronizer;
    String? nombres;
    String? apellidos;
    int? tipoDocumento;
    String? doi;
    String? direccion;
    String? departamento;
    String? email;
    String? telefono;
    DateTime? fechaRegistro;

    Cliente({
        this.clienteId,
        this.extranetId,
        this.synchronizer,
        this.nombres,
        this.apellidos,
        this.tipoDocumento,
        this.doi,
        this.direccion,
        this.departamento,
        this.email,
        this.telefono,
        this.fechaRegistro,
    });

    factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        clienteId: json["clienteId"],
        extranetId: json["extranetId"],
        synchronizer: json["synchronizer"],
        nombres: json["nombres"],
        apellidos: json["apellidos"],
        tipoDocumento: json["tipoDocumento"],
        doi: json["doi"],
        direccion: json["direccion"],
        departamento: json["departamento"],
        email: json["email"],
        telefono: json["telefono"],
        fechaRegistro: json["fechaRegistro"] == null ? null : DateTime.parse(json["fechaRegistro"]),
    );

    Map<String, dynamic> toJson() => {
        "clienteId": clienteId,
        "extranetId": extranetId,
        "synchronizer": synchronizer,
        "nombres": nombres,
        "apellidos": apellidos,
        "tipoDocumento": tipoDocumento,
        "doi": doi,
        "direccion": direccion,
        "departamento": departamento,
        "email": email,
        "telefono": telefono,
        "fechaRegistro": fechaRegistro?.toIso8601String(),
    };
}

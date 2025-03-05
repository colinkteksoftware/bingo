// To parse this JSON data, do
//
//     final promotor = promotorFromJson(jsonString);

import 'dart:convert';

Promotor promotorFromJson(String str) => Promotor.fromJson(json.decode(str));

String promotorToJson(Promotor data) => json.encode(data.toJson());

class Promotor {
    int? parametroTransmisionId;
    String? usuarioOperador;
    String? nit;
    String? contrato;
    dynamic codigoLocal;
    String? municipio;
    int? identificacionBingo;
    int? cantidadUvt;
    double? valorUvt;
    String? claveFabricante;
    String? codigoSha;

    Promotor({
        this.parametroTransmisionId,
        this.usuarioOperador,
        this.nit,
        this.contrato,
        this.codigoLocal,
        this.municipio,
        this.identificacionBingo,
        this.cantidadUvt,
        this.valorUvt,
        this.claveFabricante,
        this.codigoSha,
    });

    factory Promotor.fromJson(Map<String, dynamic> json) => Promotor(
        parametroTransmisionId: json["parametroTransmisionId"],
        usuarioOperador: json["usuarioOperador"],
        nit: json["nit"],
        contrato: json["contrato"],
        codigoLocal: json["codigoLocal"] == null ? "":json["codigoLocal"],
        municipio: json["municipio"],
        identificacionBingo: json["identificacionBingo"],
        cantidadUvt: json["cantidadUvt"],
        valorUvt: json["valorUvt"] == null ?0.0: double.parse(json["valorUvt"].toString()),
        claveFabricante: json["claveFabricante"],
        codigoSha: json["codigoSHA"],
    );

    Map<String, dynamic> toJson() => {
        "parametroTransmisionId": parametroTransmisionId,
        "usuarioOperador": usuarioOperador,
        "nit": nit,
        "contrato": contrato,
        "codigoLocal": codigoLocal,
        "municipio": municipio,
        "identificacionBingo": identificacionBingo,
        "cantidadUvt": cantidadUvt,
        "valorUvt": valorUvt,
        "claveFabricante": claveFabricante,
        "codigoSHA": codigoSha,
    };
}

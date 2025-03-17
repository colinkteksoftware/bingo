// To parse this JSON data, do
//
//     final promotor = promotorFromJson(jsonString);

import 'dart:convert';

Uvt uvtFromJson(String str) => Uvt.fromJson(json.decode(str));

String uvtToJson(Uvt data) => json.encode(data.toJson());

class Uvt {
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

    Uvt({
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

    factory Uvt.fromJson(Map<String, dynamic> json) => Uvt(
        parametroTransmisionId: json["parametroTransmisionId"],
        usuarioOperador: json["usuarioOperador"],
        nit: json["nit"],
        contrato: json["contrato"],
        codigoLocal: json["codigoLocal"] ?? "",
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

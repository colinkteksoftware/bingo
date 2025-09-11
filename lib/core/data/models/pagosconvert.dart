import 'dart:convert';

import 'package:bingo/core/data/models/detallePremioFigura.dart';

class Pago {
    int? clienteId;
    int? cartillaId;
    int? bingoId;
    int? ventaId;
    int? promotorId;
    String? codigoModulo;
    int? multiplicado;
    int? tipo;
    List<DetallePremioFigura>? detallePremioFigura;
    List<Map<String, int>>? ventasDetalle;
      
    Pago({
        this.clienteId,
        this.bingoId,
        this.ventaId,
        this.cartillaId,
        this.codigoModulo,
        this.detallePremioFigura,
        this.promotorId,
        this.multiplicado,
        this.tipo,
        this.ventasDetalle
    });

    factory Pago.fromJson(Map<String, dynamic> json) => Pago(
        clienteId: json["clienteId"],
        bingoId: json["bingoId"],
        ventaId: json["ventaId"],
        cartillaId: json["cartillaId"],
        codigoModulo: json["codigoModulo"],
        detallePremioFigura: json["detallePremioFigura"] == null ? [] : List<DetallePremioFigura>.from(json["detallePremioFigura"]!.map((x) => DetallePremioFigura.fromJson(x))),
        promotorId: json['promotorId'],
        multiplicado: json['multiplicado'],
        tipo: json['tipo'],
        ventasDetalle: json['ventasDetalle']
    );

    Map<String, dynamic> toJson() => {
        "clienteId": clienteId,
        "bingoId": bingoId,
        "ventaId": ventaId,
        "cartillaId": cartillaId,
        "codigoModulo": codigoModulo,
        "detallePremioFigura": detallePremioFigura == null ? [] : List<dynamic>.from(detallePremioFigura!.map((x) => x.toJson())),
        "promotorId": promotorId,
        "multiplicado": multiplicado,
        "tipo": tipo,
        "ventasDetalle": ventasDetalle
    };
}

List<Pago> pagoFromJson(String str) => List<Pago>.from(json.decode(str).map((x) => Pago.fromJson(x)));

String pagoToJson(List<Pago> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
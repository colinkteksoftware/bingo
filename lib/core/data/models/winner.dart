import 'dart:convert';

import 'package:bingo/core/data/models/detallePremioFigura.dart';

class Winner {
  int? clienteId;
  int? cartillaId;
  int? bingoId;
  int? ventaId;
  int? promotorId;
  String? codigoModulo;
  int? multiplicado;
  bool? isGanador;
  List<DetallePremioFigura>? detallePremioFigura;
  String? fechaGanador;
  bool? isVisiblePromotor;

  Winner({
    this.clienteId,
    this.cartillaId,
    this.bingoId,
    this.ventaId,
    this.promotorId,
    this.codigoModulo,
    this.multiplicado,
    this.isGanador,
    this.detallePremioFigura,
    this.fechaGanador,
    this.isVisiblePromotor,
  });

  factory Winner.fromJson(Map<String, dynamic> json) {
    final detalleStr = json['detallePremioFigura'] ?? '[]';
    final detalleList = (jsonDecode(detalleStr) as List)
        .map((e) => DetallePremioFigura.fromJson(e))
        .toList();

    return Winner(
      clienteId: json["clienteId"] ?? 0,
      cartillaId: json["cartillaId"] ?? 0,
      bingoId: json["bingoId"],
      ventaId: json["ventaId"],
      promotorId: json["promotorId"],
      codigoModulo: json["codigoModulo"],
      multiplicado: json["multiplicado"],
      isGanador: json["isGanador"],
      detallePremioFigura: detalleList,
      fechaGanador: json["fechaGanador"] ?? '',
      isVisiblePromotor: json["isVisiblePromotor"],
    );
  }

  Map<String, dynamic> toJson() => {
        "clienteId": clienteId,
        "cartillaId": cartillaId,
        "bingoId": bingoId,
        "ventaId": ventaId,
        "promotorId": promotorId,
        "codigoModulo": codigoModulo,
        "multiplicado": multiplicado,
        "isGanador": isGanador,
        "detallePremioFigura": detallePremioFigura == null
            ? []
            : List<dynamic>.from(detallePremioFigura!.map((x) => x.toJson())),
        "fechaGanador": fechaGanador,
        "isVisiblePromotor": isVisiblePromotor,
      };
}

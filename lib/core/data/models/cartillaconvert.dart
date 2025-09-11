import 'dart:convert';

import 'package:bingo/core/data/models/booklet.dart';

class Cartilla {
  int? cartillaGrupoDetalleId;
  String? nombreGrupo;
  String? grupoCartillas;
  List<Booklet> listCartillas = [];

  Cartilla(
      {this.cartillaGrupoDetalleId,
      this.nombreGrupo,
      this.grupoCartillas,
      required this.listCartillas});

  factory Cartilla.fromJson(Map<String, dynamic> json) => Cartilla(
      cartillaGrupoDetalleId: json["cartillaGrupoDetalleId"] ?? 0,
      nombreGrupo: json["nombreGrupo"] ?? '',
      grupoCartillas: json["grupoCartillas"] ?? '',
      listCartillas: json['listCartillas'] ?? []);

  Map<String, dynamic> toJson() => {
        "cartillaGrupoDetalleId": cartillaGrupoDetalleId,
        "nombreGrupo": nombreGrupo,
        "grupoCartillas": grupoCartillas,
        'listCartillas': listCartillas
      };

  @override
  String toString() {
    return 'Cartilla(cartillaGrupoDetalleId: $cartillaGrupoDetalleId, nombreGrupo: $nombreGrupo, grupoCartillas: $grupoCartillas, listCartillas: $listCartillas)';
  }
}

Cartilla cartillaFromJson(String str) => Cartilla.fromJson(json.decode(str));

String cartillaToJson(Cartilla data) => json.encode(data.toJson());

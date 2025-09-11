import 'dart:convert';

import 'package:bingo/core/data/models/bingo.dart';

class SaleQuery {
  int? promotorId;
  int? bingoId;
  int? ventaId;
  int? clienteId;
  String? codigoModulo;
  int? multiplicado;
  int? tipo;
  Bingo? bingo;
  List<Map<String, int>>? ventasDetalle;

  SaleQuery({
    this.promotorId,
    this.bingoId,
    this.ventaId,
    this.clienteId,
    this.codigoModulo,
    this.multiplicado,
    this.tipo,
    this.bingo,
    this.ventasDetalle,
  });

  factory SaleQuery.fromJson(String str) =>
      SaleQuery.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory SaleQuery.fromMap(Map<String, dynamic> json) => SaleQuery(
      promotorId: json['promotorId'] ?? 0,
      bingoId: json['bingoId'] ?? 0,
      ventaId: json['ventaId'] ?? 0,
      clienteId: json['clienteId'] ?? 0,
      codigoModulo: json['codigoModulo'] ?? '',
      multiplicado: json['multiplicado'] ?? 0,
      tipo: json['tipo'] ?? 0,
      bingo: json['bingo'] ?? Bingo(),
      ventasDetalle: json['ventasDetalle'] ?? []);

  Map<String, dynamic> toMap() {
    return {
      'promotorId': promotorId,
      'bingoId': bingoId,
      'ventaId': ventaId,
      'clienteId': clienteId,
      'codigoModulo': codigoModulo,
      'multiplicado': multiplicado,
      'tipo': tipo,
      'bingo': bingo,
      'ventasDetalle': ventasDetalle
    };
  }
}
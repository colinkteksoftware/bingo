import 'dart:convert';

class RequestQuery {
  bool? isGlobal;
  bool? isIndividual;
  String? fechaInicio;
  String? fechaFin;
  int? estado;

  RequestQuery({
    this.isGlobal,
    this.isIndividual,
    this.fechaInicio,
    this.fechaFin,
    this.estado,
  });

  factory RequestQuery.fromJson(String str) =>
      RequestQuery.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory RequestQuery.fromMap(Map<String, dynamic> json) => RequestQuery(
      isGlobal: json['isGlobal'] ?? false,
      isIndividual: json['isIndividual'] ?? false,
      fechaInicio: json['fechaInicio'] ?? '',
      fechaFin: json['fechaFin'] ?? '',
      estado: json['estado'] ?? 0);

  Map<String, dynamic> toMap() {
    return {
      'isGlobal': isGlobal,
      'isIndividual': isIndividual,
      'fechaInicio': fechaInicio,
      'fechaFin': fechaFin,
      'estado': estado,
    };
  }
}

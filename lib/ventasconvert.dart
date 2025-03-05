import 'dart:convert';

List<Bingo> salaFromMap(String str) =>
    List<Bingo>.from(json.decode(str).map((x) => Bingo.fromMap(x)));

String salaToMap(List<Bingo> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class Bingo {
  int? ventaId;
  String? codigoModulo;
  DateTime? fechaRegistro;
  int? multiplicado;
  int? estado;
  String? bingo;
  String? cliente;
  int? tipo;
  double? precioTotalCartilla;
  int? totalCartillas;

  Bingo({
    required this.ventaId,
    required this.codigoModulo,
    required this.fechaRegistro,
    required this.multiplicado,
    required this.estado,
    required this.bingo,
    required this.cliente,
    required this.tipo,
    required this.precioTotalCartilla,
    required this.totalCartillas,
  });

  factory Bingo.fromMap(Map<String, dynamic> json) => Bingo(
        ventaId: json["ventaId"] ?? 0,
        codigoModulo: json["codigoModulo"] ?? "",
        fechaRegistro: DateTime.parse(json["fechaRegistro"]),
        multiplicado: json["multiplicado"] ?? 0,
        estado: json["estado"] ?? 0,
        bingo: json["bingo"] ?? "",
        cliente: json["cliente"] ?? "",
        tipo: json["tipo"] ?? 0,
        precioTotalCartilla: json["precioTotalCartilla"] == null
            ? 0.0
            : double.parse(json["precioTotalCartilla"].toString()),
        totalCartillas: json["totalCartillas"] ?? 0,
      );

  Map<String, dynamic> toMap() => {
        "ventaId": ventaId,
        "codigoModulo": codigoModulo,
        "fechaRegistro": fechaRegistro!.toIso8601String(),
        "multiplicado": multiplicado,
        "estado": estado,
        "bingo": bingo,
        "cliente": cliente,
        "tipo": tipo,
        "precioTotalCartilla": precioTotalCartilla,
        "totalCartillas": totalCartillas,
      };
}

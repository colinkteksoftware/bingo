import 'dart:convert';

class ModelProductoUpdate {
  ModelProductoUpdate({
    this.id_producto,
    this.id_sala,
    this.stock,
    this.puntoscanje,
    this.estado,
    this.foto,
    this.contrato,
    this.descripcion,
    this.fechaRedencion,
  });

  int? id_producto;
  int? id_sala;
  int? stock;
  int? puntoscanje;
  int? estado;
  String? foto;
  String? contrato;
  String? descripcion;
  DateTime? fechaRedencion;

  factory ModelProductoUpdate.fromJson(String str) =>
      ModelProductoUpdate.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelProductoUpdate.fromMap(Map<String, dynamic> json) =>
      ModelProductoUpdate(
        id_producto: json["id_producto"] == null ? 0 : json["id_producto"],
        id_sala: json["id_sala"] == null ? 0 : json["id_sala"],
        stock: json["stock"] == null ? 0 : json["stock"],
        puntoscanje: json["puntoscanje"] == null ? 0 : json["puntoscanje"],
        estado: json["estado"] == null ? 0 : json["estado"],
        foto: json["foto"] == null ? "" : json["foto"],
        contrato: json["contrato"] == null ? "" : json["contrato"],
        descripcion: json["descripcion"] == null ? "" : json["descripcion"],
        fechaRedencion: DateTime.parse(json["fechaRedencion"]),
      );

  Map<String, dynamic> toMap() => {
        "id_producto": id_producto,
        "id_sala": id_sala,
        "stock": stock,
        "puntoscanje": puntoscanje,
        "estado": estado,
        "foto": foto,
        "contrato": contrato,
        "descripcion": descripcion,
        "fechaRedencion": fechaRedencion!.toIso8601String(),
      };
}

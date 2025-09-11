import 'dart:convert';

class ModelPromotor {
  int? promotorId;
  String? nombres;
  String? apellidos;
  int? tipoDocumento;
  String? doi;
  String? telefono;
  String? usuario;
  String? password;
  bool? estado;
  int? tipousuario;
  double? comision;

  ModelPromotor({
    this.promotorId,
    this.nombres,
    this.apellidos,
    this.tipoDocumento,
    this.doi,
    this.telefono,
    this.usuario,
    this.password,
    this.estado,
    this.tipousuario,
    this.comision,
  });

  factory ModelPromotor.fromJson(String str) =>
      ModelPromotor.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelPromotor.fromMap(Map<String, dynamic> json) => ModelPromotor(
        promotorId: json["promotorId"] ?? 0,
        nombres: json["nombres"] ?? "",
        apellidos: json["apellidos"] ?? "",
        tipoDocumento: json["tipoDocumento"] ?? 0,
        doi: json["doi"] ?? "",
        telefono: json["telefono"] ?? "",
        usuario: json["usuario"] ?? "",
        password: json["password"] ?? "",
        estado: json["estado"] ?? false,
        tipousuario: json["tipousuario"] ?? 0,
        comision: json["comision"] == null
            ? 0.0
            : double.parse(json["comision"].toString()),
      );

  Map<String, dynamic> toMap() => {
        "promotorId": promotorId,
        "nombres": nombres,
        "apellidos": apellidos,
        "tipoDocumento": tipoDocumento,
        "doi": doi,
        "telefono": telefono,
        "usuario": usuario,
        "password": password,
        "estado": estado,
        "tipousuario": tipousuario,
        "comision": comision,
      };
}

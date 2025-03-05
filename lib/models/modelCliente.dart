import 'dart:convert';

class ModelCliente {
  ModelCliente({

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

  factory ModelCliente.fromJson(String str) =>
      ModelCliente.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelCliente.fromMap(Map<String, dynamic> json) =>
      ModelCliente(


       
promotorId: json["promotorId"] == null ? 0: json["promotorId"],
nombres: json["nombres"] == null ? "": json["nombres"],
apellidos: json["apellidos"] == null ? "": json["apellidos"],
tipoDocumento: json["tipoDocumento"] == null ? 0: json["tipoDocumento"],
doi: json["doi"] == null ? "": json["doi"],
telefono: json["telefono"] == null ? "": json["telefono"],
usuario: json["usuario"] == null ? "": json["usuario"],
password: json["password"] == null ? "": json["password"],
estado: json["estado"] == null ? false: json["estado"],
tipousuario: json["tipousuario"] == null ? 0: json["tipousuario"],
comision: json["comision"] == null ? 0.0 : double.parse( json["comision"].toString()),

       
      );

  Map<String, dynamic> toMap() => {

"promotorId":promotorId,
"nombres":nombres,
"apellidos":apellidos,
"tipoDocumento":tipoDocumento,
"doi":doi,
"telefono":telefono,
"usuario":usuario,
"password":password,
"estado":estado,
"tipousuario":tipousuario,
"comision":comision,
      };
}


  
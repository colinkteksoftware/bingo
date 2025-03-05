import 'dart:convert';

class ModelProducto {
  ModelProducto({



this.id_sala,
this.stock,
this.puntoscanje,
this.estado,
this.foto,
this.contrato,
this.descripcion,
     
  });




int? id_sala;
int? stock;
int? puntoscanje;
int? estado;
 String? foto;
String? contrato;
String? descripcion;

 

  factory ModelProducto.fromJson(String str) =>
      ModelProducto.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelProducto.fromMap(Map<String, dynamic> json) =>
      ModelProducto(


      
  
 id_sala: json["id_sala"] == null ?0:json["id_sala"],
 stock: json["stock"] == null ?0:json["stock"],
 puntoscanje: json["puntoscanje"] == null ?0:json["puntoscanje"],
 estado: json["estado"] == null ?0:json["estado"],
  foto: json["foto"] == null ? "":json["foto"],
 contrato: json["contrato"] == null ? "":json["contrato"],
 descripcion: json["descripcion"] == null ? "":json["descripcion"],

       
      );

  Map<String, dynamic> toMap() => {

"id_sala":id_sala,
"stock":stock,
"puntoscanje":puntoscanje,
"estado":estado,
"foto":foto,
"contrato":contrato,
"descripcion":descripcion,
      };
}

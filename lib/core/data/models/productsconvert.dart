// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

List<Producto> chatFromJson(String str) => List<Producto>.from(json.decode(str).map((x) => Producto.fromJson(x)));

String chatToJson(List<Producto> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));
 
  
class Producto {
int? id_producto;
int? id_sala;
int? stock;
int? puntoscanje;
int? estado;
 String? foto;
String? contrato;
String? descripcion;


    Producto({
    this.id_producto,
this.id_sala,
this.stock,
this.puntoscanje,
this.estado,
this.foto,
this.contrato,
this.descripcion,
     
    });

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(

       id_producto: json["id_producto"] == null ?0:json["id_producto"],
 id_sala: json["id_sala"] == null ?0:json["id_sala"],
 stock: json["stock"] == null ?0:json["stock"],
 puntoscanje: json["puntoscanje"] == null ?0:json["puntoscanje"],
 estado: json["estado"] == null ?0:json["estado"],
  foto: json["foto"] == null ? "":json["foto"],
 contrato: json["contrato"] == null ? "":json["contrato"],
 descripcion: json["descripcion"] == null ? "":json["descripcion"],



    
    );

    Map<String, dynamic> toJson() => {
     "id_producto":id_producto,
"id_sala":id_sala,
"stock":stock,
"puntoscanje":puntoscanje,
"estado":estado,
"foto":foto,
"contrato":contrato,
"descripcion":descripcion,
   
    };
}

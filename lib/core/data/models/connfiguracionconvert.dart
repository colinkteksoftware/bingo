import 'dart:convert';

// Función para convertir el JSON en una lista de objetos Sala
List<Configuracion> salaFromJson(String str) =>
    List<Configuracion>.from(json.decode(str).map((x) => Configuracion.fromJson(x)));

// Función para convertir la lista de objetos Sala a JSON
String salaToJson(List<Configuracion> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Configuracion {
  Configuracion({
 this.contrato,
this.idSala,
this.nombreConfiguracion,
this.puntosJuego,
this.multiplicador,
this.vecesDiarios,
this.ganados,
this.fechaInicioPromocion,
this.mesesVigentes,
this.descripcion,
this.estado,
  });




 String? contrato;
 int? idSala;
 String? nombreConfiguracion;
 int? puntosJuego;
  int? multiplicador;
 int? vecesDiarios;
int? ganados;
 String? fechaInicioPromocion;
 int? mesesVigentes;
 String? descripcion;
 int? estado;
  factory Configuracion.fromJson(Map<String, dynamic> json) => Configuracion(

    contrato: json["contrato"] == null ? "": json["contrato"],
idSala: json["idSala"] == null ? 0: json["idSala"],
nombreConfiguracion: json["nombreConfiguracion"] == null ? "" : json["nombreConfiguracion"],
puntosJuego: json["puntosJuego"] == null ?0 : json["puntosJuego"],
multiplicador: json["multiplicador"] == null ? 0 : json["multiplicador"],
vecesDiarios: json["vecesDiarios"] == null ? 0: json["vecesDiarios"],
ganados: json["ganados"] == null ? 0: json["ganados"],
fechaInicioPromocion: json["fechaInicioPromocion"] == null ? "": json["fechaInicioPromocion"],
mesesVigentes: json["mesesVigentes"] == null ? 0 : json["mesesVigentes"],
descripcion: json["descripcion"] == null ?"" : json["descripcion"],
estado: json["estado"] == null ?0 : json["estado"],

      );

  Map<String, dynamic> toJson() => {
"contrato" : contrato,
"idSala" : idSala,
"nombreConfiguracion" : nombreConfiguracion,
"puntosJuego" : puntosJuego,
"multiplicador" : multiplicador,
"vecesDiarios" : vecesDiarios,
"ganados" : ganados,
"fechaInicioPromocion" : fechaInicioPromocion,
"mesesVigentes" : mesesVigentes,
"descripcion" : descripcion,
"estado" : estado,
      };
}

  


import 'dart:convert';


class ModelMail {
    ModelMail({
        required this.idMail,
        required this.codConsorcio,
        required this.codEmpresa,
        required this.codSala,
        required this.contrato,
        required this.fecha,
        required this.idAreaEnvio,
        required this.idAUsuarioEnvio,
        required this.titulo,
        required this.contenido,
        required this.estadoCorreo,
        required this.idMailDetalle,
        required this.fechaLectura,
        required this.estadoLectura,
        required this.expanded,
       
          

    });

    int idMail;
    int codConsorcio;
    int codEmpresa;
    int codSala;
    String contrato;
    DateTime fecha;
    int idAreaEnvio;
    int idAUsuarioEnvio;
    String titulo;
    String contenido;
    int estadoCorreo;
    int idMailDetalle;
    DateTime fechaLectura;
    int estadoLectura;
    bool expanded;
  

    factory ModelMail.fromJson(String str) => ModelMail.fromMap(json.decode(str));

    String toJson() => json.encode(toMap());

    factory ModelMail.fromMap(Map<String, dynamic> json) => ModelMail(
        idMail: json["idMail"],
        codConsorcio: json["codConsorcio"],
        codEmpresa: json["codEmpresa"],
        codSala: json["codSala"],
        contrato: json["contrato"],
        fecha: DateTime.parse(json["fecha"]),
        idAreaEnvio: json["idAreaEnvio"],
        idAUsuarioEnvio: json["idAUsuarioEnvio"],
        titulo: json["titulo"],
        contenido: json["contenido"],
        estadoCorreo: json["estadoCorreo"],
        idMailDetalle: json["idMailDetalle"],
        fechaLectura: DateTime.parse(json["fechaLectura"]),
        estadoLectura: json["estadoLectura"],
         expanded:false,
      

    );

    Map<String, dynamic> toMap() => {
        "idMail": idMail,
        "codConsorcio": codConsorcio,
        "codEmpresa": codEmpresa,
        "codSala": codSala,
        "contrato": contrato,
        "fecha": fecha.toIso8601String(),
        "idAreaEnvio": idAreaEnvio,
        "idAUsuarioEnvio": idAUsuarioEnvio,
        "titulo": titulo,
        "contenido": contenido,
        "estadoCorreo": estadoCorreo,
        "idMailDetalle": idMailDetalle,
        "fechaLectura": fechaLectura.toIso8601String(),
        "estadoLectura": estadoLectura,
        "expanded":false,
    };
}

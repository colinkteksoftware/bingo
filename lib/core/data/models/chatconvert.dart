// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

List<Chat> chatFromJson(String str) => List<Chat>.from(json.decode(str).map((x) => Chat.fromJson(x)));

String chatToJson(List<Chat> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Chat {
    int? idProceso;
    String? contrato;
    int? idConsorcio;
    int? idEmpresa;
    int? idSala;
    String? comunicado;
    String? titulo;
    DateTime? fechaComunicado;
    int? idEstado;

    Chat({
        this.idProceso,
        this.contrato,
        this.idConsorcio,
        this.idEmpresa,
        this.idSala,
        this.comunicado,
        this.titulo,
        this.fechaComunicado,
        this.idEstado,
    });

    factory Chat.fromJson(Map<String, dynamic> json) => Chat(
        idProceso: json["id_Proceso"] == null ?0:json["id_Proceso"],
        contrato: json["contrato"] == null ?"":json["contrato"],
        idConsorcio: json["id_consorcio"] == null ?0:json["id_consorcio"],
        idEmpresa: json["id_Empresa"] == null ?0:json["id_Empresa"],
        idSala: json["id_Sala"] == null ?0:json["id_Sala"],
        comunicado: json["comunicado"] == null ?"":json["comunicado"],
        titulo: json["titulo"] == null ?"":json["titulo"],
        fechaComunicado: json["fecha_Comunicado"] == null ? null : DateTime.parse(json["fecha_Comunicado"]),
        idEstado: json["id_estado"] == null ?0:json["id_estado"],
    );

    Map<String, dynamic> toJson() => {
        "id_Proceso": idProceso,
        "contrato": contrato,
        "id_consorcio": idConsorcio,
        "id_Empresa": idEmpresa,
        "id_Sala": idSala,
        "comunicado": comunicado,
        "titulo": titulo,
        "fecha_Comunicado": fechaComunicado?.toIso8601String(),
        "id_estado": idEstado,
    };
}

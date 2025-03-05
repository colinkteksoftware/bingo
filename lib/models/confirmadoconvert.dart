// To parse this JSON data, do
//
//     final chat = chatFromJson(jsonString);

import 'dart:convert';

List<Confirmado> chatFromJson(String str) => List<Confirmado>.from(json.decode(str).map((x) => Confirmado.fromJson(x)));

String chatToJson(List<Confirmado> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Confirmado {




   int?    tipo_Proceso;
 String? contrato;
  int?  id_sala;
DateTime?  fechaReserva;
DateTime?  fechaEvento;
 String?dniCliente;
  int?  confirma;


    Confirmado({
     this.tipo_Proceso,
this.contrato,
this.id_sala,
this.fechaReserva,
this.fechaEvento,
this.dniCliente,
this.confirma,
     
    });

    factory Confirmado.fromJson(Map<String, dynamic> json) => Confirmado(

tipo_Proceso: json["tipo_Proceso"] == null ? 0  :json["tipo_Proceso"],
contrato: json["contrato"] == null ?""   :json["contrato"],
id_sala: json["id_sala"] == null ? 0  :json["id_sala"],
fechaReserva: json["fechaReserva"] == null ? null   :DateTime.parse(json["fechaReserva"]),
fechaEvento: json["fechaEvento"] == null ?  null:DateTime.parse(json["fechaEvento"]),
dniCliente: json["dniCliente"] == null ?  "" :json["dniCliente"],
confirma: json["confirma"] == null ? 0  :json["confirma"],


    
    );

    Map<String, dynamic> toJson() => {
  



        "tipo_Proceso" : tipo_Proceso,
"contrato" : contrato,
"id_sala" : id_sala,
"fechaReserva" : fechaReserva?.toIso8601String(),
"fechaEvento" : fechaEvento?.toIso8601String(),
"dniCliente" : dniCliente,
"confirma" : confirma,
   
    };
}



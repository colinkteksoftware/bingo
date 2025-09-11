import 'dart:convert';

class ModelProceso {
  ModelProceso({


    required this.id_sala,
    required this.contrato,
     required this.TipoProceso, 
  
    required this.NombreProceso,

    required this.Estado,
    required this.foto,

  });



  int id_sala;
  String contrato;
    int TipoProceso;


  String NombreProceso;

  int Estado;
  String foto;


 

  factory ModelProceso.fromJson(String str) =>
      ModelProceso.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelProceso.fromMap(Map<String, dynamic> json) =>
      ModelProceso(


        id_sala: json["id_sala"],
        contrato: json["contrato"],
           TipoProceso: json["TipoProceso"],

        NombreProceso: json["NombreProceso"],

        Estado: json["Estado"],
        foto: json["foto"],
       
      );

  Map<String, dynamic> toMap() => {
  
    
        "id_sala": id_sala,
        "contrato": contrato,
     "TipoProceso":TipoProceso,


        "NombreProceso": NombreProceso,
      
        "Estado": Estado,

        "foto": foto,
       
      };
}

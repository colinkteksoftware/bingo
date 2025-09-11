import 'dart:convert';

class ModelDetalle {
  ModelDetalle({


    required this.id_sala,
    required this.contrato,
     required this.TipoProceso, 
  
    required this.DescripcionProceso,

    required this.Estado,
    required this.Fecha,

  });





  int id_sala;
  String contrato;
    int TipoProceso;


  String DescripcionProceso;

  int Estado;
  String? Fecha;


 

  factory ModelDetalle.fromJson(String str) =>
      ModelDetalle.fromMap(json.decode(str));

  String toJson() => json.encode(toMap());

  factory ModelDetalle.fromMap(Map<String, dynamic> json) =>
      ModelDetalle(


        id_sala: json["id_sala"],
        contrato: json["contrato"],
           TipoProceso: json["TipoProceso"],

        DescripcionProceso: json["DescripcionProceso"],

        Estado: json["Estado"],
        Fecha: json["Fecha"],
       
      );

  Map<String, dynamic> toMap() => {
  
    
        "id_sala": id_sala,
        "contrato": contrato,
     "TipoProceso":TipoProceso,


        "DescripcionProceso": DescripcionProceso,
      
        "Estado": Estado,

        "Fecha": Fecha,
       
      };
}

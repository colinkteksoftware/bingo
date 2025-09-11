import 'dart:convert';

// Función para convertir el JSON en una lista de objetos Sala
List<Sala> salaFromJson(String str) =>
    List<Sala>.from(json.decode(str).map((x) => Sala.fromJson(x)));

// Función para convertir la lista de objetos Sala a JSON
String salaToJson(List<Sala> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Sala {
  Sala({
    this.contrato,
    this.idSalaNube,
    this.dniCliente,
    this.nombreSala,
  });

  String? contrato;
  int? idSalaNube;
  String? dniCliente;
  String? nombreSala;

  factory Sala.fromJson(Map<String, dynamic> json) => Sala(
        contrato: json["contrato"],
        idSalaNube: json["id_sala_nube"],
        dniCliente: json["dni_cliente"],
        nombreSala: json["nombreSala"],
      );

  Map<String, dynamic> toJson() => {
        "contrato": contrato,
        "id_sala_nube": idSalaNube,
        "dni_cliente": dniCliente,
        "nombreSala": nombreSala,
      };
}

class Persona {
    Persona({
        required this.contrato,
        required this.idSalaNube,
        required this.idCliente,
        required this.nomClie,
        required this.apeclie,
        required this.fechaNacimiento,
        required this.sexo,
        required this.correo,
        required this.clave,
        required this.telefono,
        required this.dni,
        required this.nacionalidad,
        required this.puntosRedimibles,
        required this.puntosCupones,
        required this.puntosJugables,
        required this.fechaRegistro,
        required this.fechaUltimaVisita,
        required this.estado,
    });

    final String? contrato;
    final int? idSalaNube;
    final int? idCliente;
    final String? nomClie;
    final String? apeclie;
    final DateTime? fechaNacimiento;
    final int? sexo;
    final String? correo;
    final String? clave;
    final String? telefono;
    final String? dni;
    final String? nacionalidad;
    final int? puntosRedimibles;
    final int? puntosCupones;
    final int? puntosJugables;
    final DateTime? fechaRegistro;
    final DateTime? fechaUltimaVisita;
    final int? estado;

    factory Persona.fromJson(Map<String, dynamic> json){ 
        return Persona(
            contrato: json["contrato"],
            idSalaNube: json["id_sala_nube"],
            idCliente: json["idCliente"],
            nomClie: json["nomClie"],
            apeclie: json["apeclie"],
            fechaNacimiento: DateTime.tryParse(json["fechaNacimiento"] ?? ""),
            sexo: json["sexo"],
            correo: json["correo"],
            clave: json["clave"],
            telefono: json["telefono"],
            dni: json["dni"],
            nacionalidad: json["nacionalidad"],
            puntosRedimibles: json["puntosRedimibles"],
            puntosCupones: json["puntosCupones"],
            puntosJugables: json["puntosJugables"],
            fechaRegistro: DateTime.tryParse(json["fechaRegistro"] ?? ""),
            fechaUltimaVisita: DateTime.tryParse(json["fecha_UltimaVisita"] ?? ""),
            estado: json["estado"],
        );
    }
}

class Bingo {
  int? bingoId;
  String? fecha;
  String? descripcion;
  double? precioPorCartilla;
  int? presupuestoPremio;
  int? tipoBalotario;
  int? tipoOrigen;
  String? tipo;
  int? estado; 
  int? synchronizer;
  int? numeroEventoConsecutivo;
  String? fechaInicioEvento;
  String? fechaFinEvento;
  //DateTime? fechaInicioEvento;
  //DateTime? fechaFinEvento;

  Bingo({
    this.bingoId,
    this.fecha,
    this.descripcion,
    this.precioPorCartilla,
    this.presupuestoPremio,
    this.tipoBalotario,
    this.tipoOrigen,
    this.tipo,
    this.estado,
    this.synchronizer,
    this.numeroEventoConsecutivo,
    this.fechaInicioEvento,
    this.fechaFinEvento
  });

  factory Bingo.fromMap(Map<String, dynamic> json) {
    return Bingo(
      bingoId: json["bingoId"] ?? 0,
      fecha: json["fecha"] ?? '',
      descripcion: json["descripcion"] ?? '',
      //precioPorCartilla: json["precioPorCartilla"] ?? 0.0,
      precioPorCartilla: (json["precioPorCartilla"] is double) 
        ? json["precioPorCartilla"]
        : (json["precioPorCartilla"] as int).toDouble(),
      //presupuestoPremio: json["presupuestoPremio"],
      presupuestoPremio: (json["presupuestoPremio"] is int) 
        ? json["presupuestoPremio"] 
        : (json["presupuestoPremio"] as double).toInt(),
      tipoBalotario: json["tipoBalotario"] ?? 0,
      tipoOrigen: json["tipoOrigen"] ?? 0,
      tipo: json["tipo"] ?? '',
      estado: json["estado"] ?? 0,
      numeroEventoConsecutivo: json['numeroEventoConsecutivo'] ?? 0,
      synchronizer: json['synchronizer'] ?? 0,
      fechaInicioEvento: json['fechaInicioEvento'] ?? '',
      fechaFinEvento: json['fechaFinEvento'] ?? '',
      //fechaInicioEvento: DateTime.parse(json['fechaInicioEvento']),
      //fechaFinEvento: DateTime.parse(json['fechaFinEvento']),
    );
  }

  Map<String, dynamic> bingoToMap() => {
        "bingoId": bingoId,
        //"fecha": fecha?.toIso8601String(),
        "fecha": fecha,
        "descripcion": descripcion,
        "precioPorCartilla": precioPorCartilla,
        "presupuestoPremio": presupuestoPremio,
        "tipoBalotario": tipoBalotario,
        "tipoOrigen": tipoOrigen,
        "tipo": tipo,
        "estado": estado,
      };

  @override
  String toString() {
    return 'Bingo('
        'bingoId: $bingoId, '
        'fecha: $fecha, '
        'descripcion: "$descripcion", '
        'precioPorCartilla: $precioPorCartilla, '
        'presupuestoPremio: $presupuestoPremio, '
        'tipoBalotario: $tipoBalotario, '
        'tipoOrigen: $tipoOrigen, '
        'tipo: "$tipo", '
        'estado: $estado'
        ')';
  }
}
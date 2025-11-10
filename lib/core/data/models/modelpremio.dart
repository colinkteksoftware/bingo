class Premio {
  int? bingoPremioDetalleId;
  int? premioId;
  String? descripcion;
  double? valor;
  int? figuraGrupodetalleId;
  String? grupo;
  int? figuraId;
  String? figura;

  Premio({
    this.bingoPremioDetalleId,
    this.premioId,
    this.descripcion,
    this.valor,
    this.figuraGrupodetalleId,
    this.grupo,
    this.figuraId,
    this.figura
  });

  factory Premio.fromMap(Map<String, dynamic> json) {
    return Premio(
      bingoPremioDetalleId: json["bingoPremioDetalleId"],
      premioId: json["premioId"],
      descripcion: json["descripcion"],
      //valor: json["valor"],
      valor: (json["valor"] as num?)?.toDouble(),
      figuraGrupodetalleId: json["figuraGrupodetalleId"],
      grupo: json['grupo'],
      figuraId: json["figuraId"],
      figura: json['figura'],
    );
  } 

  Map<String, dynamic> toMap() => {
        "bingoPremioDetalleId": bingoPremioDetalleId,
        "premioId": premioId,
        "descripcion": descripcion,
        "valor": valor,
        "figuraGrupodetalleId": figuraGrupodetalleId,
        "grupo" : grupo,
        "figuraId": figuraId,
        "figura": figura
      };
}

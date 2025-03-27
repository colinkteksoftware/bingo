class Premio {
  int bingoPremioDetalleId;
  int premioId;
  String descripcion;
  int valor;
  int figuraGrupodetalleId;
  int figuraId;

  Premio({
    required this.bingoPremioDetalleId,
    required this.premioId,
    required this.descripcion,
    required this.valor,
    required this.figuraGrupodetalleId,
    required this.figuraId,
  });

  factory Premio.fromMap(Map<String, dynamic> json) => Premio(
        bingoPremioDetalleId: json["bingoPremioDetalleId"],
        premioId: json["premioId"],
        descripcion: json["descripcion"],
        valor: json["valor"],
        figuraGrupodetalleId: json["figuraGrupodetalleId"],
        figuraId: json["figuraId"],
      );

  Map<String, dynamic> toMap() => {
        "bingoPremioDetalleId": bingoPremioDetalleId,
        "premioId": premioId,
        "descripcion": descripcion,
        "valor": valor,
        "figuraGrupodetalleId": figuraGrupodetalleId,
        "figuraId": figuraId,
      };
}
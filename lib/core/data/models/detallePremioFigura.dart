import 'package:bingo/core/data/models/adicional.dart';

class DetallePremioFigura {
  int? premioId;
  double? valorPremio;
  int? figuraId;
  String? nombreFigura;
  bool? isTipoGrupo;
  String? nombreGrupo;
  int? estadoPago;
  List<Adicional>? listaAdicionales;
  bool? isGanadorCartaRey;
  dynamic nombreCartaRey;

  DetallePremioFigura({
    this.premioId,
    this.valorPremio,
    this.figuraId,
    this.nombreFigura,
    this.isTipoGrupo,
    this.nombreGrupo,
    this.estadoPago,
    this.listaAdicionales,
    this.isGanadorCartaRey,
    this.nombreCartaRey,
  });

  factory DetallePremioFigura.fromJson(Map<String, dynamic> json) =>
      DetallePremioFigura(
        premioId: json["PremioId"] ?? 0,
        valorPremio: (json["ValorPremio"] == null ||
                json["ValorPremio"].toString().isEmpty)
            ? 0.0
            : double.tryParse(json["ValorPremio"].toString()) ?? 0.0,
        figuraId: json["FiguraId"] ?? 0,
        nombreFigura: json["NombreFigura"] ?? '',
        isTipoGrupo: json["IsTipoGrupo"] ?? false,
        nombreGrupo: json["NombreGrupo"] ?? '',
        estadoPago: json["EstadoPago"] ?? 0,
        listaAdicionales: json["ListaAdicionales"] == null
            ? []
            : List<Adicional>.from(
                json["ListaAdicionales"]!.map((x) => Adicional.fromJson(x))),
        isGanadorCartaRey: json["IsGanadorCartaRey"] ?? false,
        nombreCartaRey: json["NombreCartaRey"] ?? '',
      );

  Map<String, dynamic> toJson() => {
        "premioId": premioId,
        "valorPremio": valorPremio,
        "figuraId": figuraId,
        "nombreFigura": nombreFigura,
        "isTipoGrupo": isTipoGrupo,
        "nombreGrupo": nombreGrupo,
        "estadoPago": estadoPago,
        "listaAdicionales": listaAdicionales == null
            ? []
            : List<dynamic>.from(listaAdicionales!.map((x) => x.toJson())),
        "isGanadorCartaRey": isGanadorCartaRey,
        "nombreCartaRey": nombreCartaRey,
      };

  @override
  String toString() {
    return 'DetallePremioFigura(nombreGrupo: $nombreGrupo, nombreFigura: $nombreFigura, valorPremio: $valorPremio)';
  }
}

// To parse this JSON data, do
//
//     final promotor = promotorFromJson(jsonString);

import 'dart:convert';



List<Pago> pagoFromJson(String str) => List<Pago>.from(json.decode(str).map((x) => Pago.fromJson(x)));

String pagoToJson(List<Pago> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class Pago {
    String? clienteId;
    int? bingoId;
    int? ventaId;
    int? cartillaId;
    String? codigoModulo;
    List<DetallePremioFigura>? detallePremioFigura;
    int? promotorId;
    int? multiplicado;
    int? tipo;
    List<Map<String, int>>? ventasDetalle;
      
    Pago({
        this.clienteId,
        this.bingoId,
        this.ventaId,
        this.cartillaId,
        this.codigoModulo,
        this.detallePremioFigura,
        this.promotorId,
        this.multiplicado,
        this.tipo,
        this.ventasDetalle
    });

    factory Pago.fromJson(Map<String, dynamic> json) => Pago(
        clienteId: json["clienteId"].toString(),
        bingoId: json["bingoId"],
        ventaId: json["ventaId"],
        cartillaId: json["cartillaId"],
        codigoModulo: json["codigoModulo"],
        detallePremioFigura: json["detallePremioFigura"] == null ? [] : List<DetallePremioFigura>.from(json["detallePremioFigura"]!.map((x) => DetallePremioFigura.fromJson(x))),
        promotorId: json['promotorId'],
        multiplicado: json['multiplicado'],
        tipo: json['tipo'],
        ventasDetalle: json['ventasDetalle']
    );

    Map<String, dynamic> toJson() => {
        "clienteId": clienteId,
        "bingoId": bingoId,
        "ventaId": ventaId,
        "cartillaId": cartillaId,
        "codigoModulo": codigoModulo,
        "detallePremioFigura": detallePremioFigura == null ? [] : List<dynamic>.from(detallePremioFigura!.map((x) => x.toJson())),
        "promotorId": promotorId,
        "multiplicado": multiplicado,
        "tipo": tipo,
        "ventasDetalle": ventasDetalle
    };
}

class DetallePremioFigura {
    int? premioId;
    double? valorPremio;
    int? figuraId;
    String? nombreFigura;
    bool? isTipoGrupo;
    String? nombreGrupo;
    int? estadoPago;
    List<ListaAdicionale>? listaAdicionales;
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

    factory DetallePremioFigura.fromJson(Map<String, dynamic> json) => DetallePremioFigura(
        premioId: json["premioId"],
        valorPremio: double.parse(json["valorPremio"].toString()),
        figuraId: json["figuraId"],
        nombreFigura: json["nombreFigura"],
        isTipoGrupo: json["isTipoGrupo"],
        nombreGrupo: json["nombreGrupo"],
        estadoPago: json["estadoPago"],
        listaAdicionales: json["listaAdicionales"] == null ? [] : List<ListaAdicionale>.from(json["listaAdicionales"]!.map((x) => ListaAdicionale.fromJson(x))),
        isGanadorCartaRey: json["isGanadorCartaRey"],
        nombreCartaRey: json["nombreCartaRey"] ?? "",
    );

    Map<String, dynamic> toJson() => {
        "premioId": premioId,
        "valorPremio": valorPremio,
        "figuraId": figuraId,
        "nombreFigura": nombreFigura,
        "isTipoGrupo": isTipoGrupo,
        "nombreGrupo": nombreGrupo,
        "estadoPago": estadoPago,
        "listaAdicionales": listaAdicionales == null ? [] : List<dynamic>.from(listaAdicionales!.map((x) => x.toJson())),
        "isGanadorCartaRey": isGanadorCartaRey,
        "nombreCartaRey": nombreCartaRey,
    };
}

class ListaAdicionale {
    String? categoria;
    dynamic descripcion;
    double? premioAdicional;

    ListaAdicionale({
        this.categoria,
        this.descripcion,
        this.premioAdicional,
    });

    factory ListaAdicionale.fromJson(Map<String, dynamic> json) => ListaAdicionale(
        categoria: json["categoria"],
        descripcion: json["descripcion"] ==null ?"":json["descripcion"],
        premioAdicional: double.parse(json["premioAdicional"].toString()),
    );

    Map<String, dynamic> toJson() => {
        "categoria": categoria,
        "descripcion": descripcion,
        "premioAdicional": premioAdicional,
    };
}

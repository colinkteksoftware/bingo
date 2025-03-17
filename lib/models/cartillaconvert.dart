import 'dart:convert';

Cartilla cartillaFromJson(String str) => Cartilla.fromJson(json.decode(str));

String cartillaToJson(Cartilla data) => json.encode(data.toJson());

class Cartilla {
    int? cartillaGrupoDetalleId;
    String? nombreGrupo;
    String? grupoCartillas;

    Cartilla({
        this.cartillaGrupoDetalleId,
        this.nombreGrupo,
        this.grupoCartillas,
    });

    factory Cartilla.fromJson(Map<String, dynamic> json) => Cartilla(
        cartillaGrupoDetalleId: json["cartillaGrupoDetalleId"],
        nombreGrupo: json["nombreGrupo"],
        grupoCartillas: json["grupoCartillas"],
    );

    Map<String, dynamic> toJson() => {
        "cartillaGrupoDetalleId": cartillaGrupoDetalleId,
        "nombreGrupo": nombreGrupo,
        "grupoCartillas": grupoCartillas,
    };
}

// To parse this JSON data, do
//
//     final show = showFromJson(jsonString);

import 'dart:convert';


Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    int? cartillaGrupoDetalleId;
    String? nombreGrupo;
    String? grupoCartillas;

    Welcome({
        this.cartillaGrupoDetalleId,
        this.nombreGrupo,
        this.grupoCartillas,
    });

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
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

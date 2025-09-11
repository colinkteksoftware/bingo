class Adicional {
    String? categoria;
    dynamic descripcion;
    double? premioAdicional;

    Adicional({
        this.categoria,
        this.descripcion,
        this.premioAdicional,
    });

    factory Adicional.fromJson(Map<String, dynamic> json) => Adicional(
        categoria: json["categoria"],
        descripcion: json["descripcion"] ?? "",
        premioAdicional: double.parse(json["premioAdicional"].toString()),
    );

    Map<String, dynamic> toJson() => {
        "categoria": categoria,
        "descripcion": descripcion,
        "premioAdicional": premioAdicional,
    };
}
class VentasDetalle {
  int? cartillaId;

  VentasDetalle({
    this.cartillaId,
  });

  factory VentasDetalle.fromJson(Map<String, dynamic> json) => VentasDetalle(
        cartillaId: json["cartillaId"],
      );

  Map<String, dynamic> toJson() => {
        "cartillaId": cartillaId,
      };
}

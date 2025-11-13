import 'dart:convert';
import 'package:bingo/core/data/models/ventasconvert.dart';

List<SaleGroup> ventaGroupFromMap(String str) =>
    List<SaleGroup>.from(json.decode(str).map((x) => SaleGroup.fromMap(x)));

String ventaGroupToMap(List<SaleGroup> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toMap())));

class SaleGroup {
  int bingoid;
  List<Venta> cartillas;

  SaleGroup({
    required this.bingoid,
    required this.cartillas,
  });

  factory SaleGroup.fromMap(Map<String, dynamic> json) => SaleGroup(
        bingoid: json["bingoid"] ?? 0,
        cartillas: json["cartillas"] == null
            ? []
            : List<Venta>.from(json["cartillas"].map((x) => Venta.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "bingoid": bingoid,
        "cartillas": List<dynamic>.from(cartillas.map((x) => x.toMap())),
      };

  /*factory SaleGroup.fromMap(Map<String, dynamic> json) => SaleGroup(
        bingoid: json["bingoid"],
        cartillas:
            List<Venta>.from(json["cartillas"].map((x) => Venta.fromMap(x))),
      );

  Map<String, dynamic> toMap() => {
        "bingoid": bingoid,
        "cartillas": List<dynamic>.from(cartillas.map((x) => x.toMap())),
      };*/
}

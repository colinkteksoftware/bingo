import 'dart:convert';

class Booklet {
  String? cartillaId;
  int? quantity = 1;
  double? price = 0;
  bool? estado;

  Booklet({
    this.cartillaId,
    this.quantity,
    this.price,
    this.estado,
  });

  factory Booklet.fromJson(Map<String, dynamic> json) => Booklet(
        cartillaId: json["cartillaId"] ?? '',
        quantity: json["quantity"] ?? 0,
        price: json['price'] ?? 0,
        estado: json["estado"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "cartillaId": cartillaId,
        "quantity": quantity,
        'price': price,
        "estado": estado,
      };

  @override
  String toString() {
    return 'Booklet(cartillaId: $cartillaId, quantity: $quantity, price: $price, estado: $estado)';
  }
}

Booklet bookletFromJson(String str) => Booklet.fromJson(json.decode(str));

String bookletToJson(Booklet data) => json.encode(data.toJson());

class UdpData {
  final String action;
  final int bingoid;
  final double precio;
  final int inicio;
  final int estado;
  final List<int> bolillas;
  final String letra;
  final int bolilla;

  UdpData({
    required this.action,
    required this.bingoid,
    required this.precio,
    required this.inicio,
    required this.estado,
    required this.bolillas,
    required this.letra,
    required this.bolilla,
  });

  factory UdpData.fromJson(Map<String, dynamic> json) {
    return UdpData(
      action: json['action'] ?? '',
      bingoid: json['bingoid'] ?? 0,
      precio: json['precio'] ?? 0.0,
      inicio: json['inicio'] ?? 0,
      estado: json['estado'] ?? 0,
      //bolillas: json['bolillas'] ?? [],
      bolillas:
          (json['bolillas'] as List<dynamic>?)?.map((e) => e as int).toList() ??
          [],
      letra: json['letra'] ?? '',
      bolilla: json['bolilla'] ?? 0,
    );
  }
}

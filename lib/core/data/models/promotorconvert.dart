import 'dart:convert';

Promotor promotorFromJson(String str) => Promotor.fromJson(json.decode(str));

String promotorToJson(Promotor data) => json.encode(data.toJson());

class Promotor {
    int? clientes;
    TotalVentaGanancia? totalVentaGanancia;
    double? crecimiento;
    double? promedioIngresoMensual;
    double? ventaHoy;
    List<TotalTipoBingo>? totalTipoBingo;
    List<VentasIngresosMensuale>? ventasIngresosMensuales;

    Promotor({
        this.clientes,
        this.totalVentaGanancia,
        this.crecimiento,
        this.promedioIngresoMensual,
        this.ventaHoy,
        this.totalTipoBingo,
        this.ventasIngresosMensuales,
    });

    factory Promotor.fromJson(Map<String, dynamic> json) => Promotor(
        clientes: json["clientes"],
        totalVentaGanancia: json["totalVentaGanancia"] == null ? null : TotalVentaGanancia.fromJson(json["totalVentaGanancia"]),
        crecimiento: json["crecimiento"]?.toDouble(),
        promedioIngresoMensual: json["promedioIngresoMensual"]?.toDouble(),
        ventaHoy: json["ventaHoy"]?.toDouble(),
        totalTipoBingo: json["totalTipoBingo"] == null ? [] : List<TotalTipoBingo>.from(json["totalTipoBingo"]!.map((x) => TotalTipoBingo.fromJson(x))),
        ventasIngresosMensuales: json["ventasIngresosMensuales"] == null ? [] : List<VentasIngresosMensuale>.from(json["ventasIngresosMensuales"]!.map((x) => VentasIngresosMensuale.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "clientes": clientes,
        "totalVentaGanancia": totalVentaGanancia?.toJson(),
        "crecimiento": crecimiento,
        "promedioIngresoMensual": promedioIngresoMensual,
        "ventaHoy": ventaHoy,
        "totalTipoBingo": totalTipoBingo == null ? [] : List<dynamic>.from(totalTipoBingo!.map((x) => x.toJson())),
        "ventasIngresosMensuales": ventasIngresosMensuales == null ? [] : List<dynamic>.from(ventasIngresosMensuales!.map((x) => x.toJson())),
    };
}

class TotalTipoBingo {
    String? tipo;
    int? total;

    TotalTipoBingo({
        this.tipo,
        this.total,
    });

    factory TotalTipoBingo.fromJson(Map<String, dynamic> json) => TotalTipoBingo(
        tipo: json["tipo"],
        total: json["total"],
    );

    Map<String, dynamic> toJson() => {
        "tipo": tipo,
        "total": total,
    };
}

class TotalVentaGanancia {
    double? totalVenta;
    double? ganancias;

    TotalVentaGanancia({
        this.totalVenta,
        this.ganancias,
    });

    factory TotalVentaGanancia.fromJson(Map<String, dynamic> json) => TotalVentaGanancia(
        totalVenta: json["totalVenta"]?.toDouble(),
        ganancias: json["ganancias"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "totalVenta": totalVenta,
        "ganancias": ganancias,
    };
}

class VentasIngresosMensuale {
    String? mes;
    double? venta;
    double? ingreso;

    VentasIngresosMensuale({
        this.mes,
        this.venta,
        this.ingreso,
    });

    factory VentasIngresosMensuale.fromJson(Map<String, dynamic> json) => VentasIngresosMensuale(
        mes: json["mes"],
        venta: json["venta"]?.toDouble(),
        ingreso: json["ingreso"]?.toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "mes": mes,
        "venta": venta,
        "ingreso": ingreso,
    };
}

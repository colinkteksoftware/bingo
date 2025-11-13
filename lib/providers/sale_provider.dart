import 'dart:convert';
import 'package:bingo/core/data/models/booklet.dart';
import 'package:bingo/core/data/models/pagosconvert.dart';
import 'package:bingo/core/data/models/saleGroup.dart';
import 'package:bingo/core/data/models/uvtconvert.dart';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as sdf;
import 'package:provider/provider.dart';

class SaleProvider extends ChangeNotifier {
  final pf = Preferencias();

  /*List<Venta> _sales = [];
  List<Venta> get listSales => _sales;*/

  List<SaleGroup> _salesGrouped = [];
  List<SaleGroup> get listSalesGrouped => _salesGrouped;

  List<Booklet> _listBooklet = [];
  List<Booklet> get listBooklet => _listBooklet;

  DateTime? _currentDate;
  DateTime get currentDate => _currentDate ?? DateTime.now();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  int _type = 0;
  int get type => _type;

  double _preciofinal = 0;
  double get preciofinal => _preciofinal;

  int _counter = 1;
  int get counter => _counter;

  Uvt _uvt = Uvt();
  Uvt get uvt => _uvt;

  Uri url = Uri.parse('');

  final TextEditingController counterController = TextEditingController();

  SaleProvider() {
    counterController.text = _counter.toString();
    counterController.addListener(() {
      final value = int.tryParse(counterController.text);
      if (value != null && value >= 1 && value != _counter) {
        _counter = value;
        calculeTotal();
      }
    });
  }

  Future<List<SaleGroup>?> fetchSales() async {
    String fecha = sdf.DateFormat('yyyy-MM-dd').format(currentDate);
    _isLoading = true;
    notifyListeners();

    final url = Uri.parse(
        '${pf.getIp.toString()}/api/PromotorInterno/GetMisVentasByPromotor?PromotorId=${pf.getPromotorId}&FechaCompra=$fecha');
    print('url => $url');
    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    print('Status code: ${response.statusCode}');
    print('Body: ${utf8.decode(response.bodyBytes)}');

    if (response.statusCode == 200) {
      _salesGrouped = ventaGroupFromMap(utf8.decode(response.bodyBytes));
      print('lista de ventas => $_salesGrouped');
      _isLoading = false;
      notifyListeners();
      return _salesGrouped;
    } else {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load grouped sales. Status: ${response.statusCode}');
    }
  }

  /*Future<List<Venta>?> fetchSales() async {
    String fecha = sdf.DateFormat('yyyy-MM-dd').format(currentDate);
    _isLoading = true;
    notifyListeners();
    url = Uri.parse(
        '${pf.getIp.toString()}/api/PromotorInterno/GetMisVentasByPromotor?PromotorId=${pf.getPromotorId}&FechaCompra=$fecha');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      //body: json.encode(request.toMap()));
    );

    if (response.statusCode == 200) {
      _sales = ventaFromMap(utf8.decode(response.bodyBytes));
      _isLoading = false;
      notifyListeners();
      //print('ventas => ${ventaToMap(_sales)}');
      return _sales;
    } else {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load shows');
    }
  }*/

  Future<bool> postSale(Pago pago, BuildContext context) async {
    List<Map<String, int>> booklets = [];
    print('lista de cartillas => ${listBooklet.toString()}');
    if (listBooklet.isNotEmpty) {
      for (var booklet in listBooklet) {
        try {
          int cartillaId = int.parse(booklet.cartillaId.toString());
          if (booklet.estado == true) {
            //print('cartilla => $cartillaId');
            booklets.add({"cartillaId": cartillaId});
          }
        } catch (e) {
          print('Error al convertir cartillaId: ${booklet.cartillaId}');
        }
      }
    }
    pago.ventasDetalle = booklets.toList();
    print('body edit sale => ${json.encode(pago.toJson())}');
    url = Uri.parse(
        '${pf.getIp.toString()}/api/PromotorInterno/UpdateVentaManual');
    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json; charset=UTF-8'},
          body: json.encode(pago.toJson()));

      if (response.statusCode == 200) {
        const snackBar = SnackBar(
          content: Center(child: Text("Se ha confirmado la actualización..")),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        await fetchSales();
        return true;
      } else {
        const snackBar = SnackBar(
          content:
              Center(child: Text("No se ha confirmado la actualización..")),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
        //     Navigator.of(context).pop();
        ///throw Exception('Failed to load shows');
      }
    } catch (e) {
      print('Failed to load shows => ${e.toString()}');
      return false;
    }
  }

  Future<bool> deleteSale(BuildContext context, String ventaId) async {
    url =
        Uri.parse('${pf.getIp.toString()}/api/PromotorInterno/Delete/$ventaId');

    final response = await http.delete(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      const snackBar = SnackBar(
        content: Center(child: Text('¡Se ha confirmado la eliminación!')),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      fetchSales();
      //Navigator.of(context).pop();
      return true;
    } else {
      const snackBar = SnackBar(
        content: Center(child: Text('No se ha confirmado la eliminación.')),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.of(context).pop();
      //throw Exception('Failed to load shows');
      return false;
    }
  }

  Future<void> getBooklets(BuildContext context, int ventaId) async {
    final provider = Provider.of<BingoProvider>(context, listen: false);
    _isLoading = true;
    notifyListeners();
    _listBooklet = [];
    try {
      url = Uri.parse(
          '${pf.getIp.toString()}/api/GrupoCartillaDetalle/GetBookletBySale');

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(
              {"bingoId": provider.bingo.bingoId, "ventaId": ventaId}));

      if (response.statusCode == 200) {
        //print('lista de cartillas => ${jsonDecode(response.body)}');
        final data = jsonDecode(response.body);
        for (var bk in data) {
          Booklet booklet = Booklet();
          booklet.cartillaId = bk['cartillaId'].toString();
          booklet.quantity = 1;
          booklet.estado = true;
          booklet.price = bk['price'];
          _listBooklet.add(booklet);
        }
        calculeTotal();
      }
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _listBooklet = [];
      _isLoading = false;
      notifyListeners();
      print('Failed to load shows => ${e.toString()}');
    }
  }

  Future<void> getAmountUVT() async {
    url = Uri.parse("${pf.getIp.toString()}/api/ParametroInterno/GetAll");
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        _uvt = uvtFromJson(utf8.decode(response.bodyBytes));
        updateUvt(_uvt);
      } else {
        throw Exception('Failed to load uvt');
      }
    } catch (error) {
      throw Exception('Failed to load uvt: $error');
    }
  }

  void increment() {
    if (_currentDate!.weekday.toInt() <= 5) {
      _counter++;
      if (_counter > 3) {
        counterController.text = '3';
      } else {
        counterController.text = _counter.toString();
      }
    } else {
      _counter++;
      if (_counter > 10) {
        counterController.text = '10';
      } else {
        counterController.text = _counter.toString();
      }
    }
    calculeTotal();
    /*_counter++;
    counterController.text = _counter.toString();
    calculeTotal();*/
  }

  void decrement() {
    /*if (_counter > 1) {
      _counter--;
    }
    calculeTotal();*/
    if (_counter > 1) {
      _counter--;
      counterController.text = _counter.toString();
      calculeTotal();
    }
  }

  void calculeTotal() {
    double precio = 0;
    double total = 0.0;
    switch (_type) {
      case 0:
        for (var booklet in listBooklet) {
          if (booklet.estado == true) {
            precio = booklet.price ?? 0;
            total = total + precio;
          }
        }
        _preciofinal = double.parse(total.toStringAsFixed(2));
        break;
      case 2:
        for (var booklet in listBooklet) {
          if (booklet.estado == true) {
            precio = booklet.price ?? 0;
            //total = total + (precio * _counter) + precio;
            total += precio * _counter;
          }
        }
        _preciofinal = double.parse(total.toStringAsFixed(2));
        break;
      default:
        _preciofinal = 0;
        break;
    }
    notifyListeners();
  }

  void updateCurrentDate(DateTime newDate) {
    _currentDate = newDate;
    notifyListeners();
  }

  void updateType(int value) {
    _type = value;
    if (_type == 1) {
      updateCounter(0);
    } else {
      updateCounter(1);
    }
    notifyListeners();
  }

  void updateCounter(int value) {
    /*_counter = value;
    notifyListeners();*/
    if (value >= 1) {
      _counter = value;
      counterController.text = value.toString();
      calculeTotal();
    }
  }

  void updateUvt(Uvt uvt) {
    _uvt = uvt;
    notifyListeners();
  }

  void updateEstado(String cartillaId, bool newEstado) {
    Booklet? booklet = _listBooklet.firstWhere(
      (item) => item.cartillaId == cartillaId,
      orElse: () => Booklet(),
    );

    if (booklet.cartillaId.toString().isNotEmpty) {
      booklet.estado = newEstado;
      notifyListeners();
    } else {
      print('No se encontró el Booklet con cartillaId: $cartillaId');
    }
  }
}

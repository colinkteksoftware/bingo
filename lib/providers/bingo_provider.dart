import 'dart:convert';
import 'dart:io';
import 'package:bingo/core/data/models/bingoSala.dart';
import 'package:bingo/core/data/models/bingo.dart';
import 'package:bingo/core/data/models/booklet.dart';
import 'package:bingo/core/data/models/cartillaconvert.dart';
import 'package:bingo/core/data/models/requestQuey.dart';
import 'package:bingo/core/data/models/saleQuery.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart' as sdf;

class BingoProvider with ChangeNotifier {
  final pf = Preferencias();

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? errorMessage;

  DateTime? _currentDate;
  DateTime get currentDate => _currentDate ?? DateTime.now();

  String _qrcode = "-1";
  String get qrcode => _qrcode;

  int _status = 1;
  int get status => _status;

  int _aditional = 0;
  int get aditional => _aditional;

  int _preciofinal = 0;
  int get preciofinal => _preciofinal;

  int _counter = 1;
  int get counter => _counter;

  List<Bingo> _bingos = [];
  List<Bingo> get listBingos => _bingos;

  final List<Cartilla> _listBooklet = [];
  List<Cartilla> get listBooklet => _listBooklet;

  final List<Booklet> _infoBooklet = [];
  List<Booklet> get infoBooklet => _infoBooklet;

  Bingo _bingo = Bingo();
  Bingo get bingo => _bingo;

  Future<void> getBingoById() async {
    final url = Uri.parse(
        '${pf.getIp.toString()}/api/BingoPremioDetalleInterno/GetItem/${bingo.bingoId}');

    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode == 200) {
        /*final Map<String, dynamic> info = json.decode(response.body);
        final data = BingoResponse.fromJson(info);
        print('info bingo actualizado => $data');
        print('bingo actualizado => ${data.bingo}');
        updateBingo(data.bingo);*/

        final Map<String, dynamic> info = json.decode(response.body);
        print('Respuesta del servidor: $info');
        final bingoData = info['bingo'];
        final data = Bingo.fromMap(bingoData);        
        print('Bingo actualizado: $data');
        updateBingo(data);
      }
    } catch (e) {
      throw Exception('Error inesperado: $e');
    }
  }

  Future<List<Bingo>> fetchShowBingos(int state) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();
    final url = Uri.parse(
        '${pf.getIp.toString()}/api/BingoPremioDetalleInterno/GetAll');
    /*print('url => $url');
    print(
        'dia filtrado => ${sdf.DateFormat('yyyy-MM-dd').format(currentDate)}');*/
    //print('estado filtrado => $state');

    try {
      final request = RequestQuery()
        ..isGlobal = false
        ..isIndividual = false
        ..fechaInicio = sdf.DateFormat('yyyy-MM-dd').format(currentDate)
        ..fechaFin = sdf.DateFormat('yyyy-MM-dd').format(currentDate)
        ..estado = state;

      //print('parametros => ${json.encode(request.toMap())} ');

      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(request.toMap()));

      if (response.statusCode == 200) {
        final info = utf8.decode(response.bodyBytes);
        print('response: $info');
        
        List<BingoSala> bingos = bingoSalaFromMap(info);
        print('bingos => $bingos');
        _bingos = obtenerBingos(bingos);
        //print('lista de bingos => $_bingos');
        if (_bingos.isNotEmpty) {
          for (var bingo in _bingos) {
            if (bingo.bingoId == pf.getBingoId) {
              updateBingo(bingo);
            }
          }
        }
        _isLoading = false;
        notifyListeners();
        return _bingos;
      } else {
        _bingos = [];
        _isLoading = false;
        notifyListeners();
        throw Exception('Failed to load shows');
      }
    } on SocketException catch (_) {
      _bingos = [];
      _isLoading = false;
      notifyListeners();
      throw Exception('No se pudo conectar al servidor. Revisa tu red.');
    } on FormatException catch (e) {
      _bingos = [];
      _isLoading = false;
      errorMessage = 'Failed to load bingo shows: $e';
      notifyListeners();
      throw Exception('Error al parsear respuesta del servidor: $e');
    } catch (e) {
      _bingos = [];
      _isLoading = false;
      errorMessage = 'Failed to load bingo shows: $e';
      notifyListeners();
      throw Exception('Error inesperado: $e');
    }
  }

  Future<Cartilla?> fetchShowscartilla(BuildContext context) async {
    /*print('===============================================================');
    print('***** busqueda de cartillas *****');
    print('info bingo => $bingo');
    print('modulo => $qrcode');
    print('===============================================================');*/

    _isLoading = true;
    clearBooklet();
    notifyListeners();

    final url = Uri.parse(
        '${pf.getIp.toString()}/api/GrupoCartillaDetalle/GetItemNameGrupo/$qrcode/${bingo.bingoId}');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );

    if (response.statusCode == 200) {
      Cartilla booklet = cartillaFromJson(utf8.decode(response.bodyBytes));
      //print('cartilla encontrada => $booklet');

      if (booklet.grupoCartillas?.isNotEmpty == true) {
        double total = 0.0;
        _preciofinal = 0;
        double precio = bingo.precioPorCartilla ?? 0;

        var jsonData = jsonDecode(booklet.grupoCartillas!);
        //print('jsonData grupo cartillas => $jsonData');

        for (var numero in jsonData) {
          Booklet cartilla = Booklet();
          cartilla.cartillaId = numero.toString();
          cartilla.quantity = 1;
          cartilla.estado = true;
          cartilla.price = precio;

          total = total + precio;
          _preciofinal = double.parse(total.toStringAsFixed(2)).toInt();

          booklet.listCartillas.add(cartilla);
          _infoBooklet.add(cartilla);
          _listBooklet.add(booklet);
        }
        //print('lista cartillas armadas => ${booklet.toJson()}');
        //print('lista _response => $_reponse');
        //print('lista _responsevalores => $_reponsevalores');
      } else {
        clearBooklet();
        const snackBar = SnackBar(
          content: Center(
              child: Text('No Hay Cartillas disponibles para la venta..')),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
      _isLoading = false;
      notifyListeners();
      //print('lista cartillas => $infoBooklet');
      return booklet;
    } else {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load shows');
    }
  }

  Future<bool> registerSale(BuildContext context) async {
    SaleQuery sale = SaleQuery();
    List<Map<String, int>> booklets = [];

    if (infoBooklet.isNotEmpty) {
      for (var booklet in infoBooklet) {
        //booklets.add({"cartillaId": int.parse(booklet.cartillaId.toString())});
        if (booklet.estado == true) {
          booklets
              .add({"cartillaId": int.parse(booklet.cartillaId.toString())});
        }
      }
    }

    sale.ventaId = 0;
    sale.bingoId = bingo.bingoId;
    sale.clienteId = 0;
    sale.promotorId = pf.getPromotorId;
    sale.codigoModulo = qrcode;
    sale.multiplicado = aditional == 2 ? _aditional : 0;
    sale.tipo = _aditional + 1;
    sale.ventasDetalle = booklets;

    final url =
        Uri.parse('${pf.getIp.toString()}/api/PromotorInterno/PostVentaManual');

    //print('body ventas => ${json.encode(sale.toMap())}');

    try {
      final response = await http.post(url,
          headers: {'Content-Type': 'application/json'},
          body: json.encode(sale.toMap()));

      if (response.statusCode == 200) {
        reset();
        const snackBar = SnackBar(
          content: Center(child: Text('Venta exitosa.')),
          backgroundColor: Colors.green,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        notifyListeners();
        return true;
      } else {
        const snackBar = SnackBar(
          content: Center(child: Text('No Se ha confirmado la venta.')),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        return false;
      }
    } catch (e) {
      print('error => $e');
      const snackBar = SnackBar(
        content: Center(child: Text('Error al procesar la venta.')),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      return false;
    }
  }

  void updateEstado(String cartillaId, bool newEstado) {
    Booklet? booklet = _infoBooklet.firstWhere(
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

  void increment() {
    _counter++;
    calculeTotal();
  }

  void decrement() {
    if (_counter > 1) {
      _counter--;
    }
    calculeTotal();
  }

  void calculeTotal() {
    double precio = 0;
    double total = 0.0;
    //print('tipo bingo => $_aditional');
    switch (_aditional) {
      case 0:
        for (var booklet in infoBooklet) {
          if (booklet.estado == true) {
            precio = bingo.precioPorCartilla ?? 0;
            total = total + precio;
          }
        }
        _preciofinal = double.parse(total.toStringAsFixed(2)).toInt();
        break;
      case 2:
        //print('cartilla activas => $infoBooklet');
        for (var booklet in infoBooklet) {
          if (booklet.estado == true) {
            precio = bingo.precioPorCartilla ?? 0;
            total = total + (precio * _counter) + precio;
          }
        }
        _preciofinal = double.parse(total.toStringAsFixed(2)).toInt();
        //print('total x pagar => $_preciofinal');
        break;
      default:
        _preciofinal = 0;
        break;
    }
    //updateCounter(contador);
    notifyListeners();
  }

  void updatestatus(int value) {
    _status = value;
    notifyListeners();
  }

  void updateLoading(bool state) {
    _isLoading = state;
    notifyListeners();
  }

  void updateaditional(int value) {
    _aditional = value;
    notifyListeners();
  }

  void updateBingo(Bingo info) {
    _bingo = info;
    notifyListeners();
  }

  void updateCurrentDate(DateTime newDate) {
    _currentDate = newDate;
    notifyListeners();
  }

  void updateQrcode(String newQrcode) {
    _qrcode = newQrcode;
    notifyListeners();
  }

  void updateBingoState(List<Bingo> updatedBingos) {
    _bingos = updatedBingos;
    notifyListeners();
  }

  void updateCounter(int value) {
    _counter = value;
    notifyListeners();
  }

  void clearBooklet() {
    _listBooklet.clear();
    _infoBooklet.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      notifyListeners();
    });
  }

  void reset() {
    _counter = 0;
    _preciofinal = 0;
    _aditional = 0;
    _qrcode = '-1';
    clearBooklet();
  }
}

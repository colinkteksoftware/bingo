import 'dart:convert';
import 'dart:io';
import 'package:bingo/core/data/models/bingoSala.dart';
import 'package:bingo/core/data/models/bingo.dart';
import 'package:bingo/core/data/models/booklet.dart';
import 'package:bingo/core/data/models/cartillaconvert.dart';
import 'package:bingo/core/data/models/requestQuey.dart';
import 'package:bingo/core/data/models/saleQuery.dart';
import 'package:bingo/utils/comparations.dart';
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

  String? _figure = '';
  String? get figure => _figure;

  final TextEditingController counterController = TextEditingController();

  BingoProvider() {
    counterController.text = _counter.toString();
    counterController.addListener(() {
      final value = int.tryParse(counterController.text);
      if (value != null && value >= 1 && value != _counter) {
        _counter = value;
        calculeTotal();
      }
    });
  }

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
        final Map<String, dynamic> info = json.decode(response.body);
        //print('Respuesta del servidor: $info');
        final bingoData = info['bingo'];
        final data = Bingo.fromMap(bingoData);
        //print('Bingo actualizado: $data');
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
        //print('response: $info');
        List<BingoSala> bingos = bingoSalaFromMap(info);

        if (bingos.isEmpty) {
          _isLoading = false;
          notifyListeners();
          debugPrint(
              '⚠️ No se encontraron bingos activos para el estado $state.');
          return [];
        }

        if (bingos.first.premios.isEmpty) {
          _isLoading = false;
          notifyListeners();
          debugPrint('⚠️ El bingo no tiene premios configurados.');
          return [];
        }

        /*var figureGame =
            bingos[0].premios[0].grupo ?? bingos[0].premios[0].figura ?? '';*/
        var figureGame = bingos.first.premios.first.grupo ??
            bingos.first.premios.first.figura ??
            '';

        updatefigure(figureGame);
        //print('figura => $_figure');

        List<Bingo> nuevosBingos = obtenerBingos(bingos);
        bool sonIguales = listsEquals(_bingos, nuevosBingos);

        if (!sonIguales) {
          _bingos = nuevosBingos;

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

  /*Future<Cartilla?> fetchShowscartilla(BuildContext context) async {
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
      Cartilla newBooklet = cartillaFromJson(utf8.decode(response.bodyBytes));

      if (newBooklet.grupoCartillas?.isNotEmpty == true) {
        double total = 0.0;
        _preciofinal = 0;
        double precio = bingo.precioPorCartilla ?? 0;

        var jsonData = jsonDecode(newBooklet.grupoCartillas!);

        for (var numero in jsonData) {
          String id = numero.toString();

          // Verificar si ya existe ese id en las listas globales
          bool existeEnInfo = _infoBooklet.any((c) => c.cartillaId == id);
          bool existeEnList = _listBooklet
              .expand((b) => b.listCartillas)
              .any((c) => c.cartillaId == id);

          print('agregado a infoBokklet => $existeEnInfo');
          print('agregado a listBooklet => $existeEnList');

          for (var numero in jsonData) {
            Booklet cartilla = Booklet();
            cartilla.cartillaId = numero.toString();
            cartilla.quantity = 1;
            cartilla.estado = true;
            cartilla.price = precio;

            total = total + precio;
            _preciofinal = double.parse(total.toStringAsFixed(2)).toInt();

            newBooklet.listCartillas.add(cartilla);
            _infoBooklet.add(cartilla);
            _listBooklet.add(newBooklet);
          }

          /*f (!existeEnInfo && !existeEnList) {
            Booklet cartilla = Booklet()
              ..cartillaId = id
              ..quantity = 1
              ..estado = true
              ..price = precio;

            total += precio;
            _preciofinal = double.parse(total.toStringAsFixed(2)).toInt();

            // ✅ Agregamos a la cartilla global
            newBooklet.listCartillas.add(cartilla);
            _infoBooklet.add(cartilla);
          } else {
            debugPrint("⚠️ Cartilla $id ya estaba en las listas, se omite.");
          }*/
        }

        // ✅ Al final, agregamos la cartilla completa solo una vez
        _listBooklet.add(newBooklet);
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
      return newBooklet;
    } else {
      _isLoading = false;
      notifyListeners();
      throw Exception('Failed to load shows');
    }
  }*/

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
        print('jsonData grupo cartillas => $jsonData');

        /*for (var numero in jsonData) {
          Booklet cartilla = Booklet();
          cartilla.cartillaId = numero.toString();
          cartilla.quantity = 1;
          cartilla.estado = true;
          cartilla.price = precio;

          bool existeEnInfo =
              _infoBooklet.any((c) => c.cartillaId == cartilla.cartillaId);
          bool existeEnList = booklet.listCartillas
              .any((c) => c.cartillaId == cartilla.cartillaId);

          if (!existeEnInfo && !existeEnList) {
            total = total + precio;
            _preciofinal = double.parse(total.toStringAsFixed(2)).toInt();

            booklet.listCartillas.add(cartilla);
            _infoBooklet.add(cartilla);
            _listBooklet.add(booklet);
          } else {
            debugPrint(
                "Cartilla ${cartilla.cartillaId} ya estaba en las listas, no se agregó.");
          }
        }*/

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
    _isLoading = true;
    errorMessage = null;
    notifyListeners();
    SaleQuery sale = SaleQuery();
    List<Map<String, int>> booklets = [];
    print('lista de cartillas escaneadas => ${infoBooklet.toString()}');
    if (infoBooklet.isNotEmpty) {
      for (var booklet in infoBooklet) {
        if (booklet.estado == true) {
          int newCartillaId = int.parse(booklet.cartillaId.toString());
          bool exists = booklets.any((b) => b['cartillaId'] == newCartillaId);
          if (!exists) {
            booklets.add({"cartillaId": newCartillaId});
          }
        }
      }
    }

    sale.ventaId = 0;
    sale.bingoId = bingo.bingoId;
    sale.clienteId = 0;
    sale.promotorId = pf.getPromotorId;
    sale.codigoModulo = qrcode;
    sale.multiplicado = aditional == 2 ? _counter : 0;
    sale.tipo = _aditional + 1;
    sale.ventasDetalle = booklets;

    final url =
        Uri.parse('${pf.getIp.toString()}/api/PromotorInterno/PostVentaManual');

    print('body ventas => ${json.encode(sale.toMap())}');

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
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        const snackBar = SnackBar(
          content: Center(child: Text('No Se ha confirmado la venta.')),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      print('error => $e');
      const snackBar = SnackBar(
        content: Center(child: Text('Error al procesar la venta.')),
        backgroundColor: Colors.red,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      _isLoading = false;
      notifyListeners();
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
    final day = DateTime.now();
    final isWeekday = day.weekday <= 5;
    final maxLimit = isWeekday ? 3 : 10;

    _counter++;
    if (_counter > maxLimit) _counter = maxLimit;

    counterController.text = _counter.toString();
    calculeTotal();
  }

  void decrement() {
    if (_counter > 1) {
      _counter--;
      counterController.text = _counter.toString();
    }
    calculeTotal();
  }

  void calculeTotal() {
    double precio = 0;
    double total = 0.0;
    switch (_aditional) {
      case 0:
        print('lista de cartillas => $infoBooklet');
        for (var booklet in infoBooklet) {
          if (booklet.estado == true) {
            precio = bingo.precioPorCartilla ?? 0;
            total = total + precio;
          }
        }
        _preciofinal = double.parse(total.toStringAsFixed(2)).toInt();
        print('precio => $precio');
        print('total => $total');
        break;
      case 2:
        for (var booklet in infoBooklet) {
          if (booklet.estado == true) {
            precio = bingo.precioPorCartilla ?? 0;
            total = total + (precio * _counter) + precio;
            print('total con cartilla${booklet.cartillaId} => $total');
          }
        }
        _preciofinal = double.parse(total.toStringAsFixed(2)).toInt();
        print('precio => $precio');
        print('total => $total');
        print('multiplicado => $_counter');
        break;
      default:
        _preciofinal = 0;
        break;
    }
    notifyListeners();
  }

  void updatefigure(String value) {
    _figure = value;
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
    if (value >= 1) {
      _counter = value;
      counterController.text = value.toString();
      calculeTotal();
    }
  }

  void clearBooklet() {
    _listBooklet.clear();
    _infoBooklet.clear();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      //updateQrcode('');
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

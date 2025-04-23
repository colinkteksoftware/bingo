import 'package:bingo/models/bingoconvert.dart';
import 'package:flutter/material.dart';
import 'package:bingo/services/bingo_service.dart';

class PaymentProvider extends ChangeNotifier {
  final BingoService _bingoService = BingoService();
  
  List<Bingo> _bingos = [];
  List<Bingo> get bingos => _bingos;
  
  Future<void> loadBingos() async {
    try {
      List<Bingo> loadedBingos = await _bingoService.getBingosAvailaibles();
      if (loadedBingos.isNotEmpty) {
        _bingos = loadedBingos;
        notifyListeners();
      }
    } catch (e) {
      print('Error al cargar los bingos: $e');
    }
  }
  
  void updateBingoState(List<Bingo> updatedBingos) {
    _bingos = updatedBingos;
    notifyListeners();
  }
  
  void getStatusBingo() {
    _bingoService.bingoStream.listen((updatedBingos) {
      _bingos = updatedBingos;
      notifyListeners();
    });
  }
}

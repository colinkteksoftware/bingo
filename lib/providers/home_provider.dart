import 'package:bingo/models/bingoconvert.dart';
import 'package:flutter/material.dart';
import '../services/bingo_service.dart';

class HomeProvider with ChangeNotifier {
  final BingoService _bingoService = BingoService();

  List<BingoSala>? bingoList;
  bool isLoading = false;
  String? errorMessage;
  
  Future<void> loadBingoShows(DateTime bingoFecha, String ip) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      bingoList = await _bingoService.fetchShowsBingo(bingoFecha, ip);
      isLoading = false;
    } catch (e) {
      errorMessage = 'Failed to load bingo shows: $e';
      isLoading = false;
    }
    notifyListeners();
  }
}

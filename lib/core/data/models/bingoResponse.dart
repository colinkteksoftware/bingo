import 'package:bingo/core/data/models/bingo.dart';
import 'package:bingo/core/data/models/winner.dart';

class BingoResponse {
  final Bingo bingo;
  final List<Winner> ganadores;

  BingoResponse({
    required this.bingo,
    required this.ganadores,
  });

  factory BingoResponse.fromJson(Map<String, dynamic> json) {
    return BingoResponse(
      bingo: Bingo.fromMap(json['bingo']),
      ganadores: (json['ganadores'] as List)
          .map((e) => Winner.fromJson(e))
          .toList(),
    );
  }
}
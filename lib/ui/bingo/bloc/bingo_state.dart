import 'package:bingo/core/data/models/booklet.dart';

class GameTypeState {
  final int aditional;
  final int counter;
  final List<Booklet> booklets;
  final double precioPorCartilla;
  final int total;

  GameTypeState({
    required this.aditional,
    required this.counter,
    required this.booklets,
    required this.precioPorCartilla,
    required this.total,
  });

  GameTypeState copyWith({
    int? aditional,
    int? counter,
    List<Booklet>? booklets,
    double? precioPorCartilla,
    int? total,
  }) {
    return GameTypeState(
      aditional: aditional ?? this.aditional,
      counter: counter ?? this.counter,
      booklets: booklets ?? this.booklets,
      precioPorCartilla: precioPorCartilla ?? this.precioPorCartilla,
      total: total ?? this.total,
    );
  }
}
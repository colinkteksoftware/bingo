import 'package:bingo/core/data/models/booklet.dart';

abstract class GameTypeEvent {}

class SelectAditional extends GameTypeEvent {
  final int aditional;
  SelectAditional(this.aditional);
}

class IncrementCounter extends GameTypeEvent {}

class DecrementCounter extends GameTypeEvent {}

class ChangeCounter extends GameTypeEvent {
  final int counter;
  ChangeCounter(this.counter);
}

class UpdateBooklets extends GameTypeEvent {
  final List<Booklet> booklets;
  UpdateBooklets(this.booklets);
}

class SetPrecioPorCartilla extends GameTypeEvent {
  final double precio;
  SetPrecioPorCartilla(this.precio);
}
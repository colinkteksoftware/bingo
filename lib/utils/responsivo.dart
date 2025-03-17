import 'package:flutter/material.dart';
import 'dart:math' as math;

class Responsivo {
  late double _width, _height, _diagonal;

  double get width => _width;
  double get height => _height;
  double get diagonal => _diagonal;

  static Responsivo of(BuildContext context) => Responsivo(context);

  Responsivo(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    this._width = size.width;
    this._height = size.height;
    this._diagonal = math.sqrt(math.pow(_width, 2));
  }
  double wp(double porcentaje) => _width * porcentaje / 100;
  double hp(double porcentaje) => _height * porcentaje / 100;
  double dp(double porcentaje) => _diagonal * porcentaje / 100;
}

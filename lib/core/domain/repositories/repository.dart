import 'package:bingo/core/data/models/auth.dart';
import 'package:bingo/core/data/models/modelPromotor.dart';

abstract class Repository {

  Future<ModelPromotor> login(Auth auth);

}
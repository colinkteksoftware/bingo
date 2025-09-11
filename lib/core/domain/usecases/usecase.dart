import 'package:bingo/core/data/models/auth.dart';
import 'package:bingo/core/data/models/modelPromotor.dart';
import 'package:bingo/core/domain/repositories/repository.dart';

class UseCase {

  final Repository repository;

  UseCase(this.repository);

  Future<ModelPromotor?> login(Auth auth) async {
    try {
      return await repository.login(auth);
    } catch (e) {
      rethrow;
    }
  }

}
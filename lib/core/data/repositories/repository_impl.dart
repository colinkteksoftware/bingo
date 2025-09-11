import 'package:bingo/core/data/datasource/datasource.dart';
import 'package:bingo/core/data/models/auth.dart';
import 'package:bingo/core/data/models/modelPromotor.dart';
import 'package:bingo/core/domain/repositories/repository.dart';

class RepositoryImpl implements Repository {
  final DataSource dataSource;

  RepositoryImpl(this.dataSource);

  @override
  Future<ModelPromotor> login(Auth auth) async {
    try {
      return await dataSource.login(auth);
    } catch (e) {
      rethrow;
    }
  }

}
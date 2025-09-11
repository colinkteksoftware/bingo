import 'package:bingo/core/data/models/auth.dart';
import 'package:bingo/core/data/models/modelPromotor.dart';
import 'package:bingo/core/domain/api/api_services.dart';

class DataSource {

  final ApiService apiService;

  DataSource(this.apiService);

  Future<ModelPromotor> login(Auth auth) async {
    return apiService.login(auth);
  }

}
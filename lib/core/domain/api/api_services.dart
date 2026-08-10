import 'dart:convert';

import 'package:bingo/core/data/models/auth.dart';
import 'package:bingo/core/data/models/modelPromotor.dart';
import 'package:bingo/core/domain/api/endpoints.dart';
import 'package:bingo/core/domain/responses/failure.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:http/http.dart' as http;

class ApiService {
  ApiService();

  final pf = Preferencias();

  Future<ModelPromotor> login(Auth user) async {
    final url = Uri.parse('${pf.getIp}${Endpoints.login()}').replace(
      queryParameters: {
        'usuario': user.usuario ?? '',
        'password': user.password ?? '',
      },
    );
    final headers = {'Content-Type': 'application/json'};
    final response = await http.post(url, headers: headers, body: '{}');
    //print('status connection => $response');
    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final dynamic payload =
          data is Map<String, dynamic> && data['data'] is Map<String, dynamic>
              ? data['data']
              : data;

      if (payload is! Map<String, dynamic>) {
        throw Failure();
      }

      ModelPromotor promotor = ModelPromotor.fromMap(payload);
      /*print(
          '===================================================================');
      print(url);
      print('RESPONSE => ${ModelPromotor.fromMap(data)}');
      print(
          '===================================================================');*/
      return promotor;
    } else {
      throw Failure();
    }
  }
}

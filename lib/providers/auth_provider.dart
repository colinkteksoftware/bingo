import 'package:bingo/core/data/models/auth.dart';
import 'package:bingo/core/data/models/modelPromotor.dart';
import 'package:bingo/core/domain/usecases/usecase.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:bingo/utils/defaults.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  final pf = Preferencias();
  final UseCase useCase;

  AuthProvider(this.useCase);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  ModelPromotor? _promotor = ModelPromotor();
  ModelPromotor? get promotor => _promotor;

  Future<bool> login(BuildContext context, String usuario, String password,
      bool remember) async {
    _isLoading = true;
    notifyListeners();
    try {
      if (pf.getIp.trim().isEmpty) {
        pf.setIP = basement;
      }

      Auth user = Auth();
      user.usuario = usuario;
      user.password = password;

      _promotor = await useCase.login(user);

      pf.setPromotorId = _promotor?.promotorId ?? 0;
      pf.setSellerName = _promotor?.nombres ?? '';
      pf.setSellerLast = _promotor?.apellidos ?? '';
      pf.setProfile = _promotor?.tipousuario ?? 0;
      pf.setSellerState = _promotor?.estado ?? false;

      if (remember) {
        if (_promotor?.estado == true &&
                _promotor?.usuario.toString() ==
                    usuario.toString().toUpperCase() ||
            _promotor?.usuario.toString() == usuario.toString().toLowerCase()) {
          pf.setUsuario = usuario;
          pf.setRecuerda = remember;
          pf.setpassword = password;
        } else {
          showAlerta(context, 'Mensaje Informativo',
              '¡Contraseña Incorrecta. Verificar, por favor!');
          pf.setUsuario = '';
          pf.setpassword = '';
          _isLoading = false;
          notifyListeners();
          return false;
        }
      } else {
        pf.setUsuario = '';
        pf.setpassword = '';
        pf.setRecuerda = false;
      }

      if (_promotor?.estado == true &&
              _promotor?.usuario.toString() ==
                  usuario.toString().toUpperCase() ||
          _promotor?.usuario.toString() == usuario.toString().toLowerCase()) {
        const snackBar = SnackBar(
            content: Center(
              child: Text("Iniciando sesión un momento ..."),
            ),
            duration: Duration(milliseconds: 2000));
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        _isLoading = false;
        notifyListeners();
        return true;
      } else {
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      pf.setpassword = '';
      _isLoading = false;
      notifyListeners();
      showAlerta(context, 'Mensaje Informativo',
          'Servidor no Responde, Verifique la configuracion de la ip.');
      return false;
    }
  }
}

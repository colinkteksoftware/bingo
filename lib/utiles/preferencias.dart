import 'package:shared_preferences/shared_preferences.dart';

class Preferencias {
  static final Preferencias _preferencias = new Preferencias._internal();

  factory Preferencias() {
    return _preferencias;
  }

  Preferencias._internal();

  late SharedPreferences _prefs; // revisar si funciona

  initPrefs() async {
    this._prefs = await SharedPreferences.getInstance();
  }

  get getAno {
    try {
      return _prefs.getInt('AnoActual') ?? 0;
    } catch (e) {
      return '0';
    }
  }

  set setAno(int value) {
    _prefs.setInt('AnoActual', value);
  }

  get getContrato {
    try {
      return _prefs.getString('Contrato') ?? 'Seleccionar Contrato';
    } catch (e) {
      return '0';
    }
  }

  set setContrato(String value) {
    _prefs.setString('Contrato', value);
  }

  get getIpCliente {
    try {
      return _prefs.getString('IpCliente') ?? '0.0.0.0';
    } catch (e) {
      return '0.0.0.0';
    }
  }

  set setIpCliente(String value) {
    _prefs.setString('IpCliente', value);
  }

  get getCodConsorcio {
    try {
      return _prefs.getInt('CodConsorcio') ?? 0;
    } catch (e) {
      return '0';
    }
  }

  set setCodConsorcio(int value) {
    _prefs.setInt('CodConsorcio', value);
  }

  get getEmpresa {
    try {
      return _prefs.getString('Empresa') ?? 'Seleccionar Empresa';
    } catch (e) {
      return 0;
    }
  }

  set setEmpresa(String value) {
    _prefs.setString('Empresa', value);
  }

  get getCodigoEmpresa {
    try {
      return _prefs.getInt('CodigoEmpresa') ?? '';
    } catch (e) {
      return '';
    }
  }

  set setCodigoEmpresa(int value) {
    _prefs.setInt('CodigoEmpresa', value);
  }

  set setCodigoSala(int value) {
    _prefs.setInt('CodigoSala', value);
  }
 set setCodigoSalaalarma(int value) {
    _prefs.setInt('CodigoSalaalarma', value);
  }

  get getCodigoSalaalarma{
    try {
      return _prefs.getInt('CodigoSalaalarma') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  get getCodigoSala {
    try {
      return _prefs.getInt('CodigoSala') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  set setCodigoS(int value) {
    _prefs.setInt('CodigoS', value);
  }

  get getCodigoS {
    try {
      return _prefs.getInt('CodigoS') ?? 0;
    } catch (e) {
      return 0;
    }
  }

  set setSala(String value) {
    _prefs.setString('Sala', value);
  }

  get getSala {
    try {
      return _prefs.getString('Sala') ?? '';
    } catch (e) {
      return 0;
    }
  }

  get getfoto {
    try {
      return _prefs.getString('foto') ?? 'assets/login2.png';
    } catch (e) {
      return 'assets/login2.png';
    }
  }

  set setfoto(String value) {
    _prefs.setString('foto', value);
  }

  get getfotoEnc {
    try {
      return _prefs.getString('foto') ?? 'assets/camara.png';
    } catch (e) {
      return 'assets/camara.png';
    }
  }

  set setfotoEnc(String value) {
    _prefs.setString('foto', value);
  }

  get getfondo {
    try {
      return _prefs.getString('fondo') ?? 'assets/camara.png';
    } catch (e) {
      return 'assets/camara.png';
    }
  }

  set setfondo(String value) {
    _prefs.setString('fondo', value);
  }

  get getcorreo {
    try {
      return _prefs.getString('correo') ?? '';
    } catch (e) {
      return '';
    }
  }

  set setcorreo(String value) {
    _prefs.setString('correo', value);
  }

  get getIp {
    try {
      return _prefs.getString('ip') ?? '';
    } catch (e) {
      return '';
    }
  }

  set setIP(String value) {
    _prefs.setString('ip', value);
  }

  get getPermisos {
    try {
      return _prefs.getStringList('menu') ?? '';
    } catch (e) {
      return '';
    }
  }

  set setPermisos(List<String> value) {
    _prefs.setStringList('menu', value);
  }

  get getUsuario {
    try {
      return _prefs.getString('usuario') ?? '';
    } catch (e) {
      return '';
    }
  }

  set setUsuario(String value) {
    _prefs.setString('usuario', value);
  }

  get getpassword {
    try {
      return _prefs.getString('password') ?? '';
    } catch (e) {
      return '';
    }
  }

  set setpassword(String value) {
    _prefs.setString('password', value);
  }

  get getNomnre {
    try {
      return _prefs.getString('nombre') ?? '';
    } catch (e) {
      return '';
    }
  }

  set setNombre(String value) {
    _prefs.setString('nombre', value);
  }

  get getNomnbres {
    try {
      return _prefs.getString('nombres') ?? '';
    } catch (e) {
      return '';
    }
  }

  set setNombres(String value) {
    _prefs.setString('nombres', value);
  }

  get getApellidos {
    try {
      return _prefs.getString('apellidos') ?? '';
    } catch (e) {
      return '';
    }
  }

  set setApellidos(String value) {
    _prefs.setString('apellidos', value);
  }

  get getRecuerda {
    try {
      return _prefs.getBool('recuerda') ?? false;
    } catch (e) {
      return false;
    }
  }

  set setRecuerda(bool value) {
    _prefs.setBool('recuerda', value);
  }

  get getSalasMenus {
    try {
      return _prefs.getString('SalasMenus') ?? '';
    } catch (e) {
      return '';
    }
  }

  set setSalasMenus(String value) {
    _prefs.setString('SalasMenus', value);
  }


 

  get getServerNube {
    try {
      return _prefs.getBool('ServerNube') ?? false;
    } catch (e) {
      return false;
    }
  }

  set setServerNube(bool value) {
    _prefs.setBool('ServerNube', value);
  }

 get getPais {
    try {
      return _prefs.getInt('Pais') ?? 0;
    } catch (e) {
      return '0';
    }
  }

  set setPais(int value) {
    _prefs.setInt('Pais', value);
  }

}

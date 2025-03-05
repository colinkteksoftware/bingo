import 'dart:convert';
import 'dart:typed_data';
/* import 'dart:ui'; */
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

String convertirdinero(dynamic n) {
  dynamic x = "";
  String rp = "";

  x = n;
  try {
    if (x.toString() != "") {
      // final currencyFormatter = NumberFormat.currency(locale: 'eu', symbol: '');
      //final currencyFormatter = new NumberFormat("#,##0.00", "en_US");
      final currencyFormatter = new NumberFormat.simpleCurrency();
      rp = currencyFormatter.format(x);
      return rp;
    } else {
      n = "";
      return "\$0.0";
    }
  } catch (e) {
    return "\$0.0";
  }
}

String convertirdinero2(dynamic n) {
  String x = "";
  //int digitos = 0;
// encontrar el punto decimal o un valor en una cadena
  // for (MapEntry e in n.split("").asMap().entries) {
  //   if (e.value == '.') {
  //     digitos = e.key;
  //   }
  // }
  x = (n).toString();
  try {
    if (x.toString() != "") {
      // x = x.replaceAll(".", "");
      // x = x.replaceAll(",", "");
      // n = double.parse(x);
      // n = n / 100;
      // final currencyFormatter = NumberFormat.currency(locale: 'eu', symbol: '');

      return "\$" + n.toString();
      // currencyFormatter.format(n);
    } else {
      n = "";
      return "\$0.0";
    }
  } catch (e) {
    return "\$0.0";
  }
}

String convertirdinerosindecimales(dynamic n) {
  String x = "";
  dynamic logitud = 0;
  x = n.toString();

  try {
    if (x.toString() != "") {
      final currencyFormatter = NumberFormat.currency(locale: 'eu', symbol: '');
      x = currencyFormatter.format(n).trim();
      logitud = x.length;
      x = x.substring(0, logitud - 3);
      return "\$" + x;
    } else {
      n = "";
      return "\$0.0";
    }
  } catch (e) {
    return "\$0.0";
  }
}
/* var argentina = NumberSymbols(
      NAME: "es_AR",
      DECIMAL_SEP: ',',
      GROUP_SEP: '.',
      PERCENT: '%',
      ZERO_DIGIT: '0',
      PLUS_SIGN: '+',
      MINUS_SIGN: '-',
      EXP_SYMBOL: 'E',
      PERMILL: '\u2030',
      INFINITY: '\u221E',
      NAN: 'NaN',
      DECIMAL_PATTERN: '#,##0.###',
      SCIENTIFIC_PATTERN: '#E0',
      PERCENT_PATTERN: '#,##0\u00A0%',
      CURRENCY_PATTERN: '\u00A4#,##0.00\u00A0',
      DEF_CURRENCY_CODE: r'$');

  numberFormatSymbols['es_AR'] = argentina;
  var f = NumberFormat.currency(locale: 'es_AR');
  return f.format(n);
  // print(f.format(1234)); */

String formatoNumero(dynamic n) {
  String x = "";

  x = n.toString();
  try {
    if (x.toString() != "") {
      final currencyFormatter = NumberFormat.currency(locale: 'eu', symbol: '');

      return currencyFormatter.format(n);
    } else {
      n = "";
      return "0.0";
    }
  } catch (e) {
    return "0.0";
  }
}

String formatoFecha(dynamic now) {
  if (now != "") {
    String hora = DateFormat('hh:mm:a').format(now);
    String fecha =
        "${now.day.toString().padLeft(2, '0')}-${now.month.toString().padLeft(2, '0')}-${now.year.toString()} $hora";

    return fecha;
  } else {
    return "fecha sin asignar";
  }
}

Color? colorE(dynamic monto) {
  late Color im;

  if (int.parse(monto) < 0) {
    im = Colors.red;
  } else {
    im = Colors.blue;
  }

  return im;
}

Color? colorEstadoDouble(double monto) {
  late Color im;
  // print(strImagen);
  if (monto < 0) {
    im = Colors.red;
  } else {
    im = Colors.black;
  }

  return im;
}

Color? colorEstadoOnOFF(String strColor) {
  late Color im;
  // print(strImagen);
  if (strColor.toUpperCase().trim() == "OFF") {
    im = Colors.red;
  } else if (strColor.toUpperCase().trim() == "ON") {
    im = Colors.black;
  } else {
    im = Colors.black;
  }

  return im;
}

int stringNumero(String x) {
  int numero = 0;
  x = x.substring(1);
  x = x.replaceAll(".", "");
  x = x.replaceAll(",", "");
  numero = int.parse(x);
  numero = numero ~/ 100;

  return numero;
}

int stringNumero2(String x) {
  int numero = 0;
  x = x.replaceAll(",", "");
  numero = int.parse(x);
  numero = numero ~/ 100;
  return numero;
}

double stringDouble(String n) {
  double numero = 0.00;
  try {
    numero = double.parse(n.replaceAll(",", "."));
    return numero;
  } catch (e) {
    return numero;
  }
}

double stringDouble2(String n) {
  double numero = 0.00;
  String numerostr = "";
  try {
    numerostr = n.substring(0, n.length - 3);
    //numerostr = n.replaceAll(",", "");
    numerostr = numerostr.replaceAll(".", "");
    numero = NumberFormat().parse(numerostr) as double;
    return numero;
  } catch (e) {
    return numero;
  }
}

void showAlerta(BuildContext context, String titulo, String mensaje) {
  var size = MediaQuery.of(context).size;
  showDialog(
      context: context,
      builder: (buildcontext) {
        return AlertDialog(
          title: Container(
            child: Column(
              children: [
                Image.asset(
                  'assets/images/logo.png',
                  height: 60,

                  //color: Colors.white,
                ),
                Text(
                  "$titulo",
                  style: TextStyle(
                    color: Color(0xFF03045e),
                    fontSize: size.width * 0.032,
                    fontFamily: 'gotic',
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),
          content: Text(
            "$mensaje",
            style: TextStyle(
              color: Color(0xFF03045e),
              fontSize: size.width * 0.032,
              fontFamily: 'gotic',
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text(
                "OK",
                style: TextStyle(
                  color: Color(0xFFcaf0f8),
                  fontSize: size.width * 0.032,
                  fontFamily: 'gotic',
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Color(0xFF03045e),
                disabledForegroundColor: Colors.grey.withOpacity(0.38),
                disabledBackgroundColor: Colors.grey.withOpacity(0.12),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      });
}

String obtenerIPLocal(String strIp) {
  String primeraCadena = '';
  String segundaCadena = '';
  primeraCadena = strIp.substring(7, strIp.length);
  segundaCadena = primeraCadena.split('/')[0];
  return segundaCadena;
}

ImageProvider? imagenEstado(String strImagen) {
  late String im;
  // print(strImagen);
  if (strImagen.toUpperCase().trim() == "OFF") {
    im = 'assets/off.png';
  } else if (strImagen.toUpperCase().trim() == "ON") {
    im = 'assets/on.png';
  } else if (strImagen.toUpperCase().trim() == "ON PLAY") {
    im = 'assets/juego.png';
  } else {
    im = 'assets/off.png';
  }

  return AssetImage(im);
}

ImageProvider imagenMenu(int opcion) {
  late String im;
  if (opcion == 0) {
    im = 'assets/Maquinas.png';
  } else if (opcion == 1) {
    im = 'assets/Ventas.png';
  } else if (opcion == 2) {
    im = 'assets/Grafico4.png';
  } else if (opcion == 3) {
    im = 'assets/Grafico8.png';
  } else if (opcion == 4) {
    im = 'assets/caja.png';
  } else if (opcion == 5) {
    im = 'assets/Mistery.jpeg';
  } else if (opcion == 6) {
    im = 'assets/tecnico2.png';
  }

  return AssetImage(im);
}

String tituloMenu(int opcion) {
  late String im;
  if (opcion == 0) {
    im = 'Slots On/Off';
  } else if (opcion == 1) {
    im = 'Ventas';
  } else if (opcion == 2) {
    im = 'Prod. por Slot';
  } else if (opcion == 3) {
    im = 'Slots en Juego';
  } else if (opcion == 4) {
    im = 'Caja';
  } else if (opcion == 5) {
    im = 'Progresivo';
  } else if (opcion == 6) {
    im = 'Servicio Tecnico';
  }
  return im;
}

Image imageFromBase64String(String base64String) {
  return Image.memory(base64Decode(base64String));
}

Uint8List dataFromBase64String(String base64String) {
  return base64Decode(base64String);
}

String base64String(Uint8List data) {
  return base64Encode(data);
}

List<String> dias = [
  "Lunes",
  "Martes",
  "Miercoles",
  "Jueves",
  "Viernes",
  "Sabado",
  "Domingo"
];
List<String> meses = [
  "Enero",
  "Febrero",
  "Marzo",
  "Abril",
  "Mayo",
  "Junio",
  "Julio",
  "Agosto",
  "Septiembre",
  "Octubre",
  "Noviembre",
  "Diciembre"
];

String getdia(int dia) {
  String strdia = '';
  for (int i = 0; i < dias.length; i++) {
    if (i == dia) {
      strdia = dias[i];
    }
  }

  return strdia;
}

String getmes(int mes) {
  String strmes = '';
  for (int i = 0; i <= meses.length; i++) {
    if (i == mes) {
      strmes = meses[i - 1];
    }
  }

  return strmes;
}

int getmesint(String mes) {
  int intrmes = 0;
  for (int i = 0; i < meses.length; i++) {
    if (meses[i] == mes) {
      intrmes = i;
    }
  }

  return intrmes;
}

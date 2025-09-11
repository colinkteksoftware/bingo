class ListaEmpresas {
  int codempresa;
  String empresa;

  ListaEmpresas({
    required this.codempresa,
    required this.empresa,
  });

  factory ListaEmpresas.fromJson(Map<String, dynamic> json) {
    return ListaEmpresas(
      codempresa: json['codempresa'],
      empresa: json['empresa'],
    );
  }
}

class ListaSalas {
  int codempresa;
  String empresa;
  int codsala;
  int cs;
  String sala;

  ListaSalas({
    required this.codempresa,
    required this.empresa,
    required this.codsala,
    required this.sala,
    required this.cs,
  });

  factory ListaSalas.fromJson(Map<String, dynamic> json) {
    return ListaSalas(
      codempresa: json['codempresa'],
      empresa: json['empresa'],
      codsala: json['codsala'],
      sala: json['sala'],
      cs: json['cs'],
    );
  }
}

class ListaMenus {
  int codMenu;

  ListaMenus({
    required this.codMenu,
  });

  factory ListaMenus.fromJson(Map<String, dynamic> json) {
    return ListaMenus(
      codMenu: json['menu'],
    );
  }
}

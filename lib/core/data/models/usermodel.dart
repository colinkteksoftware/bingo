class UserModel {
  int id;
  String nombre;
  String apellido;
  String email;
  String usulogin;
  String password;
  String foto;
  String serieregistro;

  UserModel(
      {required this.id,
      required this.nombre,
      required this.apellido,
      required this.email,
      required this.usulogin,
      required this.password,
      required this.foto,
      required this.serieregistro});

  factory UserModel.fromJson(Map<String, dynamic> json) => new UserModel(
        id: json["id"],
        nombre: json["nombre"],
        apellido: json["apellido"],
        email: json["email"],
        usulogin: json["usu_login"],
        password: json["password"],
        foto: json["foto"],
        serieregistro: json["serieregistro"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "apellido": apellido,
        "emal": email,
        "usu_login": usulogin,
        "password": password,
        "foto": foto,
        "serieregistro": serieregistro,
      };
}

class UserModelSID {
  String nombre;
  String apellido;
  String email;
  String usulogin;
  String password;
  String foto;
  String serieregistro;

  UserModelSID(
      {required this.nombre,
      required this.apellido,
      required this.email,
      required this.usulogin,
      required this.password,
      required this.foto,
      required this.serieregistro});

  factory UserModelSID.fromJson(Map<String, dynamic> json) => new UserModelSID(
        nombre: json["nombre"],
        apellido: json["apellido"],
        email: json["email"],
        usulogin: json["usu_login"],
        password: json["password"],
        foto: json["foto"],
        serieregistro: json["serieregistro"],
      );

  Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "apellido": apellido,
        "email": email,
        "usu_login": usulogin,
        "password": password,
        "foto": foto,
        "serieregistro": serieregistro,
      };
}

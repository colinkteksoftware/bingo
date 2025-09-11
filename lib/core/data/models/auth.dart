class Auth {
  String? usuario;
  String? password;

  Auth({
    this.usuario,
    this.password,
  });

  factory Auth.fromJson(Map<String, dynamic> json) => Auth(
        usuario: json["usuario"] ?? '',
        password: json["password"] ?? '',
      );

  Map<String, dynamic> authToMap() => {
        "usuario": usuario,
        "password": password,
      };

  @override
  String toString() {
    return 'Booklet(usuario: $usuario, password: $password)';
  }
}
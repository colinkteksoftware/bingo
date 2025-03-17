import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'dart:math';
import 'package:animated_button/animated_button.dart';
import 'package:bingo/ui/bingo_page.dart';
import 'package:bingo/ui/setting_page.dart';
import 'package:bingo/ui/user/person_page.dart';
import 'package:bingo/utils/background.dart';
import 'package:bingo/utils/conversiones.dart';
import 'package:bingo/utils/responsivo.dart';
import 'package:bingo/utils/defaults.dart';
import 'package:bingo/utils/routes.dart';
import 'package:flutter/material.dart';
import 'package:bingo/models/modelCliente.dart' as cliente;
import 'package:bingo/utils/preferencias.dart';
import 'package:bingo/models/salasconvert.dart';
import 'package:http/io_client.dart';

class LoginPage extends StatefulWidget {
  static const String routeName = '/login';

  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPage();
}

class _LoginPage extends State<LoginPage> {
  bool _loading = false;
  var txtControlerUsuario = TextEditingController();
  var txtControlerClave = TextEditingController();

  final pf = Preferencias();
  bool _isChecked = false;
  bool ocultaClave = true;

  @override
  void initState() {
    iniciarPreferencias();
    super.initState();
  }

  final ipController = TextEditingController(text: "0.0.0.0");

  void iniciarPreferencias() async {
    await pf.initPrefs();
    ipController.text = pf.getIp;
    pf.setCodigoSala = 0;
    _isChecked = pf.getRecuerda;
    txtControlerUsuario.text = pf.getUsuario;

    if (_isChecked) {
      txtControlerClave.text = pf.getpassword;
    } else {
      txtControlerClave.text = "";
    }
    setState(() {});
  }

  @override
  void dispose() {
    txtControlerUsuario.dispose();
    txtControlerClave.dispose();

    super.dispose();
  }

  Widget bottonSheet(BuildContext context, int opcion) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: const Column(
        children: [
          Text(
            'Seleccionar Fotografia',
            style: TextStyle(fontSize: 20.0),
          ),
          SizedBox(
            height: 20,
          ),
        ],
      ),
    );
  }

  final boxDecoration = const BoxDecoration(
      gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFcaf0f8), Color(0xFF00b4d8)],
          stops: [0.3, 0.9]));

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    List<Color> _colors = [Colors.greenAccent, Colors.blue];
    List<double> _stops = [0.0, 1];
    _isChecked = pf.getRecuerda;
    final Responsivo responsivo = Responsivo.of(context);
    var size = MediaQuery.of(context).size;
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        body: Stack(
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 6,
                  child: Container(
                    width: 100,
                    decoration: const BoxDecoration(),
                    alignment: const AlignmentDirectional(0, -1),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Stack(
                            children: [
                              Container(
                                decoration: boxDecoration,
                              ),
                              Positioned(
                                top: -130,
                                left: -15,
                                child: Column(
                                  children: [
                                    customBox3(),
                                  ],
                                ),
                              ),
                              Positioned(
                                top: 340,
                                left: 105,
                                child: Column(
                                  children: [
                                    customBox4(),
                                  ],
                                ),
                              ),
                              Align(
                                  alignment: const AlignmentDirectional(0, 0),
                                  child: Container(
                                    height: size.height,
                                    width: double.infinity,
                                    constraints:
                                        const BoxConstraints(maxWidth: 570),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Align(
                                      alignment:
                                          const AlignmentDirectional(0, 0),
                                      child: Padding(
                                        padding: const EdgeInsets.all(32),
                                        child: Column(
                                          mainAxisSize: MainAxisSize.max,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 20, 0, 0),
                                              child: Container(
                                                  height: size.height * 0.2,
                                                  decoration:
                                                      const BoxDecoration(
                                                    image: DecorationImage(
                                                        image: AssetImage(
                                                            "assets/images/logo.png"),
                                                        fit: BoxFit.fill),
                                                  ),
                                                  alignment:
                                                      const AlignmentDirectional(
                                                          0, 0)),
                                            ),
                                            Text(
                                              'Bienvenido',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: size.width * 0.08,
                                                fontWeight: FontWeight.bold,
                                                color: const Color(0xFF03045e),
                                                fontFamily: 'Poppins',
                                                letterSpacing: 0.0,
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsetsDirectional
                                                      .fromSTEB(0, 12, 0, 24),
                                              child: Text(
                                                'Ingresa los datos de tu cuenta para continuar',
                                                textAlign: TextAlign.center,
                                                style: TextStyle(
                                                  fontSize: size.width * 0.04,
                                                  fontWeight: FontWeight.bold,
                                                  color:
                                                      const Color(0xFF03045e),
                                                  fontFamily: 'Poppins',
                                                  letterSpacing: 0.0,
                                                ),
                                              ),
                                            ),
                                            TextFormField(
                                              style: TextStyle(
                                                color: const Color(0xFF03045e),
                                                fontSize: size.width * 0.04,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              controller: txtControlerUsuario,
                                              decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                  color:
                                                      const Color(0xFF03045e),
                                                  fontSize: size.width * 0.04,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                hintText: 'Ingrese el Usuario',
                                                prefixIcon: const Icon(
                                                  Icons.person,
                                                  color: Color(0xFF03045e),
                                                ),
                                              ),
                                              keyboardType: TextInputType.text,
                                              onSaved: (value) {
                                                txtControlerUsuario.text =
                                                    value!;
                                              },
                                            ),
                                            const SizedBox(height: 10),
                                            TextFormField(
                                              controller: txtControlerClave,
                                              keyboardType: TextInputType.text,
                                              style: TextStyle(
                                                color: const Color(0xFF03045e),
                                                fontSize: size.width * 0.04,
                                                fontWeight: FontWeight.bold,
                                              ),
                                              decoration: InputDecoration(
                                                labelStyle: TextStyle(
                                                  color:
                                                      const Color(0xFF03045e),
                                                  fontSize: size.width * 0.04,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                hintText: 'Ingrese Contraseña',
                                                prefixIcon: const Icon(
                                                  Icons.lock,
                                                  color: Color(0xFF03045e),
                                                ),
                                                floatingLabelBehavior:
                                                    FloatingLabelBehavior.never,
                                                isDense: true,
                                                suffixIcon: IconButton(
                                                    icon: Icon(
                                                      color: const Color(
                                                          0xFF03045e),
                                                      ocultaClave
                                                          ? Icons.visibility_off
                                                          : Icons.visibility,
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        ocultaClave =
                                                            !ocultaClave;
                                                      });
                                                    },
                                                    color: Theme.of(context)
                                                        .colorScheme
                                                        .secondary
                                                        .withOpacity(0.4)),
                                              ),
                                              obscureText: ocultaClave,
                                              onSaved: (value) {
                                                txtControlerClave.text = value!;
                                              },
                                            ),
                                            const SizedBox(height: 15),
                                            _checkboxRecuerda(),
                                            Theme(
                                                data: Theme.of(context).copyWith(
                                                    colorScheme: ColorScheme
                                                            .fromSwatch()
                                                        .copyWith(
                                                            secondary:
                                                                const Color(
                                                                    0xFF03045e))),
                                                child: GestureDetector(
                                                  onTap: () {
                                                    _login(
                                                        context,
                                                        txtControlerUsuario
                                                            .text,
                                                        txtControlerClave.text);

                                                    const snackBar = SnackBar(
                                                        content: Center(
                                                          child: Text(
                                                              "Iniciando sesión un momento ..."),
                                                        ),
                                                        duration: Duration(
                                                            milliseconds:
                                                                5000));
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(snackBar);
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsetsDirectional
                                                            .fromSTEB(
                                                            0, 0, 0, 16),
                                                    child: Container(
                                                        width: double.infinity,
                                                        height: 50,
                                                        decoration:
                                                            BoxDecoration(
                                                          gradient:
                                                              const LinearGradient(
                                                            colors: [
                                                              Color(0xFF03045e),
                                                              Color(0xFF0077b6)
                                                            ],
                                                            stops: [0, 1],
                                                            begin:
                                                                AlignmentDirectional(
                                                                    -1, 0),
                                                            end:
                                                                AlignmentDirectional(
                                                                    1, 0),
                                                          ),
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(12),
                                                        ),
                                                        child: Center(
                                                          child: Text(
                                                              'Inicio de sesion',
                                                              style: TextStyle(
                                                                color: const Color(
                                                                    0xFFcaf0f8),
                                                                fontSize:
                                                                    size.width *
                                                                        0.04,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              )),
                                                        )),
                                                  ),
                                                )),
                                            const SizedBox(height: 5),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                AnimatedButton(
                                                    color:
                                                        const Color(0xFF03045e),
                                                    height: size.height * 0.03,
                                                    width: size.width * 0.3,
                                                    duration: 2,
                                                    onPressed: () async {
                                                      /*await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  PersonPage()));*/

                                                      await Navigator.pushNamed(
                                                          context,
                                                          AppRoutes.person);
                                                    },
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 0,
                                                                left: 0,
                                                                right: 0,
                                                                bottom: 0),
                                                        child: Center(
                                                            child: Text(
                                                          "Registrar Promotor",
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xFFcaf0f8),
                                                            fontSize:
                                                                size.width *
                                                                    0.032,
                                                            fontFamily: 'gotic',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        )))),
                                                AnimatedButton(
                                                    color:
                                                        const Color(0xFF03045e),
                                                    height: size.height * 0.03,
                                                    width: size.width * 0.3,
                                                    duration: 2,
                                                    onPressed: () async {
                                                      /*await Navigator.push(
                                                          context,
                                                          MaterialPageRoute(
                                                              builder: (context) =>
                                                                  const SettingPage()));*/
                                                      await Navigator.pushNamed(
                                                          context,
                                                          AppRoutes.setting);
                                                      iniciarPreferencias();
                                                    },
                                                    child: Container(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(
                                                                top: 0,
                                                                left: 0,
                                                                right: 0,
                                                                bottom: 0),
                                                        child: Center(
                                                            child: Text(
                                                          "Configurar ip",
                                                          style: TextStyle(
                                                            color: const Color(
                                                                0xFFcaf0f8),
                                                            fontSize:
                                                                size.width *
                                                                    0.032,
                                                            fontFamily: 'gotic',
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                        ))))
                                              ],
                                            ),
                                            /*const SizedBox(height: 15),
                                            Text(
                                              'IP ${ipController.text}',
                                              style: TextStyle(
                                                color: const Color(0xFF03045e),
                                                fontSize: size.width * 0.032,
                                                fontFamily: 'gotic',
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )*/
                                          ],
                                        ),
                                      ),
                                    ),
                                  )),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  cliente.ModelCliente? datosuser;

  List<Sala>? sala;
  final ioc = HttpClient();
  Future<void> _login(BuildContext context, String usuario, String password) async {
    try {
      ioc.badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
      final http = IOClient(ioc);

      if (pf.getIp.trim().isNotEmpty) {
        pf.setIP = ipController.text;
      } else {
        pf.setIP = basement;
      }

      String ruta = '${pf.getIp.toString()}/api/Login/PromotorLogin/$usuario/$password';
      print('SERVICE => $ruta');

      final uri = Uri.parse(ruta);
      final headers = {'Content-Type': 'application/json'};
      final response = await http.get(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        setState(() {
          final datos2 = json.decode(response.body);
          datosuser = cliente.ModelCliente(
            promotorId: datos2["promotorId"] ?? 0,
            nombres: datos2["nombres"] ?? "",
            apellidos: datos2["apellidos"] ?? "",
            tipoDocumento: datos2["tipoDocumento"] ?? 0,
            doi: datos2["doi"] ?? "",
            telefono: datos2["telefono"] ?? "",
            usuario: datos2["usuario"] ?? "",
            password: datos2["password"] ?? "",
            estado: datos2["estado"] ?? false,
            tipousuario: datos2["tipousuario"] ?? 0,
            comision: datos2["comision"] == null
                ? 0.0
                : double.parse(datos2["comision"].toString()),
          );

          datosuser = datosuser;
        });
        if (datosuser != null &&
            datosuser!.estado == true &&
            datosuser!.usuario.toString() == usuario.toString().toUpperCase() || 
            datosuser!.usuario.toString() == usuario.toString().toLowerCase()) {
          setState(() {
            pf.setUsuario = txtControlerUsuario.text;
            pf.setRecuerda = _isChecked;

            if (_isChecked) {
              pf.setpassword = txtControlerClave.text;
            } else {
              pf.setpassword = "";
            }

            _loading = true;
          });
          
          Navigator.pushNamed(context, AppRoutes.bingo,
              arguments: datosuser);
        } else {
          showAlerta(context, 'Mensaje Informativo',
              'Contraseña Incorrecta Verificar!!');
        }
      } else {
        _loading = false;
        pf.setpassword = "";
        showAlerta(
            context, 'Mensaje Informativo', 'Servidor no Responde, Validar!!');
      }
    } catch (e) {
      _loading = false;
      pf.setpassword = "";
      showAlerta(
          context, 'Mensaje Informativo', 'Servidor no Responde, Validar!!');
    }
  }

  void _showRegister(BuildContext context) {
    Navigator.of(context).pushNamed(
      'registeruser',
    );
  }

  void _showConfguracion(BuildContext context) {
    Navigator.of(context).pushNamed(
      'configuraIP',
    );
  }

  _checkboxRecuerda() {
    var size = MediaQuery.of(context).size;
    _isChecked = pf.getRecuerda;
    return Row(
      children: [
        Checkbox(
          activeColor: const Color(0xFF03045e),
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = !_isChecked;
              pf.setRecuerda = _isChecked;
            });
          },
        ),
        Text(
          style: TextStyle(
            color: const Color(0xFF03045e),
            fontSize: size.width * 0.04,
            fontWeight: FontWeight.bold,
          ),
          'Recordar Clave',
        ),
      ],
    );
  }

  ImageProvider foto() {
    final prefs = Preferencias();
    prefs.initPrefs();
    try {
      if (prefs.getfoto.toString().trim().isNotEmpty) {
        if (prefs.getfoto.contains('assets')) {
          return AssetImage(prefs.getfoto);
        } else {
          return FileImage(File(prefs.getfoto));
        }
      } else {
        return const AssetImage('assets/F1.png');
      }
    } catch (e) {
      return const AssetImage('assets/F1.png');
    }
  }
}

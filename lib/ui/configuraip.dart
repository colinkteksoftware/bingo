import 'dart:ui';

import 'package:bingo/ui/login.dart';
import 'package:extended_masked_text/extended_masked_text.dart';
import 'package:flutter/material.dart';
import 'package:bingo/utiles/preferencias.dart';

class ConfiguraIP extends StatefulWidget {
  static const String routeName = '/configuraIP';

  const ConfiguraIP({Key? key}) : super(key: key);

  @override
  State<ConfiguraIP> createState() => _ConfiguraIPState();
}

bool _isChecked = false;
final pf = Preferencias();

class _ConfiguraIPState extends State<ConfiguraIP> {
  final ipController = TextEditingController(text: pf.getIp);

  var maskFormatter = MaskedTextController(mask: '#.#.#.#', translator: {
    '#': RegExp(r'^([0-9]|[1-9][0-9]|1[0-9]{2}|2[0-4][0-9]|25[0-5])$')
  });

  //final pf = new Preferencias();

  @override
  void dispose() {
    ipController.dispose();
    super.dispose();
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
    var size = MediaQuery.of(context).size;

    return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
            key: scaffoldKey,
            body: Stack(children: [
              Row(mainAxisSize: MainAxisSize.max, children: [
                Expanded(
                    flex: 6,
                    child: Container(
                        width: 100,
                        height: double.infinity,
                        decoration: const BoxDecoration(),
                        alignment: const AlignmentDirectional(0, -1),
                        child: SingleChildScrollView(
                            child: Column(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                            
                              Stack(children: [
                                Container(
                                  decoration: boxDecoration,
                                ),
                                Positioned(
                                  top: -130,
                                  left: -15,
                                  child: Column(
                                    children: [
                                      box(),
                                    ],
                                  ),
                                ),
                                Positioned(
                                  top: 340,
                                  left: 105,
                                  child: Column(
                                    children: [
                                      box2(),
                                    ],
                                  ),
                                ),
                                Align(
                                    alignment: const AlignmentDirectional(0, 0),
                                    child: Container(
                                        height: size.height,
                                        width: double.infinity,
                                        constraints: const BoxConstraints(
                                          maxWidth: 570
                                        ),
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(12),
                                        ),
                                        child: Align(
                                            alignment:
                                                const AlignmentDirectional(0, 0),
                                            child: Padding(
                                                padding: const EdgeInsets.all(32),
                                                child: Column(
                                                    mainAxisSize:
                                                        MainAxisSize.max,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .center,
                                                    children: [
                                                                          Padding(
                            padding:
                                const EdgeInsetsDirectional.fromSTEB(0, 20, 0, 0),
                            child: Container(
                           
                              height: size.height *0.2,
                              decoration: const BoxDecoration(
                                  
                                   image: DecorationImage(
                                    
                  image: AssetImage("assets/images/logo.png"),
                  fit: BoxFit.fill),
                        
                              ),
                              alignment: const AlignmentDirectional(0, 0),
                              
                            ),
                            
                          ),
                                                      Text('Bienvenido',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.08,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xFF03045e),
                                                            fontFamily:
                                                                'Poppins',
                                                            letterSpacing: 0.0,
                                                          )),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsetsDirectional
                                                                .fromSTEB(0, 12,
                                                                    0, 24),
                                                        child: Text(
                                                          'Registra los datos de la ip y el puerto ejemplo https://192.168.0.90:8080',
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                size.width *
                                                                    0.04,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: const Color(
                                                                0xFF03045e),
                                                            fontFamily:
                                                                'Poppins',
                                                            letterSpacing: 0.0,
                                                          ),
                                                        ),
                                                      ),
                                                      TextFormField(
                                                        controller:
                                                            ipController,
                                                        style: TextStyle(
                                                          color:
                                                              const Color(0xFF03045e),
                                                          fontSize:
                                                              size.width * 0.04,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                        ),
                                                        decoration:
                                                            InputDecoration(
                                                          labelStyle: TextStyle(
                                                            color: const Color(
                                                                0xFF03045e),
                                                            fontSize:
                                                                size.width *
                                                                    0.04,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                          ),
                                                          labelText:
                                                              "Ip Servidor y puerto",
                                                          hintText:
                                                              'http://000.000.000.000:0000',
                                                        ),
                                                        onSaved: (value) {
                                                          ipController.text =
                                                              value!;
                                                        },
                                                        validator: (value) {
                                                          if (value!.isEmpty) {
                                                            return 'ip';
                                                          }
                                                          return null;
                                                        },
                                                      ),
                                                      const SizedBox(height: 30),
                                                      // _checkboxRecuerda(),
                                                      const SizedBox(height: 30),
                                                      Theme(
                                                          data: Theme.of(context).copyWith(
                                                              colorScheme: ColorScheme
                                                                      .fromSwatch()
                                                                  .copyWith(
                                                                      secondary:
                                                                          Colors
                                                                              .white)),
                                                          child: ElevatedButton(
                                                            style:
                                                                ElevatedButton
                                                                    .styleFrom(
                                                              foregroundColor:
                                                                  const Color(
                                                                      0xFFcaf0f8),
                                                              backgroundColor:
                                                                  const Color(
                                                                      0xFF03045e), //change text color of button
                                                              shape:
                                                                  RoundedRectangleBorder(
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            15),
                                                              ),
                                                              elevation: 15.0,
                                                            ),
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .all(
                                                                      15.0),
                                                              child: Text(
                                                                'Grabar cambios',
                                                                style:
                                                                    TextStyle(
                                                                  color: const Color(
                                                                      0xFFcaf0f8),
                                                                  fontSize:
                                                                      size.width *
                                                                          0.032,
                                                                  fontFamily:
                                                                      'gotic',
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold,
                                                                ),
                                                              ),
                                                            ),
                                                            onPressed: () {
                                                              setState(() {
                                                                pf.setIP =
                                                                    ipController
                                                                        .text;
                                                              });

                                                              _login(context);
                                                            },
                                                          )),
                                                    ])))))
                              ])
                            ]))))
              ])
            ])));
  }

  void _login(BuildContext context) {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const Login()));
  }

  _checkboxRecuerda() {
    _isChecked = pf.getServerNube;
    return Row(
      children: [
        Checkbox(
          value: _isChecked,
          onChanged: (value) {
            setState(() {
              _isChecked = !_isChecked;
              pf.setServerNube = _isChecked;
            });
          },
        ),
        const Text('Validar con Servidor de la nube'),
      ],
    );
  }
}

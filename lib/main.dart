import 'package:bingo/ui/login.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

// flutter local notification setup

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp, // Mantener la orientación en modo retrato
  ]); 
  runApp(
    Builder(builder: (context) {
      final mediaQueryData = MediaQuery.of(context);
      final mediaQueryDataWithLinearTextScaling = mediaQueryData.copyWith(
          textScaler:
              TextScaler.linear(mediaQueryData.textScaler.textScaleFactor));
      return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
          child: MyApp());
    }),
  );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  /*  final GlobalKey<NavigatorState> navigatorKey =
      new GlobalKey<NavigatorState>();
  final GlobalKey<ScaffoldMessengerState> messengerKey =
      new GlobalKey<ScaffoldMessengerState>(); */
  final GlobalKey estado = GlobalKey();
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sistema Bingo',
      home: Login(),

      routes: {
        'login': (context) => Login(),
      },
    );
  }
}

Widget inicio(BuildContext context) {
  return Login();
}

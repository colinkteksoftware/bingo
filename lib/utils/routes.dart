import 'package:bingo/ui/bingo/bingo_page.dart';
import 'package:bingo/ui/home/home_page.dart';
import 'package:bingo/ui/login_page.dart';
import 'package:bingo/ui/setting_page.dart';
import 'package:bingo/ui/splash_screen.dart';
import 'package:bingo/ui/user/person_page.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static const String splash = '/splash';
  static const String login = '/login';
  static const String home = '/home';
  static const String bingo = '/bingo';
  static const String person = '/person';
  static const String setting = '/setting';

  static Route<dynamic> generateRoute(RouteSettings route) {
    switch (route.name) {
      case splash: 
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginPage());
      case home:
        return MaterialPageRoute(
            builder: (_) => const HomePage(),
          );
        /*final args = route.arguments as Map<String, dynamic>?;        
        if (args != null) {
          final bingo = args['bingo'] as Bingo?;
          final datosuser = args['datosuser'] as ModelPromotor?;

          return MaterialPageRoute(
            builder: (_) => HomePage(
              bingo: bingo,
              //datosuser: datosuser,
            ),
          );
        } else {
          return _errorRoute();
        }*/
      case bingo:
        return MaterialPageRoute(
              builder: (_) => const BingoPage());
        /*final datosuser = route.arguments as ModelPromotor?;
        if (datosuser != null) {
          return MaterialPageRoute(
              builder: (_) => const BingoPage());
        }else {
          return _errorRoute();
        }*/
      case person:
        return MaterialPageRoute(builder: (_) => const PersonPage());
      case setting:
        return MaterialPageRoute(builder: (_) => const SettingPage());
      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(
          title: const Text('Ruta no encontrada'),
        ),
        body: const Center(
          child: Text('La ruta solicitada no existe.'),
        ),
      ),
    );
  }
}

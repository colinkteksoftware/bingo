import 'package:bingo/app.dart';
import 'package:bingo/providers/home_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => HomeProvider()),
      ],
      child: Builder(builder: (context) {
        final mediaQueryData = MediaQuery.of(context);
        mediaQueryData.copyWith(
            textScaler:
                TextScaler.linear(mediaQueryData.textScaler.textScaleFactor));
        return MediaQuery(
            data: MediaQuery.of(context).copyWith(textScaleFactor: 0.9),
            child: const App());
      }),
    ),
  );
}

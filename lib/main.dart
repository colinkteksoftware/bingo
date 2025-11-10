import 'package:bingo/app.dart';
import 'package:bingo/core/data/datasource/datasource.dart';
import 'package:bingo/core/data/repositories/repository_impl.dart';
import 'package:bingo/core/domain/api/api_services.dart';
import 'package:bingo/core/domain/usecases/usecase.dart';
import 'package:bingo/providers/auth_provider.dart';
import 'package:bingo/providers/bingo_provider.dart';
import 'package:bingo/providers/payment_provider.dart';
import 'package:bingo/providers/sale_provider.dart';
import 'package:bingo/utils/preferencias.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() async {
  final apiService = ApiService();
  final dataSource = DataSource(apiService);
  final repository = RepositoryImpl(dataSource);
  final useCase = UseCase(repository);

  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  final pf = Preferencias();
  await pf.initPrefs();

  FlutterError.onError = (FlutterErrorDetails details) {
    FlutterError.presentError(details);
    // Puedes usar Firebase Crashlytics aquí si quieres logs más completos    
    print('Flutter error: ${details.exception}');
  };

  runApp(
    MultiProvider(
      providers: [
        Provider<UseCase>(create: (_) => UseCase(repository)),
        ChangeNotifierProvider(create: (_) => AuthProvider(useCase)),
        ChangeNotifierProvider(create: (_) => SaleProvider()),
        ChangeNotifierProvider(create: (_) => PaymentProvider()),
        ChangeNotifierProvider(create: (_) => BingoProvider()),
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

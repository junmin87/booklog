import 'dart:isolate';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'app/di.dart';
import 'app/shell_page.dart';
import 'feature/auth/data/auth_repository.dart';
import 'feature/auth/presentation/pages/country_select.dart';
import 'feature/auth/presentation/pages/login_page.dart';
import 'feature/auth/presentation/provider/auth_provider.dart';
import 'feature/book/data/book_repository.dart';
import 'feature/book/presentation/provider/book_provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();
  await Firebase.initializeApp();
  await FirebaseAnalytics.instance;

  if (!kDebugMode) {
    FlutterError.onError =
        FirebaseCrashlytics.instance.recordFlutterFatalError;

    PlatformDispatcher.instance.onError = (error, stack) {
      FirebaseCrashlytics.instance.recordError(error, stack, fatal: true);
      return true;
    };

    Isolate.current.addErrorListener(RawReceivePort((pair) async {
      final list = pair as List<dynamic>;
      await FirebaseCrashlytics.instance.recordError(
        list.first,
        list.last,
        fatal: true,
      );
    }).sendPort);
  } else {
    await FirebaseCrashlytics.instance.setCrashlyticsCollectionEnabled(false);
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => AuthProvider(AuthRepository()),
        ),
        ChangeNotifierProvider(
          create: (_) => BookProvider(BookRepository()),
        ),
      ],
      child: MaterialApp(
        title: 'Book Log',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // 🔥 핵심: home 제거하고 initialRoute 사용
        initialRoute: '/',

        // routes: {
        //   '/': (_) => const LoginPage(),
        //   '/main': (_) => const ShellPage(),
        // },
        routes: {
          '/': (_) => const LoginPage(),
          '/country-select': (_) => const CountrySelectPage(),
          '/main': (_) => const ShellPage(),
        },
      ),
    );
  }
}

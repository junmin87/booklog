import 'dart:isolate';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'app/di.dart';
import 'feature/auth/data/auth_repository.dart';
import 'feature/auth/presentation/pages/country_select.dart';
import 'feature/auth/presentation/pages/login_page.dart';
import 'feature/auth/presentation/provider/auth_provider.dart';
import 'feature/book/data/book_repository.dart';
import 'feature/book/presentation/pages/add_book_page.dart';
import 'feature/book/presentation/pages/books_page.dart';
import 'feature/book/presentation/provider/book_provider.dart';
import 'feature/setting/presentation/pages/setting_page.dart';

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

/// ✅ BottomNavigationBar를 "항상 유지"하는 껍데기(Shell)
/// - 탭 전환은 Shell 내부에서만 처리
/// - 디테일 페이지는 Root Navigator로 push해서 BottomBar 없이 전체 화면으로 보여줌
class ShellPage extends StatefulWidget {
  const ShellPage({super.key});

  @override
  State<ShellPage> createState() => _ShellPageState();
}

class _ShellPageState extends State<ShellPage> {
  int _index = 0;

  // 탭별 네비게이터 키(각 탭의 stack/state 유지)
  final _tabNavKeys = List.generate(4, (_) => GlobalKey<NavigatorState>());

  // 루트 네비게이터로 "디테일"을 올리기 위한 키
  final _rootNavKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: _rootNavKey,
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: (_) => Scaffold(
          body: IndexedStack(
            index: _index,
            children: [
              _TabNavigator(
                navigatorKey: _tabNavKeys[0],
                tabName: 'Home',
                onOpenDetail: () => _openDetail('Home Detail'),
              ),
              _TabNavigator(
                navigatorKey: _tabNavKeys[1],
                tabName: 'Books',
                onOpenDetail: () => _openDetail('Books Detail'),
                rootBuilder: (_) => BooksPage(
                  onOpenAddBook: () => _rootNavKey.currentState?.push(
                    MaterialPageRoute(builder: (_) => const AddBookPage()),
                  ),
                ),
              ),
              _TabNavigator(
                navigatorKey: _tabNavKeys[2],
                tabName: 'Stats',
                onOpenDetail: () => _openDetail('Stats Detail'),
              ),
              _TabNavigator(
                navigatorKey: _tabNavKeys[3],
                tabName: 'Settings',
                onOpenDetail: () => _openDetail('Settings Detail'),
                rootBuilder: (_) => const SettingPage(),
              ),
            ],
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.white,   // ✅ 바텀바 배경 확실히
            elevation: 12,                   // ✅ 그림자(구분선 역할)
            selectedItemColor: Colors.black, // ✅ 선택된 아이콘/텍스트
            unselectedItemColor: Colors.grey, // ✅ 미선택
            showUnselectedLabels: true,
            currentIndex: _index,
            onTap: (i) => setState(() => _index = i),
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book), label: 'Books'),
              BottomNavigationBarItem(icon: Icon(Icons.bar_chart), label: 'Stats'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Settings'),
            ],
          ),

        ),
      ),
    );
  }

  void _openDetail(String title) {
    // ✅ 루트 네비게이터로 push => BottomNavigationBar "없이" 디테일 표시
    _rootNavKey.currentState?.push(
      MaterialPageRoute(builder: (_) => DetailPage(title: title)),
    );
  }
}

/// 탭마다 독립된 Navigator (탭 이동 시 상태/스크롤/스택 유지)
class _TabNavigator extends StatelessWidget {
  const _TabNavigator({
    required this.navigatorKey,
    required this.tabName,
    required this.onOpenDetail,
    this.rootBuilder,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final String tabName;
  final VoidCallback onOpenDetail;
  final WidgetBuilder? rootBuilder;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (_) => MaterialPageRoute(
        builder: rootBuilder ??
            (_) => TabRootPage(
                  title: tabName,
                  onOpenDetail: onOpenDetail,
                ),
      ),
    );
  }
}

class TabRootPage extends StatelessWidget {
  const TabRootPage({super.key, required this.title, required this.onOpenDetail});

  final String title;
  final VoidCallback onOpenDetail;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('$title Tab')),
      body: Center(
        child: ElevatedButton(
          onPressed: onOpenDetail,
          child: const Text('Open Detail (no bottom bar)'),
        ),
      ),
    );
  }
}

class DetailPage extends StatelessWidget {
  const DetailPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: const Center(child: Text('Detail page (bottom bar hidden)')),
    );
  }
}

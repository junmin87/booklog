import 'package:flutter/material.dart';

import 'app_colors.dart';
import '../feature/book/presentation/pages/books_page.dart';
import '../feature/setting/presentation/pages/setting_page.dart';

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
  final _tabNavKeys = List.generate(2, (_) => GlobalKey<NavigatorState>());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _index,
        children: [
          _TabNavigator(
            navigatorKey: _tabNavKeys[0],
            rootBuilder: (_) => const BooksPage(),
          ),
          _TabNavigator(
            navigatorKey: _tabNavKeys[1],
            rootBuilder: (_) => const SettingPage(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: AppColors.darkCard,
        elevation: 0,
        selectedItemColor: AppColors.accent,
        unselectedItemColor: AppColors.onDarkMuted,
        showUnselectedLabels: true,
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.menu_book), label: 'Books'),
          BottomNavigationBarItem(
              icon: Icon(Icons.settings), label: 'Settings'),
        ],
      ),
    );
  }

}

/// 탭마다 독립된 Navigator (탭 이동 시 상태/스크롤/스택 유지)
class _TabNavigator extends StatelessWidget {
  const _TabNavigator({
    required this.navigatorKey,
    required this.rootBuilder,
  });

  final GlobalKey<NavigatorState> navigatorKey;
  final WidgetBuilder rootBuilder;

  @override
  Widget build(BuildContext context) {
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (_) => MaterialPageRoute(builder: rootBuilder),
    );
  }
}


import 'package:flutter/material.dart';
import '../feature/auth/presentation/pages/country_select.dart';
import '../feature/auth/presentation/pages/login_page.dart';


Map<String, WidgetBuilder> get appRoutes => {
  '/login': (context) => const LoginPage(),
  '/country-select': (context) => const CountrySelectPage(),
};

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../provider/auth_provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool _hasNavigated = false;

  @override
  void initState() {
    super.initState();
    // 위젯 빌드 완료 후 자동 로그인 시도
    // WidgetsBinding.instance.addPostFrameCallback((_) => _tryAutoLogin());
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AuthProvider>().tryAutoLogin();
    });
  }

  Future<void> _tryAutoLogin() async {
    await context.read<AuthProvider>().tryAutoLogin();
  }

  // void _navigateToMain() {
  //   if (_hasNavigated) return;
  //   _hasNavigated = true;
  //   Navigator.of(context).pushReplacementNamed('/main');
  // }


  void _navigateToMain() {
    if (_hasNavigated) return;
    _hasNavigated = true;

    final auth = context.read<AuthProvider>();
    if (auth.isCountrySelected) {
      Navigator.of(context).pushReplacementNamed('/main');
    } else {
      Navigator.of(context).pushReplacementNamed('/country-select');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, auth, _) {
        // 로그인 완료 시 메인으로 이동 (한 번만)
        if (auth.isLoggedIn) {
          WidgetsBinding.instance.addPostFrameCallback((_) => _navigateToMain());
        }

        return Scaffold(
          backgroundColor: Colors.white,
          body: SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 40),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'Book Log',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Track your reading journey',
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 72),
                    if (auth.isLoading)
                      const CircularProgressIndicator()
                    else
                      SignInWithAppleButton(
                        onPressed: () => auth.signInWithApple(),
                      ),
                    if (auth.error != null) ...[
                      const SizedBox(height: 20),
                      Text(
                        auth.error!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

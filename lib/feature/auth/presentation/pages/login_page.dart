import 'package:flutter/material.dart';
import 'package:book_log/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../provider/auth_provider.dart';

// Migration: ConsumerWidget replaces StatefulWidget; ref replaces initState + ChangeNotifier boilerplate
class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAuth = ref.watch(authNotifierProvider);
    final auth = asyncAuth.valueOrNull;
    final isLoading = asyncAuth.isLoading;

    // Migration: ref.listen replaces Consumer + WidgetsBinding.addPostFrameCallback for navigation side effects
    ref.listen<AsyncValue<AuthNotifierState>>(authNotifierProvider, (_, next) {
      final nextAuth = next.valueOrNull;
      if (nextAuth?.isLoggedIn != true) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        // 로그인 완료 시 메인으로 이동
        if (nextAuth!.isCountrySelected) {
          Navigator.of(context).pushReplacementNamed('/main');
        } else {
          Navigator.of(context).pushReplacementNamed('/country-select');
        }
      });
    });

    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  l10n.appTitle,
                  style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 12),
                Text(
                  l10n.loginSubtitle,
                  style: const TextStyle(fontSize: 16, color: Colors.grey),
                ),
                const SizedBox(height: 72),
                if (isLoading)
                  const CircularProgressIndicator()
                else
                  SignInWithAppleButton(
                    // Migration: ref.read(provider.notifier).method() replaces context.read<T>().method()
                    onPressed: () =>
                        ref.read(authNotifierProvider.notifier).signInWithApple(),
                  ),
                if (auth?.error != null) ...[
                  const SizedBox(height: 20),
                  Text(
                    auth!.error!,
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
  }
}

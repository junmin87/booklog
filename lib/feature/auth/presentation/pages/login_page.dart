import 'dart:io';

import 'package:flutter/material.dart';
import 'package:book_log/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../provider/auth_provider.dart';

class LoginPage extends ConsumerWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final asyncAuth = ref.watch(authNotifierProvider);
    final auth = asyncAuth.valueOrNull;
    final isLoading = asyncAuth.isLoading;

    ref.listen<AsyncValue<AuthNotifierState>>(authNotifierProvider, (_, next) {
      final nextAuth = next.valueOrNull;
      if (nextAuth?.isLoggedIn != true) return;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!context.mounted) return;
        if (nextAuth!.isCountrySelected) {
          Navigator.of(context).pushReplacementNamed('/main');
        } else {
          Navigator.of(context).pushReplacementNamed('/country-select');
        }
      });
    });

    final l10n = AppLocalizations.of(context)!;
    // iOS: Book Log, Android: 북새김
    // Platform-specific app name
    final appName = '북새김';

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
                  appName,
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
                else if (Platform.isIOS)
                  SignInWithAppleButton(
                    onPressed: () =>
                        ref.read(authNotifierProvider.notifier).signInWithApple(),
                  )
                else
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: () =>
                          ref.read(authNotifierProvider.notifier).signInWithKakao(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFFFEE500),
                        foregroundColor: const Color(0xFF191919),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.chat_bubble, size: 20),
                          SizedBox(width: 8),
                          Text(
                            '카카오 로그인',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                    ),
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




// import 'package:flutter/material.dart';
// import 'package:book_log/l10n/app_localizations.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:sign_in_with_apple/sign_in_with_apple.dart';
//
// import '../provider/auth_provider.dart';
//
// // Migration: ConsumerWidget replaces StatefulWidget; ref replaces initState + ChangeNotifier boilerplate
// class LoginPage extends ConsumerWidget {
//   const LoginPage({super.key});
//
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final asyncAuth = ref.watch(authNotifierProvider);
//     final auth = asyncAuth.valueOrNull;
//     final isLoading = asyncAuth.isLoading;
//
//     // Migration: ref.listen replaces Consumer + WidgetsBinding.addPostFrameCallback for navigation side effects
//     ref.listen<AsyncValue<AuthNotifierState>>(authNotifierProvider, (_, next) {
//       final nextAuth = next.valueOrNull;
//       if (nextAuth?.isLoggedIn != true) return;
//       WidgetsBinding.instance.addPostFrameCallback((_) {
//         if (!context.mounted) return;
//         // 로그인 완료 시 메인으로 이동
//         if (nextAuth!.isCountrySelected) {
//           Navigator.of(context).pushReplacementNamed('/main');
//         } else {
//           Navigator.of(context).pushReplacementNamed('/country-select');
//         }
//       });
//     });
//
//     final l10n = AppLocalizations.of(context)!;
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: SafeArea(
//         child: Center(
//           child: Padding(
//             padding: const EdgeInsets.symmetric(horizontal: 40),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 Text(
//                   l10n.appTitle,
//                   style: const TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
//                 ),
//                 const SizedBox(height: 12),
//                 Text(
//                   l10n.loginSubtitle,
//                   style: const TextStyle(fontSize: 16, color: Colors.grey),
//                 ),
//                 const SizedBox(height: 72),
//                 if (isLoading)
//                   const CircularProgressIndicator()
//                 else
//                   SignInWithAppleButton(
//                     // Migration: ref.read(provider.notifier).method() replaces context.read<T>().method()
//                     onPressed: () =>
//                         ref.read(authNotifierProvider.notifier).signInWithApple(),
//                   ),
//                 if (auth?.error != null) ...[
//                   const SizedBox(height: 20),
//                   Text(
//                     auth!.error!,
//                     style: const TextStyle(color: Colors.red, fontSize: 13),
//                     textAlign: TextAlign.center,
//                   ),
//                 ],
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }





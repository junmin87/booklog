import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/provider/auth_provider.dart';

// Migration: ConsumerWidget replaces StatelessWidget to access ref for Riverpod providers
class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // Migration: ref.read(provider.notifier).method() replaces context.read<T>().method()
            await ref.read(authNotifierProvider.notifier).logout();
            if (context.mounted) {
              Navigator.of(context, rootNavigator: true)
                  .pushReplacementNamed('/');
            }
          },
          child: const Text('Logout'),
        ),
      ),
    );
  }
}

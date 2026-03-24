import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../auth/presentation/provider/auth_provider.dart';

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await context.read<AuthProvider>().logout();
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

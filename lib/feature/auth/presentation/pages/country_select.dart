import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/auth_provider.dart';

class CountrySelectPage extends StatelessWidget {
  const CountrySelectPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Select your region',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              _CountryButton(
                flag: '🇰🇷',
                label: '한국',
                onTap: () => _onSelect(context, 'KR', 'ko'),
              ),
              const SizedBox(height: 16),
              _CountryButton(
                flag: '🌍',
                label: 'Other',
                onTap: () => _onSelect(context, 'US', 'en'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSelect(BuildContext context, String countryCode, String languageCode) async {
    await context.read<AuthProvider>().saveCountry(countryCode, languageCode);
    if (context.mounted) {
      Navigator.of(context).pushReplacementNamed('/main');
    }
  }
}

class _CountryButton extends StatelessWidget {
  final String flag;
  final String label;
  final VoidCallback onTap;

  const _CountryButton({
    required this.flag,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: OutlinedButton(
        onPressed: onTap,
        child: Text('$flag  $label', style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
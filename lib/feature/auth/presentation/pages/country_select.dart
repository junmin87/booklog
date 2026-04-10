import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:book_log/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/auth_provider.dart';

// Migration: ConsumerWidget replaces StatelessWidget to access ref for Riverpod providers
class CountrySelectPage extends ConsumerWidget {
  const CountrySelectPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                l10n.selectRegion,
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              _CountryButton(
                flag: '🇰🇷',
                label: l10n.countryKorea,
                onTap: () => _onSelect(context, ref, 'KR'),
              ),
              const SizedBox(height: 16),
              _CountryButton(
                flag: '🌍',
                label: l10n.countryOther,
                onTap: () => _onSelect(context, ref, 'US'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onSelect(BuildContext context, WidgetRef ref, String countryCode) async {
    final deviceLang = ui.PlatformDispatcher.instance.locale.languageCode;
    final languageCode = deviceLang == 'ko' ? 'ko' : 'en';
    // Migration: ref.read replaces context.read
    await ref.read(authNotifierProvider.notifier).saveCountry(countryCode, languageCode);
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

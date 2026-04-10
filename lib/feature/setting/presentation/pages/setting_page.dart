import 'package:flutter/material.dart';
import 'package:book_log/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';
import '../../../auth/presentation/provider/auth_provider.dart';

class SettingPage extends ConsumerWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authAsync = ref.watch(authNotifierProvider);

    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        centerTitle: false,
        title: Text(AppLocalizations.of(context)!.settings, style: AppTextStyles.playfairPageTitle),
      ),
      body: authAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (state) {
          final user = state.user;
          final l10n = AppLocalizations.of(context)!;
          return ListView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
            children: [
              // User info card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.onDarkHint.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.account, style: AppTextStyles.notoLabel.copyWith(color: AppColors.onDarkMuted)),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: l10n.emailLabel,
                      value: user?.email ?? '—',
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.public_outlined,
                      label: l10n.countryLabel,
                      value: state.countryCode ?? '—',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Language selector card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.onDarkHint.withValues(alpha: 0.3)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(l10n.languageLabel, style: AppTextStyles.notoLabel.copyWith(color: AppColors.onDarkMuted)),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Icon(Icons.language_outlined, size: 18, color: AppColors.onDarkMuted),
                        const SizedBox(width: 10),
                        Text(l10n.languageLabel, style: AppTextStyles.notoBodySecondary.copyWith(color: AppColors.onDarkMuted)),
                        const Spacer(),
                        _LanguageToggle(
                          currentLanguageCode: state.languageCode,
                          onChanged: (lang) async {
                            await ref.read(authNotifierProvider.notifier).saveCountry(
                              state.countryCode ?? 'US',
                              lang,
                            );
                          },
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              // Share app card
              Container(
                decoration: BoxDecoration(
                  color: AppColors.darkCard,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.onDarkHint.withValues(alpha: 0.3)),
                ),
                child: ListTile(
                  leading: Icon(Icons.share_outlined, size: 18, color: AppColors.onDarkMuted),
                  title: Text(
                    'Share App',
                    style: AppTextStyles.notoBodySecondary.copyWith(color: AppColors.onDark),
                  ),
                  trailing: Icon(Icons.chevron_right, size: 18, color: AppColors.onDarkHint),
                  onTap: () {
                    final box = context.findRenderObject() as RenderBox?;
                    Share.share(
                      'Check out Book Log! https://booklog.app (coming soon)',
                      sharePositionOrigin: box != null
                          ? box.localToGlobal(Offset.zero) & box.size
                          : null,
                    );
                  },
                ),
              ),
              const SizedBox(height: 32),
              // Logout button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: () async {
                    await ref.read(authNotifierProvider.notifier).logout();
                    if (context.mounted) {
                      Navigator.of(context, rootNavigator: true)
                          .pushReplacementNamed('/');
                    }
                  },
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.errorRedSoft,
                    side: const BorderSide(color: AppColors.errorRedSoft),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(l10n.logout, style: AppTextStyles.notoButtonLabel.copyWith(color: AppColors.errorRedSoft)),
                ),
              ),
              const SizedBox(height: 12),
              // Account deletion button
              SizedBox(
                width: double.infinity,
                child: TextButton(
                  onPressed: () async {
                    final confirmed = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        backgroundColor: AppColors.darkCard,
                        title: Text(l10n.deleteAccount, style: AppTextStyles.notoBodyMedium.copyWith(color: AppColors.onDark)),
                        content: Text(
                          l10n.deleteAccountConfirm,
                          style: AppTextStyles.notoBodySecondary.copyWith(color: AppColors.onDarkMuted),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text(l10n.cancel, style: AppTextStyles.notoButtonLabel.copyWith(color: AppColors.onDarkMuted)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: Text(l10n.withdraw, style: AppTextStyles.notoButtonLabel.copyWith(color: AppColors.errorRedSoft)),
                          ),
                        ],
                      ),
                    );
                    if (confirmed == true && context.mounted) {
                      await ref.read(authNotifierProvider.notifier).deleteAppleAccount();
                      if (context.mounted) {
                        Navigator.of(context, rootNavigator: true)
                            .pushNamedAndRemoveUntil('/', (_) => false);
                      }
                    }
                  },
                  child: Text(l10n.withdraw, style: AppTextStyles.notoBodySecondary.copyWith(color: AppColors.onDarkHint)),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _LanguageToggle extends StatelessWidget {
  const _LanguageToggle({required this.currentLanguageCode, required this.onChanged});

  final String? currentLanguageCode;
  final void Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _LangButton(
          label: l10n.languageKorean,
          selected: currentLanguageCode == 'ko',
          onTap: () => onChanged('ko'),
        ),
        const SizedBox(width: 8),
        _LangButton(
          label: l10n.languageEnglish,
          selected: currentLanguageCode == 'en' || currentLanguageCode == null,
          onTap: () => onChanged('en'),
        ),
      ],
    );
  }
}

class _LangButton extends StatelessWidget {
  const _LangButton({required this.label, required this.selected, required this.onTap});

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.onDarkHint.withValues(alpha: 0.4),
          ),
        ),
        child: Text(
          label,
          style: AppTextStyles.notoBodySecondary.copyWith(
            color: selected ? Colors.white : AppColors.onDarkMuted,
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.icon, required this.label, required this.value});

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.onDarkMuted),
        const SizedBox(width: 10),
        Text(label, style: AppTextStyles.notoBodySecondary.copyWith(color: AppColors.onDarkMuted)),
        const Spacer(),
        Text(value, style: AppTextStyles.notoBodyMedium.copyWith(color: AppColors.onDark)),
      ],
    );
  }
}

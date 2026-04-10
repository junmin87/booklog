import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
        title: Text('Settings', style: AppTextStyles.playfairPageTitle),
      ),
      body: authAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator(color: AppColors.accent)),
        error: (e, _) => Center(child: Text(e.toString())),
        data: (state) {
          final user = state.user;
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
                    Text('Account', style: AppTextStyles.notoLabel.copyWith(color: AppColors.onDarkMuted)),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.email_outlined,
                      label: 'Email',
                      value: user?.email ?? '—',
                    ),
                    const SizedBox(height: 12),
                    _InfoRow(
                      icon: Icons.public_outlined,
                      label: 'Country',
                      value: state.countryCode ?? '—',
                    ),
                  ],
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
                  child: Text('Logout', style: AppTextStyles.notoButtonLabel.copyWith(color: AppColors.errorRedSoft)),
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
                        title: Text('계정 삭제', style: AppTextStyles.notoBodyMedium.copyWith(color: AppColors.onDark)),
                        content: Text(
                          '정말로 탈퇴하시겠습니까?\n계정과 관련된 모든 데이터가 삭제됩니다.',
                          style: AppTextStyles.notoBodySecondary.copyWith(color: AppColors.onDarkMuted),
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(false),
                            child: Text('취소', style: AppTextStyles.notoButtonLabel.copyWith(color: AppColors.onDarkMuted)),
                          ),
                          TextButton(
                            onPressed: () => Navigator.of(ctx).pop(true),
                            child: Text('탈퇴하기', style: AppTextStyles.notoButtonLabel.copyWith(color: AppColors.errorRedSoft)),
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
                  child: Text('탈퇴하기', style: AppTextStyles.notoBodySecondary.copyWith(color: AppColors.onDarkHint)),
                ),
              ),
            ],
          );
        },
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

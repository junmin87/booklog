import 'package:flutter/material.dart';
import 'package:book_log/l10n/app_localizations.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';

class EmptySentenceView extends StatelessWidget {
  const EmptySentenceView({super.key, required this.onAdd});

  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 120),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.darkCard,
          borderRadius: BorderRadius.circular(22),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.auto_stories_rounded,
                  size: 44,
                  color: AppColors.accent,
                ),
                const SizedBox(height: 16),
                Text(
                  AppLocalizations.of(context)!.noSentencesYet,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.notoEmptyTitle,
                ),
                const SizedBox(height: 10),
                Text(
                  AppLocalizations.of(context)!.noSentencesSubtitle,
                  textAlign: TextAlign.center,
                  style: AppTextStyles.notoEmptySubtitle,
                ),
                const SizedBox(height: 18),
                OutlinedButton.icon(
                  onPressed: onAdd,
                  style: OutlinedButton.styleFrom(
                    foregroundColor: AppColors.accent,
                    side: BorderSide(
                      color: AppColors.accent.withValues(alpha: 0.35),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 12,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(999),
                    ),
                  ),
                  icon: const Icon(Icons.add, size: 18),
                  label: Text(
                    AppLocalizations.of(context)!.saveFirstSentence,
                    style: AppTextStyles.notoButtonLabel,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

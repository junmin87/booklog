import 'package:flutter/material.dart';

import '../../../../app/app_text_styles.dart';
import '../../../../core/utils/responsive.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: AppTextStyles.playfairSectionTitle.copyWith(fontSize: Responsive.sp(22))),
          const SizedBox(height: 6),
          Text(subtitle, style: AppTextStyles.notoCaption),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';
import '../../../../core/utils/responsive.dart';

class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.coverUrl});

  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    final width = Responsive.byDevice<double>(
      compact: 80,
      regular: 92,
      large: 100,
      tablet: 120,
    );
    final height = Responsive.byDevice<double>(
      compact: 115,
      regular: 132,
      large: 144,
      tablet: 172,
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: width,
        height: height,
        child: coverUrl != null
            ? Image.network(
                coverUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const CoverFallback(),
              )
            : const CoverFallback(),
      ),
    );
  }
}

class CoverFallback extends StatelessWidget {
  const CoverFallback({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AppColors.ink,
      child: const Center(
        child: Icon(
          Icons.menu_book_rounded,
          color: AppColors.muted,
          size: 34,
        ),
      ),
    );
  }
}

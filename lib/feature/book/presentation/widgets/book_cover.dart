import 'package:flutter/material.dart';

import '../../../../app/app_colors.dart';

class BookCover extends StatelessWidget {
  const BookCover({super.key, required this.coverUrl});

  final String? coverUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: 92,
        height: 132,
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

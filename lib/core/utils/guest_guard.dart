import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../feature/auth/presentation/provider/auth_provider.dart';

/// Returns true if the current user is a guest and shows a login-required dialog.
/// Returns false if the user is not a guest (action may proceed).
bool guardGuest(BuildContext context, WidgetRef ref) {
  if (!Platform.isAndroid) return false;

  final authState = ref.read(authNotifierProvider).valueOrNull;
  if (authState == null || !authState.isGuest) return false;

  showDialog(
    context: context,
    builder: (ctx) => AlertDialog(
      title: const Text('로그인 필요'),
      content: const Text('이 기능을 사용하려면 로그인이 필요합니다.'),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(),
          child: const Text('취소'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(ctx).pop();
            Navigator.of(context, rootNavigator: true)
                .pushNamedAndRemoveUntil('/', (_) => false);
          },
          child: const Text('로그인'),
        ),
      ],
    ),
  );
  return true;
}

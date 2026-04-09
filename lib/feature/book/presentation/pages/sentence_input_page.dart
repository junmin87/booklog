import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';
import '../../domain/entity/book.dart';
import '../provider/sentence_notifier.dart';

class SentenceInputPage extends ConsumerStatefulWidget {
  const SentenceInputPage({super.key, required this.book});

  final Book book;

  @override
  ConsumerState<SentenceInputPage> createState() => _SentenceInputPageState();
}

class _SentenceInputPageState extends ConsumerState<SentenceInputPage> {
  final _contentController = TextEditingController();
  final _pageController = TextEditingController();
  bool _isSaving = false;
  String? _error;

  @override
  void dispose() {
    _contentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    final content = _contentController.text.trim();

    // ✅ 문장 필수 입력
    if (content.isEmpty) {
      setState(() => _error = '문장을 입력해주세요');
      return;
    }

    // ✅ 페이지 입력 처리
    final pageText = _pageController.text.trim();

    // 숫자 아닌 경우 차단
    if (pageText.isNotEmpty && int.tryParse(pageText) == null) {
      setState(() => _error = '페이지는 숫자로 입력해주세요');
      return;
    }

    final pageNumber = pageText.isNotEmpty ? int.parse(pageText) : null;
    final bookId = widget.book.id;

    setState(() {
      _isSaving = true;
      _error = null;
    });

    try {
      await ref
          .read(sentenceNotifierProvider(bookId).notifier)
          .addSentence(bookId, content, pageNumber: pageNumber);

      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.darkBg,
      appBar: AppBar(
        backgroundColor: AppColors.darkBg,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: AppColors.onDark,
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          '문장 남기기',
          style: AppTextStyles.playfairAppBarTitle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _DarkLabel(label: '문장'),
              const SizedBox(height: 8),
              _DarkTextField(
                controller: _contentController,
                hintText: '기억하고 싶은 문장을 입력하세요',
                maxLines: 6,
                keyboardType: TextInputType.multiline,
              ),
              const SizedBox(height: 20),
              _DarkLabel(label: '페이지 번호 (선택)'),
              const SizedBox(height: 8),
              _DarkTextField(
                controller: _pageController,
                hintText: '예: 142',
                maxLines: 1,
                keyboardType: TextInputType.number,
              ),
              if (_error != null) ...[
                const SizedBox(height: 12),
                Text(_error!, style: AppTextStyles.notoError),
              ],
              const Spacer(),
              FilledButton(
                onPressed: _isSaving ? null : _save,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.4),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                child: _isSaving
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.white,
                        ),
                      )
                    : Text('저장하기', style: AppTextStyles.notoSaveButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DarkLabel extends StatelessWidget {
  const _DarkLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppTextStyles.notoLabel);
  }
}

class _DarkTextField extends StatelessWidget {
  const _DarkTextField({
    required this.controller,
    required this.hintText,
    required this.maxLines,
    required this.keyboardType,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType keyboardType;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: AppTextStyles.notoInput,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.notoHint,
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.white.withValues(alpha: 0.07),
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(
            color: AppColors.white.withValues(alpha: 0.07),
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.accent,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

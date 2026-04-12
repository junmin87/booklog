import 'package:flutter/material.dart';
import 'package:book_log/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/app_colors.dart';
import '../../../../app/app_text_styles.dart';
import '../../../../core/service/review_service.dart';
import '../../../../core/utils/validators.dart';
import '../../domain/entity/book.dart';
import '../provider/sentence_notifier.dart';

class SentenceInputPage extends ConsumerStatefulWidget {
  const SentenceInputPage({super.key, required this.book});

  final Book book;

  @override
  ConsumerState<SentenceInputPage> createState() => _SentenceInputPageState();
}

class _SentenceInputPageState extends ConsumerState<SentenceInputPage> {
  final _formKey = GlobalKey<FormState>();
  final _contentController = TextEditingController();
  final _pageController = TextEditingController();
  bool _isSaving = false;
  String? _saveError;

  @override
  void dispose() {
    _contentController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final content = _contentController.text.trim();
    final pageText = _pageController.text.trim();
    final pageNumber = pageText.isNotEmpty ? int.parse(pageText) : null;
    final bookId = widget.book.id;

    setState(() {
      _isSaving = true;
      _saveError = null;
    });

    try {
      await ref
          .read(sentenceNotifierProvider(bookId).notifier)
          .addSentence(bookId, content, pageNumber: pageNumber);

      if (mounted) {
        ReviewService().requestReview();
        Navigator.of(context).pop();
      }
    } catch (e) {
      if (mounted) setState(() => _saveError = e.toString());
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }


  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

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
          l10n.saveSentenceTitle,
          style: AppTextStyles.playfairAppBarTitle,
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _DarkLabel(label: l10n.sentenceLabel),
                const SizedBox(height: 8),
                _DarkTextField(
                  controller: _contentController,
                  hintText: l10n.sentenceHint,
                  maxLines: 6,
                  keyboardType: TextInputType.multiline,
                  validator: (v) => Validators.sentence(v, l10n),
                ),
                const SizedBox(height: 20),
                _DarkLabel(label: l10n.pageNumberLabel),
                const SizedBox(height: 8),
                _DarkTextField(
                  controller: _pageController,
                  hintText: l10n.pageNumberHint,
                  maxLines: 1,
                  keyboardType: TextInputType.number,
                  validator: (v) => Validators.pageNumber(v, l10n),
                ),
                if (_saveError != null) ...[
                  const SizedBox(height: 12),
                  Text(_saveError!, style: AppTextStyles.notoError),
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
                      : Text(l10n.save, style: AppTextStyles.notoSaveButton),
                ),
              ],
            ),
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
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final int maxLines;
  final TextInputType keyboardType;
  final FormFieldValidator<String>? validator;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      style: AppTextStyles.notoInput,
      validator: validator,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTextStyles.notoHint,
        filled: true,
        fillColor: AppColors.darkCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 14,
        ),
        errorStyle: AppTextStyles.notoError,
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
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.errorRedSoft,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(
            color: AppColors.errorRedSoft,
            width: 1.5,
          ),
        ),
      ),
    );
  }
}

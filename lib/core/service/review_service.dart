import 'package:in_app_review/in_app_review.dart';

class ReviewService {
  final _inAppReview = InAppReview.instance;

  Future<void> requestReview() async {
    try {
      if (await _inAppReview.isAvailable()) {
        await _inAppReview.requestReview();
      }
    } catch (_) {}
  }
}

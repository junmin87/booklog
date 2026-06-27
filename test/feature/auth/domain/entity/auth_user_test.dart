import 'package:book_log/feature/auth/domain/entity/auth_user.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('AuthUser', () {
    // 서버 응답 JSON과 동일한 키로 AuthUser를 수동 생성할 수 있는지 검증
    // Verify AuthUser can be manually created using server response JSON keys
    test('getMe() 패턴으로 수동 생성 시 모든 필드가 올바르게 설정된다', () {
      final json = {
        'id': 'user-123',
        'email': 'test@example.com',
        'countryCode': 'KR',
        'languageCode': 'ko',
        'plan': 'premium',
        'snsType': 'apple',
        'snsId': 'apple-id-456',
      };

      final user = AuthUser(
        id: json['id'] as String,
        email: json['email'] as String?,
        countryCode: json['countryCode'] as String?,
        languageCode: json['languageCode'] as String?,
        plan: json['plan'] as String? ?? 'free',
        snsType: json['snsType'] as String,
        snsId: json['snsId'] as String,
      );

      expect(user.id, 'user-123');
      expect(user.email, 'test@example.com');
      expect(user.countryCode, 'KR');
      expect(user.languageCode, 'ko');
      expect(user.plan, 'premium');
      expect(user.snsType, 'apple');
      expect(user.snsId, 'apple-id-456');
    });

    // plan이 null일 때 기본값 'free'가 적용되는지 검증
    // Verify default 'free' plan is applied when plan is null
    test('plan이 null이면 기본값 free가 사용된다', () {
      final json = {
        'id': 'user-123',
        'email': null,
        'countryCode': null,
        'languageCode': null,
        'plan': null,
        'snsType': 'apple',
        'snsId': 'apple-id-456',
      };

      final user = AuthUser(
        id: json['id'] as String,
        email: json['email'] as String?,
        countryCode: json['countryCode'] as String?,
        languageCode: json['languageCode'] as String?,
        plan: json['plan'] as String? ?? 'free',
        snsType: json['snsType'] as String,
        snsId: json['snsId'] as String,
      );

      expect(user.plan, 'free');
      expect(user.email, isNull);
      expect(user.countryCode, isNull);
      expect(user.languageCode, isNull);
    });

    // toString()이 모든 필드를 포함하는지 검증
    // Verify toString() includes all fields
    test('toString()은 모든 필드를 포함한다', () {
      final user = AuthUser(
        id: 'u1',
        snsType: 'apple',
        snsId: 's1',
      );

      final str = user.toString();
      expect(str, contains('u1'));
      expect(str, contains('apple'));
      expect(str, contains('s1'));
      expect(str, contains('free'));
    });
  });
}

// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthUser _$AuthUserFromJson(Map<String, dynamic> json) => _AuthUser(
  id: json['id'] as String,
  email: json['email'] as String?,
  countryCode: json['countryCode'] as String?,
  languageCode: json['languageCode'] as String?,
  plan: json['plan'] as String? ?? 'free',
  snsType: json['snsType'] as String,
  snsId: json['snsId'] as String,
);

Map<String, dynamic> _$AuthUserToJson(_AuthUser instance) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'countryCode': instance.countryCode,
  'languageCode': instance.languageCode,
  'plan': instance.plan,
  'snsType': instance.snsType,
  'snsId': instance.snsId,
};

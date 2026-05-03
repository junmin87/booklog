import 'package:flutter/services.dart';

class NativeNotificationService {
  static const _channel = MethodChannel('com.booklog/notification');

  /// Returns the current iOS notification permission status as a string:
  /// 'authorized', 'denied', 'notDetermined', 'provisional', or 'unknown'.
  /// Returns 'unsupported' on platforms that haven't implemented the channel.
  Future<String> getNotificationSettings() async {
    try {
      final result = await _channel.invokeMethod<String>(
        'getNotificationSettings',
      );
      return result ?? 'unknown';
    } on MissingPluginException {
      return 'unsupported';
    }
  }

  /// Sets the app icon badge number on iOS.
  /// No-op on platforms that haven't implemented the channel.
  Future<void> setBadgeCount(int count) async {
    try {
      await _channel.invokeMethod('setBadgeCount', {'count': count});
    } on MissingPluginException {
      // Platform not yet implemented
    }
  }

  /// Clears the app icon badge on iOS.
  /// No-op on platforms that haven't implemented the channel.
  Future<void> clearBadge() async {
    try {
      await _channel.invokeMethod('clearBadge');
    } on MissingPluginException {
      // Platform not yet implemented
    }
  }
}

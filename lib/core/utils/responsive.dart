import 'package:flutter/material.dart';

enum DeviceType {
  /// iPhone SE — width < 380
  compact,

  /// iPhone 14 / 15 — width < 400
  regular,

  /// iPhone Pro Max — width < 440
  large,

  /// iPad — width >= 440
  tablet,
}

/// Responsive layout utility for iOS devices from iPhone SE to iPad.
///
/// Call [Responsive.init] once from the top-level shell or app widget.
class Responsive {
  Responsive._();

  static double _width = 375.0;
  static DeviceType _deviceType = DeviceType.regular;

  /// Capture screen width and determine [DeviceType].
  static void init(BuildContext context) {
    _width = MediaQuery.of(context).size.width;
    if (_width < 380) {
      _deviceType = DeviceType.compact;
    } else if (_width < 400) {
      _deviceType = DeviceType.regular;
    } else if (_width < 440) {
      _deviceType = DeviceType.large;
    } else {
      _deviceType = DeviceType.tablet;
    }
  }

  static DeviceType get deviceType => _deviceType;

  /// Proportional width scaling based on 375 px reference width.
  static double w(double value) => value * (_width / 375.0);

  /// Font scaling clamped to 0.85× – 1.2× of the reference size.
  static double sp(double value) {
    final scale = (_width / 375.0).clamp(0.85, 1.2);
    return value * scale;
  }

  /// Return a device-specific value with fallback chain:
  /// tablet → large → regular → compact.
  ///
  /// [compact] is required as the ultimate fallback.
  static T byDevice<T>({
    required T compact,
    T? regular,
    T? large,
    T? tablet,
  }) {
    switch (_deviceType) {
      case DeviceType.tablet:
        return tablet ?? large ?? regular ?? compact;
      case DeviceType.large:
        return large ?? regular ?? compact;
      case DeviceType.regular:
        return regular ?? compact;
      case DeviceType.compact:
        return compact;
    }
  }
}

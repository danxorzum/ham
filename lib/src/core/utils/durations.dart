/// {@template durations}
/// Common durarions:
///
///   - [express]: 50ms.
///   - [ultraFast]: 100ms.
///   - [fastest]: 150ms.
///   - [fast]: 250ms.
///   - [medium]: 350ms.
///   - [halfSecond]: 500ms.
///   - [slow]: 700ms.
///   - [slower]: 1000ms.
///   - [ultraSlower]: 2000ms.
/// {@endtemplate}
class Durations {
  /// 50ms.
  static const Duration express = Duration(milliseconds: 50);

  /// 100ms.
  static const Duration ultraFast = Duration(milliseconds: 100);

  /// 150ms.
  static const Duration fastest = Duration(milliseconds: 150);

  ///250ms.
  static const Duration fast = Duration(milliseconds: 250);

  ///350ms.
  static const Duration medium = Duration(milliseconds: 350);

  ///500ms.
  static const Duration halfSecond = Duration(milliseconds: 500);

  ///700ms.
  static const Duration slow = Duration(milliseconds: 700);

  ///1000ms.
  static const Duration slower = Duration(milliseconds: 1000);

  ///2000ms.
  static const Duration ultraSlower = Duration(milliseconds: 2000);
}

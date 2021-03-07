/// Строковые значения биометрии
abstract class _ValuesType {
  /// Отсутствует
  static const String none = 'none';

  /// Тач
  static const String touchID = 'touchID';

  /// Лицо
  static const String faceID = 'faceID';
}

/// Типы биометрии
enum PermittedBiometricType {
  /// Отсутствует
  none,

  /// Тач
  touchID,

  /// Лицо
  faceID,
}

/// Расширение для enum биометрии
extension PermittedBiometricTypeExtension on PermittedBiometricType {
  /// Получить значение
  String get value {
    switch (this) {
      case PermittedBiometricType.none:
        return _ValuesType.none;
      case PermittedBiometricType.touchID:
        return _ValuesType.touchID;
      case PermittedBiometricType.faceID:
        return _ValuesType.faceID;
    }
    return '';
  }
}

/// Получить значение из строки
PermittedBiometricType getPermittedBiometricTypeFromString(String value) {
  switch (value) {
    case _ValuesType.touchID:
      return PermittedBiometricType.touchID;
    case _ValuesType.faceID:
      return PermittedBiometricType.faceID;
    case _ValuesType.none:
    default:
      return PermittedBiometricType.none;
  }
}

/// Ключи для хранилища биометрии
abstract class BiometricStorageKeys {
  /// Тип биометрии
  static const String biometricType = 'biometric_type';

  /// Включена ли биометрия
  /// TODO раскомментировать если будет использоваться
  /// ручное включение / выключение возможности использовать биометрию
//  static const String biometricEnable = 'biometric_enable';

  /// Попытки входа
  static const String loginAttempts = 'login_attempts';

  /// Пин-код
  static const String pinKey = 'fsdmwjkx';
}

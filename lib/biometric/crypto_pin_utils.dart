import 'dart:convert';

/// crypto: 2.1.5
import 'package:crypto/crypto.dart';

/// Класс с утилитами для шифрования и хэширования пин-кода
class CryptoPinUtils {
  static final Hash _algorithm = sha256;

  /// Возвращает хэш строки
  /// [str] - строка для которой расчитывается хэш
  static String getHash(String str) {
    final Digest hash = _algorithm.convert(utf8.encode(str));
    return hash.toString();
  }
}

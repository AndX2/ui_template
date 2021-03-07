import 'package:flutter/material.dart';
import 'package:ui_kit_template/biometric/biometric_type.dart';
import 'package:ui_kit_template/widget/virtual_keyboard/table_button.dart';

///vibration: 1.7.3
import 'package:vibration/vibration.dart';

/// Колбэк нажатия на клавишу числа
typedef KeyboardPressCallback = void Function(String keyboardKey);

/// Виджет виртуальной клавиатуры
class VirtualKeyboardWidget extends StatelessWidget {
  const VirtualKeyboardWidget.enter({
    @required this.onPressKey,
    @required this.onPressDeleteKey,
    @required this.onPressForgotKey,
    @required this.onPressBiometryKey,
    this.biometricType,
    Key key,
  })  : hasBiometryKey = biometricType != null,
        hasDeleteKey = biometricType == null,
        super(key: key);

  /// TODO кнопка "Отмена" на клавиатуре не реализована
  const VirtualKeyboardWidget.create({
    @required this.onPressKey,
    @required this.onPressDeleteKey,
    Key key,
  })  : onPressForgotKey = null,
        hasBiometryKey = false,
        hasDeleteKey = true,
        onPressBiometryKey = null,
        biometricType = null,
        super(key: key);

  factory VirtualKeyboardWidget.change({
    Key key,
    KeyboardPressCallback onPressKey,
    VoidCallback onPressDeleteKey,
  }) =>
      VirtualKeyboardWidget.create(
        key: key,
        onPressKey: onPressKey,
        onPressDeleteKey: onPressDeleteKey,
      );

  static const double _keyboardPaddingHorizontal = 50;

  /// Состояние кнопки биометрия
  final bool hasBiometryKey;

  /// Состояние кнопки удалить
  final bool hasDeleteKey;

  /// Тип биометрии
  final PermittedBiometricType biometricType;

  /// Нажатие на клавишу
  final KeyboardPressCallback onPressKey;

  /// Нажатие на клавишу Забыли код
  final VoidCallback onPressForgotKey;

  /// Нажатие на клавишу биометрии
  final VoidCallback onPressBiometryKey;

  /// Нажатие на клавишу
  final VoidCallback onPressDeleteKey;

  @override
  Widget build(BuildContext context) {
    /// Подгоняем под размеры экрана
    final double buttonHeight = MediaQuery.of(context).size.height < 640 ? 70 : 97;

    final double keyboardKeyWidth = _getWidth(context);
    return Material(
      type: MaterialType.transparency,
      child: Table(
        children: [
          for (int i = 0; i < 3; i++)
            _buildLine(
              i,
              keyboardKeyWidth,
              buttonHeight,
            ),
          TableRow(
            children: [
              onPressForgotKey == null
                  ? const SizedBox.shrink()
                  : _buildForgotCodeKey(keyboardKeyWidth, buttonHeight),
              _buildNumericKey('0', keyboardKeyWidth, buttonHeight),
              _buildBiometricOrDeleteKey(keyboardKeyWidth, buttonHeight),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBiometricOrDeleteKey(
    double keyboardKeyWidth,
    double buttonHeight,
  ) {
    return hasBiometryKey
        ? _buildBiometryKey(keyboardKeyWidth, buttonHeight)
        : hasDeleteKey
            ? _buildDeleteKey(keyboardKeyWidth, buttonHeight)
            : const SizedBox.shrink();
  }

  TableRow _buildLine(
    int rowIndex,
    double keyboardKeyWidth,
    double buttonHeight,
  ) {
    return TableRow(
      children: [
        for (int i = 1; i < 4; i++)
          _buildNumericKey(
            (i + 3 * rowIndex).toString(),
            keyboardKeyWidth,
            buttonHeight,
          )
      ],
    );
  }

  Widget _buildNumericKey(String value, double width, double height) {
    return KeyboardButton(
      key: ValueKey(value),
      width: width,
      height: height,
      onTap: () async {
        onPressKey?.call(value);

        /// при тапе на цифру нужно вызывать вибрацию
        if (await Vibration.hasVibrator()) {
          await Vibration.vibrate(duration: 80);
        }
      },
      text: value,
    );
  }

  Widget _buildForgotCodeKey(double width, double height) {
    /// Показывать опционально
    /// Возможно 2 конструктора
    return KeyboardButton(
      key: const ValueKey('forgot'),
      width: width,
      height: height,
      onTap: onPressForgotKey,
      icon: Icons.restore,
    );
  }

  Widget _buildBiometryKey(double width, double height) {
    if (biometricType == null) return const SizedBox.shrink();
    return KeyboardButton(
      width: width,
      height: height,
      onTap: onPressBiometryKey,
      icon: biometricType == PermittedBiometricType.faceID ? Icons.face : Icons.fingerprint,
    );
  }

  Widget _buildDeleteKey(double width, double height) {
    return KeyboardButton(
      width: width,
      height: height,
      onTap: onPressDeleteKey,
      icon: Icons.backspace_sharp,
    );
  }

  double _getWidth(BuildContext context) {
    /// Вычисяем размер для равномерной компановк
    final double keyboardWidth = MediaQuery.of(context).size.width - _keyboardPaddingHorizontal * 2;
    return keyboardWidth / 3;
  }
}

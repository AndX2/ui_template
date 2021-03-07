import 'package:flutter/material.dart';

/// Виджет символов пин-кода
class PinSymbolsWidget extends StatelessWidget {
  const PinSymbolsWidget({
    @required this.doneCount,
    @required this.maxCount,
    Key key,
    this.enteredSymbolColor,
    this.errorColor,
  }) : super(key: key);

  static const double _symbolSize = 12;

  /// Стрим с введенными символами
  final int doneCount;

  /// Максимальое количество символов
  final int maxCount;

  /// Цвет введенных символов
  final Color enteredSymbolColor;

  /// Принудительно закрасить все пины в цвет ошибки
  final Color errorColor;

  Color get _enteredSymbolColor => enteredSymbolColor ?? Colors.blue;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(maxCount, (index) => _buildSymbol(doneCount > index)),
    );
  }

  Widget _buildSymbol(bool entered) {
    return Container(
      width: _symbolSize,
      height: _symbolSize,
      margin: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: errorColor ?? (entered ? _enteredSymbolColor : Colors.grey),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:ink_widget/ink_widget.dart';

/// Кнопка для виртуальной клавиатуры
class KeyboardButton extends StatefulWidget {
  const KeyboardButton({
    Key key,
    this.width,
    this.height,
    this.text,
    this.icon,
    this.onTap,
  }) : super(key: key);

  /// Ширина кнопки
  final double width;

  /// Ширина высота
  final double height;

  final String text;

  final IconData icon;

  /// Колбэк нажатия
  final VoidCallback onTap;

  @override
  _KeyboardButtonState createState() => _KeyboardButtonState();
}

class _KeyboardButtonState extends State<KeyboardButton> {
  bool _pressed = false;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Stack(
        children: [
          Center(
            child: SizedBox(
              height: 68.0,
              width: 68.0,
              child: InkWidget(
                disable: false,
                splashColor: Colors.transparent,
                highlightColor: Colors.blue.withOpacity(.3),

                /// onTapDown используется как основной механизм нажатия
                /// для избежания отсутствия отклика во время "скольжения" пальца
                /// при быстром нажатии на клавиши
                onTapDown: (_) {
                  widget.onTap?.call();
                },
                onHighlightChanged: (highlight) {
                  setState(() => _pressed = highlight);
                },

                /// Задается чтобы кнопка была кликабельна
                onTap: () {},
                shapeBorder: const CircleBorder(
                  side: BorderSide(
                    width: 30,
                  ),
                ),
                child: Container(),
              ),
            ),
          ),
          Positioned.fill(
            child: IgnorePointer(
              child: Center(
                child: widget.text != null
                    ? Text(
                        widget.text,
                        style: TextStyle(
                          fontSize: 32.0,
                          color: _pressed ? Colors.blue : Colors.black,
                        ),
                      )
                    : Icon(
                        widget.icon,
                        color: _pressed ? Colors.blue : null,
                      ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

import 'package:ui_kit_template/widget/virtual_keyboard/pin_symbols_widget.dart';
import 'package:ui_kit_template/widget/virtual_keyboard/virtual_keyboard_widget.dart';

const _pinCount = 4;
const _rightPin = '1234';

class PinCodeScreen extends StatefulWidget {
  PinCodeScreen({Key key}) : super(key: key);

  @override
  _PinCodeScreenState createState() => _PinCodeScreenState();
}

class _PinCodeScreenState extends State<PinCodeScreen> {
  bool _isHasError = false;
  List<String> _pin = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 60.0, 20.0, 56.0),
        child: Column(
          children: [
            Text('Введите ПИН код', style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 24.0),
            PinSymbolsWidget(
              maxCount: _pinCount,
              doneCount: _pin.length,
              errorColor: _isHasError ? Colors.red : null,
            ),
            !_isHasError
                ? Container()
                : Padding(
                    padding: const EdgeInsets.only(top: 20.0),
                    child: Text(
                      'Неправильный ПИН код',
                      style: TextStyle(fontSize: 14.0, color: Colors.red),
                    ),
                  ),
            const Spacer(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: VirtualKeyboardWidget.enter(
                //TODO: определить по наличию установленной биометрии
                // biometricType: PermittedBiometricType.touchID,
                onPressForgotKey: () {},
                onPressKey: _onAddSimbol,
                onPressDeleteKey: _onDelete,
                //TODO: определить по наличию установленной биометрии
                onPressBiometryKey: null,
              ),
            )
          ],
        ),
      ),
    );
  }

  void _onAddSimbol(String simbol) {
    _cleanIsHasError();
    if (_pin.length < _pinCount) setState(() => _pin.add(simbol));

    if (_pin.length == _pinCount) {
      /// действие при завершении ввода ПИН кода
      final pinCode = _pin.join();
      if (pinCode != _rightPin) {
        setState(() {
          _pin = [];
          _isHasError = true;
        });
      }
    }
  }

  void _onDelete() {
    _cleanIsHasError();
    if (_pin.isNotEmpty) setState(() => _pin.removeLast());
  }

  void _cleanIsHasError() {
    if (_isHasError)
      setState(() {
        _pin = [];
        _isHasError = false;
      });
  }
}

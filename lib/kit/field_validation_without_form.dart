import 'dart:async';

import 'package:flutter/material.dart';

class FieldValidationWithoutFormKit extends StatefulWidget {
  FieldValidationWithoutFormKit({Key key}) : super(key: key);

  @override
  _FieldValidationWithoutFormKitState createState() => _FieldValidationWithoutFormKitState();
}

class _FieldValidationWithoutFormKitState extends State<FieldValidationWithoutFormKit> {
  final loginController = TextEditingController();
  final loginErrorStream = StreamController<String>();

  final passController = TextEditingController();
  final passErrorStream = StreamController<String>();
  bool _isPassObscure = true;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: themeData,
      child: Scaffold(
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: 64.0),
              StreamBuilder<String>(
                stream: loginErrorStream.stream,
                builder: (_, error) {
                  return TextField(
                    controller: loginController,
                    decoration: InputDecoration(
                      labelText: 'Логин',
                      fillColor: error.data != null ? Colors.red.withOpacity(.2) : null,
                      errorText: error.data,
                    ),
                    cursorHeight: 24.0,
                    onTap: _loginTapAction,
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.visiblePassword,
                  );
                },
              ),
              SizedBox(height: 16.0),
              StreamBuilder<String>(
                  stream: passErrorStream.stream,
                  builder: (_, error) {
                    return TextField(
                      controller: passController,
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                        fillColor: error.data != null ? Colors.red.withOpacity(.2) : null,
                        suffix: GestureDetector(
                          onTap: _obscureTapAction,
                          child: Icon(
                            _isPassObscure ? Icons.visibility_off : Icons.visibility,
                            color: Colors.grey,
                            size: 16.0,
                          ),
                        ),
                        errorText: error.data,
                      ),
                      obscureText: _isPassObscure,
                      obscuringCharacter: '●',
                      cursorHeight: 24.0,
                      onTap: _passTapAction,
                      textInputAction: TextInputAction.done,
                      keyboardType: TextInputType.visiblePassword,
                      onSubmitted: (_) => _submit(),
                    );
                  }),
              SizedBox(height: 24.0),
              ElevatedButton(
                child: Text('Логин!'),
                onPressed: _submit,
              ),
              SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    loginErrorStream.close();
    passErrorStream.close();
    super.dispose();
  }

  void _loginTapAction() {
    loginErrorStream.add(null);
  }

  void _passTapAction() {
    passErrorStream.add(null);
  }

  void _obscureTapAction() {
    setState(() => _isPassObscure = !_isPassObscure);
  }

  void _submit() {
    _validate();
  }

  bool _validate() {
    var hasError = false;
    final loginError = loginValidator(loginController.text);
    if (loginError != null) {
      loginErrorStream.add(loginError);
      hasError = true;
    } else {
      loginErrorStream.add(null);
    }

    final passError = passValidator(passController.text);
    if (passError != null) {
      passErrorStream.add(passError);
      hasError = true;
    } else {
      passErrorStream.add(null);
    }
    return !hasError;
  }
}

final themeData = ThemeData(
  errorColor: Colors.red,
  inputDecorationTheme: InputDecorationTheme(
    contentPadding: const EdgeInsets.fromLTRB(16.0, 10.0, 16.0, 10.0),
    filled: true,
    fillColor: Colors.grey[300],
    // labelStyle: StyleRes.regular16Secondary.copyWith(letterSpacing: .7),
    disabledBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    enabledBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    focusedErrorBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.red, width: 4.0),
    ),
    border: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    errorBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.red, width: 4.0),
    ),
    focusedBorder: UnderlineInputBorder(
      borderRadius: BorderRadius.circular(12.0),
      borderSide: const BorderSide(color: Colors.transparent),
    ),
    // hintStyle: StyleRes.regular16Secondary,
    // prefixStyle: StyleRes.regular16Primary,
  ),
  cursorColor: Colors.blue,
  textSelectionHandleColor: Colors.blue,
);

/// Символы допустимые в логине пользователя
const loginSimbolsRange = r'([0-9A-Za-z._\-@!])';

///Метод валидатор содержимого поля login
String loginValidator(String value) {
  if (value.isEmpty) {
    return 'Введите логин';
  } else if (value.length < 6) {
    return 'Не менее {#} символов'.format([6.toString()]);
  } else if (value.length > 128) {
    return 'Не более {#} символов'.format([128.toString()]);
  }
  final loginExp = RegExp(loginSimbolsRange);
  final firstWrong = value.split('').toList().firstWhere(
        (item) => !loginExp.hasMatch(item),
        orElse: () => null,
      );
  if (firstWrong != null) {
    return 'Недопустимый символ "{#}"'.format([firstWrong]);
  }

  return null;
}

///Метод валидатор содержимого поля password
String passValidator(String value) {
  if (value.isEmpty) {
    return 'Введите пароль';
  } else if (value.length < 8) {
    return 'Не менее {#} символов'.format([8.toString()]);
  } else if (value.length > 128) {
    return 'Не более {#} символов'.format([128.toString()]);
  }
  final loginExp = RegExp(loginSimbolsRange);
  final firstWrong = value.split('').toList().firstWhere(
        (item) => !loginExp.hasMatch(item),
        orElse: () => null,
      );
  if (firstWrong != null) {
    return 'Недопустимый символ "{#}"'.format([firstWrong]);
  }

  return null;
}

extension StringExtensions on String {
  /// Шаблонизация строк как в Android:
  ///
  ///     ```dart
  ///     'some {#} text {#}'.format(['one', 'two']) =>
  ///     'some one text two'
  ///     ```
  ///
  String format(List<String> params) {
    var result = this;

    params.forEach(
      (param) => result = result.replaceFirst(RegExp('{#}'), param),
    );
    return result;
  }
}

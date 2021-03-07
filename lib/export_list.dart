import 'package:ui_kit_template/domain/template_item.dart';
import 'package:ui_kit_template/kit/field_validation_without_form.dart';
import 'package:ui_kit_template/kit/pin_code.dart';
import 'package:ui_kit_template/kit/top_snack.dart';

/// Экспорт демо экранов с виджетами
final List<TemplateItem> templateList = [
  TemplateItem(
    title: 'Валидация полей ввода без формы',
    gistId: 'dac8fd2fbe1e701af0929890fc908fbd',
    description: 'EmptyDescription',
    isNeedRunOnStart: true,
    kitForDeviceFrame: FieldValidationWithoutFormKit(),
    // darkTheme: true,
    author: 'AndX2',
    srcLink: 'https://github.com/AndX2/ui_template',
  ),
  TemplateItem(
    title: 'Экран ввода ПИН кода',
    gistId: '09b9fd4b7fb21126ecf43500f5870c04',
    description: 'Виртуальная клавиатура, биометрия',
    isNeedRunOnStart: false,
    kitForDeviceFrame: PinCodeScreen(),
    author: 'AndX2',
    srcLink: 'https://github.com/AndX2/ui_template',
  ),
  TemplateItem(
    title: 'Верхний снек бар',
    gistId: '767275ce6f1180f44a424b0f44fd9e0e',
    isNeedRunOnStart: false,
    kitForDeviceFrame: TopSnackKit(),
    author: 'Aleksey Radionov',
    srcLink: 'https://github.com/AndX2/ui_template',
  ),
];

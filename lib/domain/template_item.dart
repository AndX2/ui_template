import 'package:flutter/material.dart';

@immutable
class TemplateItem {
  TemplateItem({
    @required this.title,
    this.description,
    @required this.gistId,
    this.isNeedRunOnStart = true,
    this.kitForDeviceFrame,
    this.darkTheme = false,
    this.srcLink,
    this.author,
  });

  final String title;
  final String description;
  final String gistId;
  final bool isNeedRunOnStart;
  final Widget kitForDeviceFrame;
  final bool darkTheme;
  final String author;
  final String srcLink;
}

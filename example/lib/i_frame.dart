import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

class IframeWeb extends StatefulWidget {
  final double height;
  final double width;
  final String url;
  const IframeWeb({
    Key key,
    this.height = 500.0,
    this.width = 500.0,
    this.url,
  }) : super(key: key);
  @override
  _YoutubeWidgetState createState() => _YoutubeWidgetState();
}

class _YoutubeWidgetState extends State<IframeWeb> {
  Widget _iframeWidget;
  final IFrameElement _iframeElement = IFrameElement();
  String _url;

  @override
  void initState() {
    super.initState();
    _url = widget.url;
    _iframeElement.height = '${widget.height}';
    _iframeElement.width = '${widget.width}';

    _iframeElement.src = _url;
    _iframeElement.style.border = 'none';

    // ignore:undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      'iframeElement$_url',
      (int viewId) => _iframeElement,
    );
    _iframeWidget = HtmlElementView(
      viewType: 'iframeElement$_url',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: _iframeWidget,
      ),
    );
  }
}

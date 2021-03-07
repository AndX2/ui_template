import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ui_kit_template/domain/template_item.dart';
import 'package:ui_kit_template/export_list.dart';
import 'package:ui_kit_template_example/i_frame.dart';
import 'package:ui_kit_template_example/main.dart';

void main() {
  runApp(App());
}

/// Web environment only!
class App extends StatefulWidget {
  App({Key key}) : super(key: key);

  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  final scaffoldKey = GlobalKey<ScaffoldState>();
  final navigatorKey = GlobalKey<NavigatorState>();
  TemplateItem _currentItem = templateList[0];

  @override
  Widget build(_) {
    return MaterialApp(
      home: Builder(builder: (context) {
        return Scaffold(
          key: scaffoldKey,
          endDrawer: _buildDrawer(context),
          body: ContentWidget(item: _currentItem),
        );
      }),
    );
  }

  Widget _buildDrawer(BuildContext context) {
    return Drawer(
      child: Scaffold(
        body: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DrawerHeader(child: SizedBox(height: 160.0)),
            ...templateList.map<Widget>((item) => _buildMenuTile(context, item)),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuTile(BuildContext context, TemplateItem item) => ListTile(
        title: Text(item.title),
        subtitle: item.description != null ? Text(item.description) : null,
        selected: _currentItem == item,
        onTap: () {
          setState(() => _currentItem = item);
          if (scaffoldKey.currentState.isEndDrawerOpen) Navigator.of(context).pop();
          _showAuthorSnack(item);
        },
      );

  void _showAuthorSnack(TemplateItem item) {
    if (item.author != null || item.srcLink != null)
      scaffoldKey.currentState.showSnackBar(SnackBar(
        content: Column(
          children: [
            if (item.author != null) Text('Author: {$item.author}'),
            if (item.srcLink != null) Text('Source: {$item.srcLink}'),
          ],
        ),
      ));
  }
}

class ContentWidget extends StatelessWidget {
  const ContentWidget({
    Key key,
    @required this.item,
  }) : super(key: key);

  final TemplateItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: LayoutBuilder(builder: (_, cons) {
              final url =
                  'https://dartpad.dev/embed-flutter.html?id=${item.gistId}&run=${item.isNeedRunOnStart}${item.darkTheme ? '&theme=dark' : ''}';
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppBar(
                    title: Text(
                      item.title,
                      maxLines: 1,
                      style: TextStyle(
                        fontSize: 24.0,
                        color: Colors.white,
                      ),
                    ),
                    automaticallyImplyLeading: false,
                  ),
                  IframeWeb(
                    key: ValueKey(url),
                    height: cons.maxHeight - kToolbarHeight,
                    width: cons.maxWidth,
                    url: url,
                  ),
                ],
              );
            }),
          ),
          SizedBox(width: 32.0),
          if (item.kitForDeviceFrame != null)
            SingleChildScrollView(child: DeviceFrame(child: item.kitForDeviceFrame)),
        ],
      ),
    );
  }
}

import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:ui_kit_template/kit/field_validation_without_form.dart';

void main() {
  runApp(App());
}

class App extends StatelessWidget {
  const App({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DeviceFrame(child: FieldValidationWithoutFormKit()),
    );
  }
}

class DeviceFrame extends StatefulWidget {
  const DeviceFrame({@required this.child, Key key}) : super(key: key);

  final Widget child;

  @override
  _DeviceFrameState createState() => _DeviceFrameState();
}

class _DeviceFrameState extends State<DeviceFrame> {
  final sizeStream = StreamController<Size>();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CupertinoSegmentedControl<int>(
          padding: const EdgeInsets.all(8.0),
          children: {
            0: Padding(padding: const EdgeInsets.all(8.0), child: Text('iPhone5SE')),
            1: Padding(padding: const EdgeInsets.all(8.0), child: Text('iPhone8Plus')),
            2: Padding(padding: const EdgeInsets.all(8.0), child: Text('iPhoneX')),
          },
          onValueChanged: _chandeSize,
        ),
        StreamBuilder<Size>(
            initialData: Size(320.0, 568.0),
            stream: sizeStream.stream,
            builder: (context, snapshot) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: SizedBox(
                  height: snapshot.data.height,
                  width: snapshot.data.width,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20.0),
                        border: Border.all(width: 2.0, color: Colors.grey)),
                    child:
                        ClipRRect(borderRadius: BorderRadius.circular(20.0), child: widget.child),
                  ),
                ),
              );
            }),
      ],
    );
  }

  @override
  void dispose() {
    sizeStream.close();
    super.dispose();
  }

  void _chandeSize(int index) {
    switch (index) {
      case 0:
        sizeStream.add(Size(320.0, 568.0));
        break;
      case 1:
        sizeStream.add(Size(414.0, 736.0));
        break;
      case 2:
        sizeStream.add(Size(375.0, 812.0));
        break;
    }
  }
}

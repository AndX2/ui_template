import 'dart:async';
import 'package:flutter/material.dart';

/// overlay_support: 1.0.5
import 'package:overlay_support/overlay_support.dart';

class TopSnackKit extends StatelessWidget {
  const TopSnackKit({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
        child: MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Spacer(),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: ElevatedButton(
                child: Text('Показать снек!'),
                onPressed: () => showTopSnack(TopSnackBar(
                    child: Text(
                  'SnackBar',
                  style: TextStyle(color: Colors.white),
                ))),
              ),
            )
          ],
        ),
      ),
    ));
  }
}

const _topSnackDuration = Duration(milliseconds: 2000);
const _topSnackAnimationDuration = Duration(milliseconds: 400);
const _startAlignment = Alignment(-1.0, -2.0);
const _endAlignment = Alignment(-1.0, -1.0);
const _curve = Curves.linear;
const _reversCurve = Curves.linear;
const Color _defaultColor = Colors.blue;

/// Открытие снекбара сверху (ios style)
void showTopSnack(TopSnackBar snackBar) {
  // используется showOverlayNotification вместо showSimpleNotification(
  // для того чтобы использовать вертикальный жест для смахивания нотификации
  showOverlayNotification(
    (context) {
      return Dismissible(
        key: UniqueKey(),
        direction: DismissDirection.vertical,
        onDismissed: (direction) {
          OverlaySupportEntry.of(context).dismiss(animate: false);
        },
        child: Material(
          color: Colors.transparent,
          child: SafeArea(
              child: Padding(
            padding: const EdgeInsets.only(left: 16, right: 16, top: 28),
            child: Container(
              decoration: BoxDecoration(
                color: snackBar.backgroundColor,
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: ListTileTheme(
                textColor: Theme.of(context)?.accentTextTheme?.headline6?.color,
                iconColor: Theme.of(context)?.accentTextTheme?.headline6?.color,
                child: ListTile(
                  subtitle: snackBar,
                ),
              ),
            ),
          )),
        ),
      );
    },
  );
}

///Маршрут снекбара на слое Overlay
class TopSnackRoute<T> extends OverlayRoute<T> {
  TopSnackRoute(this._snackBar);

  final TopSnackBar _snackBar;

  AnimationController _controller;

  Animation<Alignment> _animation;

  Timer _timer;

  @override
  void install() {
    super.install();
    _controller = AnimationController(
      duration: _topSnackAnimationDuration,
      vsync: navigator,
    );
    _animation = createAnimation();
  }

  @override
  TickerFuture didPush() {
    _timer = Timer(_topSnackDuration, () {
      _controller.reverse();
    });
    _controller.forward();
    _animation.addStatusListener(_animationChanged);
    return super.didPush();
  }

  @override
  bool didPop(result) {
    _timer.cancel();
    _controller.reverse();
    return super.didPop(result);
  }

  @override
  Iterable<OverlayEntry> createOverlayEntries() {
    return [
      OverlayEntry(
        builder: (context) {
          return AlignTransition(
            alignment: _animation,
            child: Dismissible(
              key: UniqueKey(),
              direction: DismissDirection.up,
              onDismissed: (direction) {
                if (isCurrent) {
                  navigator.pop();
                } else {
                  navigator.removeRoute(this);
                }
              },
              child: _snackBar,
            ),
          );
        },
      ),
    ];
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  void _animationChanged(AnimationStatus status) {
    switch (status) {
      case AnimationStatus.completed:
        break;
      case AnimationStatus.dismissed:
        if (isCurrent) {
          navigator.pop();
        } else {
          navigator.removeRoute(this);
        }
        break;
      default:
    }
  }

  Animation<Alignment> createAnimation() {
    return AlignmentTween(begin: _startAlignment, end: _endAlignment).animate(
      CurvedAnimation(
        parent: _controller,
        curve: _curve,
        reverseCurve: _reversCurve,
      ),
    );
  }
}

///Контент показываемого верхнего SnackBar
class TopSnackBar extends StatelessWidget {
  const TopSnackBar({
    Key key,
    this.child,
    this.elevation = 0,
    this.backgroundColor = _defaultColor,
  }) : super(key: key);

  final Color backgroundColor;
  final Widget child;
  final double elevation;

  TopSnackBar copyWith({
    Color backgroundColor,
    Widget child,
    Widget action,
    double elevation,
    VoidCallback callback,
  }) {
    return TopSnackBar(
      backgroundColor: backgroundColor ?? this.backgroundColor,
      elevation: elevation ?? this.elevation,
      child: child ?? this.child,
    );
  }

  @override
  Widget build(BuildContext context) {
    final topInset = MediaQuery.of(context).padding.top;
    return Material(
      elevation: elevation,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: double.infinity,
            color: backgroundColor,
            padding: EdgeInsets.only(top: topInset),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 16.0,
                horizontal: 16.0,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}

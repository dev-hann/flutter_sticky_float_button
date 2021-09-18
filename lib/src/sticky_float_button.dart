import 'dart:math';

import 'package:flutter/material.dart';

class StickyFloatButton extends StatefulWidget {
  const StickyFloatButton({
    Key? key,
    required this.child,
    this.initPosition = Alignment.bottomRight,
    this.stickyDuration = const Duration(milliseconds: 500),
    this.stickyAnimation = Curves.fastLinearToSlowEaseIn,
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);

  final Widget child;
  final Alignment initPosition;
  final Duration stickyDuration;
  final Curve stickyAnimation;
  final EdgeInsets padding;

  @override
  _StickyFloatButtonState createState() => _StickyFloatButtonState();
}

class _StickyFloatButtonState extends State<StickyFloatButton> {
  final ValueNotifier<Offset> _offsetNotifier = ValueNotifier(Offset.zero);

  Offset get offset => _offsetNotifier.value;

  Duration _duration = Duration.zero;

  late _FloatItem _child;

  Size get childSize => _child.ofSize(context) ?? Size.zero;

  Offset get childCenter => Offset(childSize.width / 2, childSize.height / 2);

  Rect get playGround {
    final _padding = widget.padding;
    final _screen = MediaQuery.of(context).size;
    final _width = _screen.width - childSize.width;
    final _height = _screen.height -
        childSize.height -
        Scaffold.of(context).appBarMaxHeight!;
    return Rect.fromLTWH(
      (childSize.width / 2) + _padding.left,
      (childSize.height / 2) + _padding.top,
      _width - (_padding.horizontal),
      _height - (_padding.vertical),
    );
  }

  @override
  void initState() {
    super.initState();
    _child = _FloatItem(child: widget.child);
    WidgetsBinding.instance!.addPostFrameCallback((timeStamp) {
      _jumpToPosition(widget.initPosition);
    });
  }

  void _onDragStarted() {
    _duration = Duration.zero;
  }

  void _onDragUpdate(DragUpdateDetails details) {
    _offsetNotifier.value += details.delta;
  }

  void onDragEnd(_) {
    _duration = widget.stickyDuration;
    final _alignList = [
      playGround.topLeft,
      playGround.topCenter,
      playGround.topRight,
      playGround.centerLeft,
      playGround.center,
      playGround.centerRight,
      playGround.bottomLeft,
      playGround.bottomCenter,
      playGround.bottomRight,
    ];
    final distanceList = _alignList.map((e) => (offset - e).distance).toList();
    final minValue = distanceList.reduce(min);
    final minIndex = distanceList.indexWhere((element) => element == minValue);
    _jumpToOffset(_alignList[minIndex]);
  }

  void _jumpToOffset(Offset offset) {
    _offsetNotifier.value = offset - childCenter;
  }

  void _jumpToPosition(Alignment alignment) {
    _jumpToOffset(alignment.withinRect(playGround));
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<Offset>(
      valueListenable: _offsetNotifier,
      builder: (_, offset, __) {
        return AnimatedPositioned(
          duration: _duration,
          curve: Curves.fastLinearToSlowEaseIn,
          left: offset.dx,
          top: offset.dy,
          child: Draggable(
            feedback: const SizedBox(),
            onDragStarted: _onDragStarted,
            onDragUpdate: _onDragUpdate,
            onDragEnd: onDragEnd,
            child: widget.child,
          ),
        );
      },
    );
  }
}

class _FloatItem extends StatefulWidget {
  const _FloatItem({required this.child});

  Size? ofSize(BuildContext context) {
    return context.size;
  }

  final Widget child;

  @override
  State<_FloatItem> createState() => _FloatItemState();
}

class _FloatItemState extends State<_FloatItem> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}

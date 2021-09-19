import 'utils.dart';
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

  Size get childSize => context.size ?? Size.zero;

  Rect get playGround {
    final _padding = widget.padding;
    final _screen = MediaQuery.of(context).size;
    final _width = _screen.width - childSize.width;

    final _appbarHeight = Scaffold.of(context).appBarMaxHeight ?? 0.0;
    final _height = _screen.height - childSize.height - _appbarHeight;
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
    WidgetsBinding.instance!.addPostFrameCallback((_) {
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
    _jumpToOffset(playGround.nearestWith(offset));
  }

  void _jumpToOffset(Offset offset) {
    final _childCenter = Offset(childSize.width / 2, childSize.height / 2);
    _offsetNotifier.value = offset - _childCenter;
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

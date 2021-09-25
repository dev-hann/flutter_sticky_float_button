import 'package:flutter/material.dart';
import 'package:sticky_float_button/src/utils.dart';

import 'sticky_state.dart';

class StickyFloatButtonController extends ChangeNotifier {
  StickyFloatButtonController({
    Key? key,
    this.initPosition = Alignment.bottomRight,
    Duration stickyDuration = const Duration(milliseconds: 500),
    this.stickyAnimation = Curves.fastLinearToSlowEaseIn,
  }) : _stickyDuration = stickyDuration;

  ///
  final Alignment initPosition;

  ///
  final Duration _stickyDuration;

  ///
  Duration get stickyDuration {
    switch (touchState) {
      case StickyTouchState.dragging:
        return Duration.zero;
      default:
        return _stickyDuration;
    }
  }

  ///
  final Curve stickyAnimation;

  ///
  final ValueNotifier<StickyTouchState> _touchState =
      ValueNotifier(StickyTouchState.release);

  ///
  StickyTouchState get touchState => _touchState.value;

  ///
  set touchState(StickyTouchState value) {
    if (_touchState.value == value) return;
    _touchState.value = value;
    _updateFloatButton();
  }

  ///

  final ValueNotifier<bool> _floatButtonNotifier = ValueNotifier(false);

  void _updateFloatButton() {
    _floatButtonNotifier.value = !_floatButtonNotifier.value;
  }

  ///
  Offset _floatButtonOffset = Offset.zero;

  Offset get floatButtonOffset => _floatButtonOffset;

  set floatButtonOffset(Offset value) {
    if (_floatButtonOffset == value) return;
    _floatButtonOffset = value;
    _updateFloatButton();
  }

  void _onDragStarted(_) {}

  void _onDragUpdate(PointerMoveEvent event) {
    touchState = StickyTouchState.dragging;
    floatButtonOffset += event.delta;
  }

  void _onDragEnd(_) {
    if (touchState == StickyTouchState.dragging) {
      jumpToOffset(playGround.nearestWith(floatButtonOffset));
      touchState = StickyTouchState.release;
    }
  }

  void jumpToOffset(Offset offset) {
    final _childCenter = Offset(childSize.width / 2, childSize.height / 2);
    floatButtonOffset = offset - _childCenter;
  }

  void jumpToPosition(Alignment alignment) {
    jumpToOffset(alignment.withinRect(playGround));
  }

  late Rect playGround;
  late Size childSize;

  void _init({
    required Rect playGround,
    required Size childSize,
  }) {
    this.playGround = playGround;
    this.childSize = childSize;
  }
}

class StickyFloatButton extends StatefulWidget {
  const StickyFloatButton({
    Key? key,
    required this.child,
    this.controller,
    this.margin = const EdgeInsets.all(16.0),
  }) : super(key: key);
  final StickyFloatButtonController? controller;
  final Widget child;
  final EdgeInsets margin;

  @override
  _StickyFloatButtonState createState() => _StickyFloatButtonState();
}

class _StickyFloatButtonState extends State<StickyFloatButton> {
  late StickyFloatButtonController controller;

  Offset get offset => controller.floatButtonOffset;

  Size get childSize => context.size ?? Size.zero;

  Rect get playGround {
    final _padding = widget.margin;
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
    controller = widget.controller ?? StickyFloatButtonController();
    WidgetsBinding.instance!.addPostFrameCallback((_) {
      controller._init(playGround: playGround, childSize: childSize);
      controller.jumpToPosition(controller.initPosition);
    });
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<bool>(
      valueListenable: controller._floatButtonNotifier,
      builder: (_, __, ___) {
        return AnimatedPositioned(
          duration: controller.stickyDuration,
          curve: controller.stickyAnimation,
          left: offset.dx,
          top: offset.dy,
          child: Listener(
            onPointerDown: controller._onDragStarted,
            onPointerMove: controller._onDragUpdate,
            onPointerUp: controller._onDragEnd,
            child: widget.child,
          ),
        );
      },
    );
  }
}

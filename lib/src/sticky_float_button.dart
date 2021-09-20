import 'package:flutter/material.dart';

import 'package:flutter/widgets.dart';
import 'package:sticky_float_button/src/utils.dart';

enum StickyState {
  release,
  dragging,
}

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
    switch (state) {
      case StickyState.dragging:
        return Duration.zero;
      default:
        return _stickyDuration;
    }
  }

  ///
  final Curve stickyAnimation;

  ///
  final ValueNotifier<StickyState> _state = ValueNotifier(StickyState.release);

  ///
  StickyState get state => _state.value;

  ///
  set state(StickyState value) {
    if (_state.value == value) return;
    _state.value = value;
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

  void _onDragStarted(_) {
    state = StickyState.dragging;
  }

  void _onDragUpdate(PointerMoveEvent event) {
    floatButtonOffset += event.delta;
  }

  void _onDragEnd(_) {
    state = StickyState.release;
    jumpToOffset(playGround.nearestWith(floatButtonOffset));
  }

  void jumpToOffset(Offset offset) {
    final _childCenter = Offset(childSize / 2, childSize / 2);
    floatButtonOffset = offset - _childCenter;
  }

  void jumpToPosition(Alignment alignment) {
    jumpToOffset(alignment.withinRect(playGround));
  }

  late Rect playGround;
  late double childSize;

  void _init({
    required Rect playGround,
    required double childSize,
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
    this.items = const [],
    this.padding = const EdgeInsets.all(16.0),
  }) : super(key: key);
  final StickyFloatButtonController? controller;
  final FloatItem child;
  final List<FloatItem> items;
  final EdgeInsets padding;

  @override
  _StickyFloatButtonState createState() => _StickyFloatButtonState();
}

class _StickyFloatButtonState extends State<StickyFloatButton> {
  late StickyFloatButtonController controller;

  Offset get offset => controller.floatButtonOffset;

  double get childSize => widget.child.size;

  Rect get playGround {
    final _padding = widget.padding;
    final _screen = MediaQuery.of(context).size;
    final _width = _screen.width - childSize;

    final _appbarHeight = Scaffold.of(context).appBarMaxHeight ?? 0.0;
    final _height = _screen.height - childSize - _appbarHeight;
    return Rect.fromLTWH(
      (childSize / 2) + _padding.left,
      (childSize / 2) + _padding.top,
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

class FloatItem extends StatelessWidget {
  const FloatItem({
    Key? key,
    this.size = 32,
    required this.child,
  }) : super(key: key);

  final double size;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: child,
    );
  }
}

part of sticky_float_button;

const List<Alignment> edges = [
  Alignment.bottomRight,
  Alignment.bottomLeft,
  Alignment.topRight,
  Alignment.topLeft,
];

const List<Alignment> crosses = [
  Alignment.bottomCenter,
  Alignment.topCenter,
  Alignment.centerLeft,
  Alignment.centerRight,
];

class StickyBuilder extends StatefulWidget {
  const StickyBuilder({
    Key? key,
    this.controller,
    required this.child,
    required this.stickyButton,
    this.initPosition = Alignment.bottomRight,
    this.enablePosition = edges,
  }) : super(key: key);
  final StickyController? controller;
  final Widget child;
  final Widget stickyButton;
  final Alignment initPosition;
  final List<Alignment> enablePosition;

  @override
  State<StatefulWidget> createState() {
    return StickyBuilderState();
  }
}

class StickyBuilderState extends State<StickyBuilder>
    with TickerProviderStateMixin {
  late StickyController controller;

  @override
  void initState() {
    super.initState();
    controller = widget.controller ?? StickyController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final _box = context.findRenderObject() as RenderBox;
      controller._init(_box.size, this);
    });
  }

  void _onPointMove(PointerMoveEvent event) {
    controller.jumpToOffset(controller.offset + event.delta);
  }

  void _onPointUp(PointerUpEvent event) {
    final offset = event.position;
    final offsetList =
        widget.enablePosition.map((e) => controller.computeOffset(e)).toList();
    final distanceList = offsetList.map((e) => (offset - e).distance).toList();
    final nearest = distanceList.reduce(math.min);
    final index = distanceList.indexWhere((e) => e == nearest);
    if (index == -1) return;
    controller.animatedOffset(offsetList[index]);
  }

  Widget _stickyButton() {
    return ValueListenableBuilder<bool>(
      valueListenable: controller.loadingNotifier,
      builder: (_, isLoading, __) {
        if (isLoading) return const SizedBox();
        return ValueListenableBuilder<Offset>(
          valueListenable: controller.offsetNotifier,
          builder: (_, offset, __) {
            return Align(
              alignment: controller.computeAlignment(offset),
              child: Listener(
                onPointerMove: _onPointMove,
                onPointerUp: _onPointUp,
                child: widget.stickyButton,
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        _stickyButton(),
      ],
    );
  }
}

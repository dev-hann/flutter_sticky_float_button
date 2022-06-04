part of sticky_float_button;

class StickyController extends ChangeNotifier {
  StickyController({
    this.stickyDuration = const Duration(milliseconds: 500),
    this.stickyAnimation = Curves.fastLinearToSlowEaseIn,
  });

  ///
  final Duration stickyDuration;

  ///
  final Curve stickyAnimation;

  void jumpToOffset(Offset offset) {
    offsetNotifier.value = offset;
  }

  void jumpToPosition(Alignment alignment) {
    jumpToOffset(computeOffset(alignment));
  }

  late AnimationController _buttonAC;
  late Animation<Offset> _offsetTween;

  void _initAC(TickerProvider vsync) {
    _buttonAC = AnimationController(
      vsync: vsync,
      duration: stickyDuration,
    );
    _buttonAC.addListener(_acListener);
  }

  void _acListener() {
    jumpToOffset(_offsetTween.value);
  }

  Future animatedOffset(
    Offset offset, {
    Duration? duration,
    Curve? curve,
  }) async {
    if (duration != null) {
      _buttonAC.duration = duration;
    }
    _offsetTween = Tween<Offset>(
      begin: offsetNotifier.value,
      end: offset,
    ).animate(
      CurvedAnimation(
        parent: _buttonAC,
        curve: curve ?? stickyAnimation,
      ),
    );
    _buttonAC.reset();
    _buttonAC.forward();
  }

  Future animatedPosition(
    Alignment alignment, {
    Duration? duration,
    Curve? curve,
  }) async {
    await animatedOffset(
      computeOffset(alignment),
      duration: duration,
      curve: curve,
    );
  }

  final ValueNotifier<Offset> offsetNotifier = ValueNotifier(Offset.zero);
  Offset get offset => offsetNotifier.value;

  late Rect playGround;
  Alignment computeAlignment(Offset offset) {
    return Alignment(
      -1 + (offset.dx / playGround.width) * 2,
      -1 + (offset.dy / playGround.height) * 2,
    );
  }

  Offset computeOffset(Alignment alignment) {
    return Offset(
      playGround.width * (alignment.x + 1) / 2,
      playGround.height * (alignment.y + 1) / 2,
    );
  }

  final ValueNotifier<bool> loadingNotifier = ValueNotifier(true);

  void _init(Size playGround, TickerProvider vsync) {
    this.playGround = Rect.fromLTWH(0, 0, playGround.width, playGround.height);
    _initAC(vsync);
    loadingNotifier.value = false;
  }
}

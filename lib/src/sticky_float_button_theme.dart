import 'package:flutter/material.dart';

class StickyFloatButtonTheme extends InheritedTheme {
  const StickyFloatButtonTheme({
    Key? key,
    required Widget child,
  }) : super(
          key: key,
          child: child,
        );

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return true;
  }

  @override
  Widget wrap(BuildContext context, Widget child) {
    return StickyFloatButtonTheme(child: child);
  }

  const StickyFloatButtonTheme.fallback({Key? key})
      : super(
          key: key,
          child: const _NullWidget(),
        );

  static StickyFloatButtonTheme of(BuildContext context) {
    return context
            .dependOnInheritedWidgetOfExactType<StickyFloatButtonTheme>() ??
        const StickyFloatButtonTheme.fallback();
  }
}

class _NullWidget extends StatelessWidget {
  const _NullWidget();

  @override
  Widget build(BuildContext context) {
    throw FlutterError('BuildContext Error!');
  }
}

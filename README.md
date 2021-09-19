# sticky_float_button

A Flutter implementation of sticky float button.


## Getting started


In the `pubspec.yaml` of your flutter project, add the following dependency:

```yaml
dependencies:
  ...
  sticky_float_button:
```

In your library add the following import:

```dart
import 'package:sticky_float_button/sticky_float_button.dart';
```

For help getting started with Flutter, view the online [documentation](https://flutter.io/).

## Example

You can place one or multiple `SliverStickyHeader`s inside a `CustomScrollView`.

```dart
 AppBar _appBar() {
    return AppBar(
      title: const Text("Sticky Float Example"),
    );
  }

  Widget _body() {
    return const Center(
      child: Text("Sticky"),
    );
  }

  Widget _floatButton() {
    return const StickyFloatButton(
      child: CircleAvatar(
        backgroundColor: Colors.grey,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Builder(
        builder: (context) {
          return Stack(
            children: [
              _body(),
              _floatButton(),
            ],
          );
        },
      ),
    );
  }
```


You can find more examples in the [Example](https://github.com/yoehwan/flutter_sticky_float_button/tree/main/example) project.

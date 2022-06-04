# Sticky Float Button
A Flutter implementation of sticky float button.

<img src="https://user-images.githubusercontent.com/54878755/133954084-9e331f39-e74b-45aa-9874-6b70aa89d844.gif" width="324" height="576">


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


```dart
import 'package:flutter/material.dart';
import 'package:sticky_float_button/sticky_float_button.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Sticky Float Button',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const StickyFloatExample(),
    );
  }
}

class StickyFloatExample extends StatefulWidget {
  const StickyFloatExample({Key? key}) : super(key: key);

  @override
  _StickyFloatExampleState createState() => _StickyFloatExampleState();
}

class _StickyFloatExampleState extends State<StickyFloatExample> {
  AppBar _appBar() {
    return AppBar(
      title: const Text("Sticky Float Example"),
    );
  }

  Widget _body() {
    return Center(
      child: GestureDetector(onTap: () {}, child: const Text("Sticky")),
    );
  }

  Widget _floatButton() {
    return const CircleAvatar(
      backgroundColor: Colors.grey,
      child: Icon(
        Icons.add,
        color: Colors.white,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: StickyBuilder(
        stickyButton: _floatButton(),
        child: _body(),
      ),
    );
  }
}
```

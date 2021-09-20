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
  final StickyFloatButtonController _controller =
      StickyFloatButtonController(initPosition: Alignment.topRight);

  AppBar _appBar() {
    return AppBar(
      title: const Text("Sticky Float Example"),
    );
  }

  Widget _body() {
    return Center(
      child: GestureDetector(
          onTap: () {
            _controller.jumpToPosition(Alignment.center);
          },
          child: const Text("Sticky")),
    );
  }

  Widget _floatButton() {
    return StickyFloatButton(
      controller: _controller,
      child: const FloatItem(
        child: CircleAvatar(
          backgroundColor: Colors.grey,
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
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
}

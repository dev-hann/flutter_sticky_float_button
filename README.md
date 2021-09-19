# sticky_float_button

A Flutter implementation of sticky float button.

![screenShot](https://user-images.githubusercontent.com/54878755/133913574-5ece6476-0127-4e51-99c0-f3a35baf155f.gif)

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

You can use 'Stack' to be located under 'Body' it.

```dart
 import 'package:flutter/material.dart';
 import 'package:sticky_float_button/sticky_float_button.dart';
 
 void main() {
   runApp(const MyApp());
 }
 
 class MyApp extends StatelessWidget {
   const MyApp({Key? key}) : super(key: key);
 
   // This widget is the root of your application.
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
 }
```


You can find more examples in the [Example](https://github.com/yoehwan/flutter_sticky_float_button/tree/main/example) project.
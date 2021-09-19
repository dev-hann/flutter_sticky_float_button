import 'package:flutter/painting.dart';
import 'dart:math' as math;

extension RectDistance on Rect {
  Offset nearestWith(Offset offset) {
    List<Offset> offsetList = [
      topLeft,
      topCenter,
      topRight,
      centerLeft,
      center,
      centerRight,
      bottomLeft,
      bottomCenter,
      bottomRight,
    ];
    final distanceList = offsetList.map((e) => (offset - e).distance).toList();
    final minValue = distanceList.reduce(math.min);
    final minIndex = distanceList.indexWhere((element) => element == minValue);
    return offsetList[minIndex];
  }
  
}

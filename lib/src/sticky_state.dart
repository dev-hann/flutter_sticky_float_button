enum StickyTouchState {
  release,
  dragging,
}


extension StickyStateBool on StickyTouchState{
  bool get isReleased=>this==StickyTouchState.release;
  bool get isDragging=>this==StickyTouchState.dragging;

}


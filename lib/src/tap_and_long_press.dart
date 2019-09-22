import 'dart:async';

import 'package:flutter/gestures.dart';

class TapAndLongPressGestureRecognizer extends TapGestureRecognizer {
  TapAndLongPressGestureRecognizer({Object debugOwner})
      : super(debugOwner: debugOwner);

  GestureLongPressCallback onLongPress;

  final _longPressDeadline = kLongPressTimeout;
  Timer _longPressTimer;

  @override
  void addAllowedPointer(PointerDownEvent event) {
    if (state == GestureRecognizerState.ready) {
      _longPressTimer = Timer(
          _longPressDeadline, () => didExceedLongPressDeadlineWithEvent(event));
    }
    super.addAllowedPointer(event);
  }

  void didExceedLongPressDeadlineWithEvent(PointerDownEvent event) {
    if (onLongPress != null) {
      invokeCallback<void>('onLongPress', onLongPress);
      rejectGesture(primaryPointer);
    }
  }

  @override
  void rejectGesture(int pointer) {
    if (pointer == primaryPointer && state == GestureRecognizerState.possible) {
      _stopLongPressTimer();
    }
    super.rejectGesture(pointer);
  }

  @override
  void didStopTrackingLastPointer(int pointer) {
    if (state != GestureRecognizerState.ready) {
      _stopLongPressTimer();
    }
    super.didStopTrackingLastPointer(pointer);
  }

  @override
  void dispose() {
    _stopLongPressTimer();
    super.dispose();
  }

  void _stopLongPressTimer() {
    if (_longPressTimer != null) {
      _longPressTimer.cancel();
      _longPressTimer = null;
    }
  }
}

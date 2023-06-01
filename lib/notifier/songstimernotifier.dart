import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:volume_controller/volume_controller.dart';

class SongsTimeNotifier with ChangeNotifier {
  // ValueNotifier<int> membersCounts = ValueNotifier(0);
  ValueNotifier<int> counter = ValueNotifier(0);
  ValueNotifier<int> count = ValueNotifier(0);
  ValueNotifier<int> lastValue = ValueNotifier(0);
  // var counter = 0;
  // var count = 0, lastValue = 0;
  ValueNotifier<bool> isMute = ValueNotifier(false);
  DateTime currentDate = DateTime.now();
  Timer? timer;

  setVolumn(value) {
    isMute.value = value;
    if (isMute.value == false) {
      VolumeController().setVolume(0);
      isMute.value = true;
    } else {
      VolumeController().setVolume(30);
      isMute.value = false;
    }
    // isMute.value = !isMute.value;

    notifyListeners();
  }

  startTime() async {
    if (timer == null) {}
    timer = Timer(Duration(seconds: 3), () {
      print("Yeah, this line is printed after 3 seconds");
      counter.value = counter.value + 1;
      print("counter valueeeee: ${counter.value}");
    });

    notifyListeners();
  }

  stopTimer() {
    // if (timer.isActive) {
    //   timer!.cancel();
    // }
    if (timer == null) {
    } else {
      counter.value = 0;
      timer!.cancel();
      timer = null;
    }

    notifyListeners();
  }
}

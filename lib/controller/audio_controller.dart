// ignore_for_file: always_specify_types

import 'package:beatbridge/models/spotify/track.dart';
import 'package:get/get.dart';

///AllQueues Controller
class AudioController extends GetxController {
  final RxInt _duration = 0.obs;
  final RxString _shuffle = 'false'.obs;

  ///get selected value
  int get duration => _duration.value;

  ///get shuffle value
  String get shuffle => _shuffle.value;

  ///set value
  void setDuration(int value) {
    _duration.value = value;
    update(['duration']);
  }

  ///set value
  void setIsShuffle(String value) {
    _shuffle.value = value;
    update(['shuffle']);
  }
}

/// TrackChange
class TrackChangeController extends GetxController {
  Rx<PlayListTrack> _track = PlayListTrack().obs;

  ///get selected value
  Rx<PlayListTrack> get track => _track;

  ///set value
  void setTrack(PlayListTrack value) {
    _track = value.obs;
    update();
  }
}

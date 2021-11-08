
import 'package:beatbridge/models/queuePlayingModel.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
/// dashboard items data generator
class QueuePlayingMockdataUtils {
  /// generate mock data
  static List<queuePlayingModels> getMockedDataQueuePlaying() {
    return <queuePlayingModels>[
      queuePlayingModels(
          id: 1,
          name: 'Taylor Swift',
          title: 'Style',
          type: 'assets/images/image1.png',
          imgUrl: 'assets/images/style.png'),
      queuePlayingModels(
          id: 2,
          name: '1976',
          title: 'Me',
          type: 'assets/images/image2.png',
          imgUrl: 'assets/images/1974.png'),
      queuePlayingModels(
          id: 3,
          name: 'David Bowe',
          title: 'Starman',
          type: 'assets/images/image1.png',
          imgUrl: 'assets/images/starman.png'),
    ];
  }
}
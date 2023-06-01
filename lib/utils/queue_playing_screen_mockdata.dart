
import 'package:beatbridge/models/queue_playing_model.dart';
import 'package:flutter/material.dart';

// ignore: avoid_classes_with_only_static_members
/// dashboard items data generator
class QueuePlayingMockdataUtils {
  /// generate mock data
  static List<QueuePlayingModels> getMockedDataQueuePlaying() {
    return <QueuePlayingModels>[
      QueuePlayingModels(
          id: 1,
          name: 'Taylor Swift',
          title: 'Style',
          type: 'assets/images/image1.png',
          imgUrl: 'assets/images/style.png'),
      QueuePlayingModels(
          id: 2,
          name: '1976',
          title: 'Me',
          type: 'assets/images/image2.png',
          imgUrl: 'assets/images/1974.png'),
      QueuePlayingModels(
          id: 3,
          name: 'David Bowe',
          title: 'Starman',
          type: 'assets/images/image1.png',
          imgUrl: 'assets/images/starman.png'),
    ];
  }
}
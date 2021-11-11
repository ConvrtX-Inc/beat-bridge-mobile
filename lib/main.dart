import 'package:beatbridge/screens/main_navigations/Queue/screens/queue_playing_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

/// App main class
class MyApp extends StatelessWidget {
  /// Constructor
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Beat-Bridge',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const QueuePlayingScreen(),
    );
  }
}

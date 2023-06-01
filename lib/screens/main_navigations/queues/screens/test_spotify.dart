import 'package:beatbridge/utils/services/spotify_api_service.dart';
import 'package:flutter/material.dart';

class TestSpotifyScreen extends StatelessWidget {
  const TestSpotifyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
            onPressed: () {
              SpotifyApiService(context).authorizeCodeFlow();
            },
            child: Text('test')),
      ),
    );
  }
}

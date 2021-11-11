import 'package:flutter/material.dart';

class WalkThrough1Screen extends StatefulWidget {
  const WalkThrough1Screen({Key? key}) : super(key: key);

  @override
  _WalkThrough1ScreenState createState() => _WalkThrough1ScreenState();
}

class _WalkThrough1ScreenState extends State<WalkThrough1Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('WalkThrought 1'),
      ),
    );
  }
}

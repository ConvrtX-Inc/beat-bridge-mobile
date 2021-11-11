import 'package:flutter/material.dart';

class WalkThrough2Screen extends StatefulWidget {
  const WalkThrough2Screen({Key? key}) : super(key: key);

  @override
  _WalkThrough2ScreenState createState() => _WalkThrough2ScreenState();
}

class _WalkThrough2ScreenState extends State<WalkThrough2Screen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('WalkThrought 2'),
      ),
    );
  }
}

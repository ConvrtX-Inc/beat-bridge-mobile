import 'package:flutter/material.dart';

class LoginInputScreen extends StatefulWidget {
  const LoginInputScreen({Key? key}) : super(key: key);

  @override
  _LoginInputScreenState createState() => _LoginInputScreenState();
}

class _LoginInputScreenState extends State<LoginInputScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('LOGIN'),
      ),
    );
  }
}

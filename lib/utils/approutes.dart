import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

class AppRoutes {
  static void push(BuildContext context, Widget page) {
    Navigator.of(context).push(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static void replace(BuildContext context, Widget page) {
    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static void makeFirst(BuildContext context, Widget page) {
    Navigator.of(context).popUntil((predicate) => predicate.isFirst);

    Navigator.of(context).pushReplacement(
      new MaterialPageRoute(builder: (context) => page),
    );
  }

  static void pop(BuildContext context) {
    //  Navigator.pop(context, PageTransition(type: PageTransitionType.leftToRight,));
    Navigator.of(context).pop();
  }

  static void dismissAlert(context) {
    Navigator.of(context).pop();
  }
}

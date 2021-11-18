import 'package:beatbridge/screens/main_navigations/make_queue/widgets/step_one.dart';
import 'package:beatbridge/screens/main_navigations/make_queue/widgets/step_three.dart';
import 'package:beatbridge/screens/main_navigations/make_queue/widgets/step_two.dart';
import 'package:flutter/material.dart';

class MakeYourQueueScreen extends StatefulWidget {
  static _MakeYourQueueScreenState of(BuildContext context) {
    return context.findAncestorStateOfType<_MakeYourQueueScreenState>()!;
  }

  const MakeYourQueueScreen({Key? key}) : super(key: key);

  @override
  _MakeYourQueueScreenState createState() => _MakeYourQueueScreenState();
}

class _MakeYourQueueScreenState extends State<MakeYourQueueScreen> {
  final _navigatorKey = GlobalKey<NavigatorState>();

  void onStepOneComplete() {
    _navigatorKey.currentState!.pushNamed('step_two');
  }

  void onStepTwoComplete() {
    _navigatorKey.currentState!.pushNamed('step_three');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Navigator(
        initialRoute: 'step_one',
        key: _navigatorKey,
        onGenerateRoute: _onGenerateRoute,
      ),
    );
  }

  Route _onGenerateRoute(RouteSettings settings) {
    late Widget page;
    switch (settings.name) {
      case 'step_one':
        page = StepOne(
          onStepOneDone: onStepOneComplete,
        );
        break;
      case 'step_two':
        page = StepTwo(onStepTwoDone: onStepTwoComplete);
        break;

      case 'step_three':
        page = StepThreeScreen();
        break;
      default:
        break;
    }

    return MaterialPageRoute<dynamic>(
      builder: (context) {
        return page;
      },
      settings: settings,
    );
  }
}

import 'package:beatbridge/screens/main_navigations/Queue/screens/queue_playing_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'configurations/routes/route_generator.dart';

void main() {
  runApp(const MyApp());
}

/// Entry point of the app
class MyApp extends StatelessWidget {
  /// Constructor
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: () => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Gilroy',
          ),
          initialRoute: '/',
          onGenerateRoute: RouteGenerator.generateRoute),
      designSize: const Size(375, 812),
    );
  }
}

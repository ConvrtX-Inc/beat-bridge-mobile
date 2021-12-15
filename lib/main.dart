import 'package:beatbridge/configurations/routes/route_generator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(const MyApp());
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: <SystemUiOverlay>[]);
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
          initialRoute: '/select_platform',
          onGenerateRoute: RouteGenerator.generateRoute),
      designSize: const Size(375, 812),
    );
  }
}

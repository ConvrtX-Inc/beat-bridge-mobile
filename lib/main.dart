import 'dart:developer';
import 'package:beatbridge/configurations/routes/route_generator.dart';
import 'package:beatbridge/utils/preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:permission_handler/permission_handler.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

String intialScreen = '/';

const FlutterSecureStorage storage = FlutterSecureStorage();
void main() async {
  log('main');
  await dotenv.load(fileName: '.env.example');
  await SharedPreferencesRepository.init();
  final String? userAuthToken = await storage.read(key: 'userAuthToken');
  final String? userID = await storage.read(key: 'userID');
  log('userAuthToken $userAuthToken');
  log('userID $userID');
  if (userAuthToken != null) {
    intialScreen = '/recent_queues';
  }

  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();

  runApp(MyApp());
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: <SystemUiOverlay>[]);
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _MyApp();
  }
}

/// Entry point of the app
class _MyApp extends State<MyApp> with WidgetsBindingObserver {
  /// Constructor

  // This widget is the root of your application.
  //test 01 push

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    super.initState();
    // getPermission();
  }

  @override
  Future<void> dispose() async {
    WidgetsBinding.instance.removeObserver(this);
    // await SpotifySdk.pause();
    super.dispose();
  }

  @override
  Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
    print('state = $state');
    if (state == AppLifecycleState.paused) {
      // await SpotifySdk.pause();
    } else if (state == AppLifecycleState.detached) {
      await SpotifySdk.pause();
    } else if (state == AppLifecycleState.inactive) {
      // await SpotifySdk.pause();
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      builder: (_, __) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            fontFamily: 'Gilroy',
            pageTransitionsTheme: const PageTransitionsTheme(
              builders: <TargetPlatform, PageTransitionsBuilder>{
                TargetPlatform.android: CupertinoPageTransitionsBuilder(),
                TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
              },
            ),
          ),
          initialRoute: intialScreen,
          onGenerateRoute: RouteGenerator.generateRoute),
      designSize: const Size(375, 812),
    );
  }
}



// import 'package:beatbridge/screens/supports/support_thread.dart';
// import 'package:firebase_core/firebase_core.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
//
// const FlutterSecureStorage storage = FlutterSecureStorage();
//
// void main() async{
//   WidgetsFlutterBinding.ensureInitialized();
//   await Firebase.initializeApp();
//   runApp(ChatterApp());
// }
//
// class ChatterApp extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Chatter',
//
//       theme: ThemeData(
//         textTheme: TextTheme(
//         ),
//       ),
//      home: SupportThreadScreen(),
//
//     );
//   }
// }

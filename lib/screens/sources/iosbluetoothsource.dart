import 'dart:async';
// import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/screens/main_navigations/queues/screens/recent_queue.dart';
import 'package:beatbridge/screens/sources/devicescreen.dart';
import 'package:beatbridge/screens/sources/scanresulttile.dart';
import 'package:beatbridge/utils/approutes.dart';
import 'package:flutter/foundation.dart';
import 'package:app_settings/app_settings.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_blue/flutter_blue.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
// import 'package:nearby_connections/nearby_connections.dart';
// import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:system_settings/system_settings.dart';

import '../../widgets/buttons/app_button_rounded_gradient.dart';

// import 'package:flutter_bluetooth_serial_extended/BluetoothBondState.dart';
// import 'package:flutter_bluetooth_serial_extended/BluetoothConnection.dart';
// import 'package:flutter_bluetooth_serial_extended/BluetoothDevice.dart';
// import 'package:flutter_bluetooth_serial_extended/BluetoothDeviceType.dart';
// import 'package:flutter_bluetooth_serial_extended/BluetoothDiscoveryResult.dart';
// import 'package:flutter_bluetooth_serial_extended/BluetoothPairingRequest.dart';
// import 'package:flutter_bluetooth_serial_extended/BluetoothState.dart';
// import 'package:flutter_bluetooth_serial_extended/FlutterBluetoothSerial.dart';
// import 'package:flutter_bluetooth_serial_extended/flutter_bluetooth_serial.dart';

///Bluetooth Source Screen
class IOSBluetoothSourceScreen extends StatefulWidget {
  ///Constructor
  const IOSBluetoothSourceScreen({Key? key}) : super(key: key);

  @override
  _BluetoothSourceScreenState createState() => _BluetoothSourceScreenState();
}

class _BluetoothSourceScreenState extends State<IOSBluetoothSourceScreen> {
  // BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _myDeviceName = '';
  bool checkBluetooth = false;
  // StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  // List<BluetoothDiscoveryResult> devicesFound =
  //     List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isScanning = true;

  // FlutterBlue flutterBlue = FlutterBlue.instance;
  @override
  void initState() {
    super.initState();

    scanDevice();
    // Get current state
    // FlutterBluePlus.instance.turnOn();
    // FlutterBluetoothSerial.instance.state.then((BluetoothState state) {
    //   setState(() {
    //     _bluetoothState = state;
    //   });
    // });

    //Get device name
    // FlutterBluetoothSerial.instance.name.then((String? name) {
    //   setState(() {
    //     _myDeviceName = name!;
    //   });
    // });

    // Listen for further state changes
    // FlutterBluetoothSerial.instance
    //     .onStateChanged()
    //     .listen((BluetoothState state) {
    //   setState(() {
    //     _bluetoothState = state;
    //   });
    // });

    // startScanningDevices();
  }

  @override
  void dispose() {
    super.dispose();
    // _streamSubscription?.cancel();
  }

  List<ScanResult> results = [];
  // List<BlueScanResult> blueScanResult = [];

  bool load = false;
  scanDevice() async {
    setState(() {
      load = true;
    });
    // flutterBlue
    //     .startScan(
    //         scanMode: ScanMode.opportunistic, timeout: Duration(minutes: 1))
    //     .then((value) {
    //   setState(() {
    //     load = false;
    //   });
    // });

// Listen to scan results
    // var subscription = flutterBlue.scanResults.listen((_results) {
    //   // do something with scan results
    //   setState(() {
    //     results = _results;
    //   });
    //   for (ScanResult r in _results) {
    //     // results.add(r);
    //     print('${r.device.name} found! rssi: ${r.rssi}');
    //   }
    // });
    // flutterBlue.stopScan();
    // var data = await FlutterBluePlus.instance.scan();
    // print("hello bluetooth data: $data");
  }

  var width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: AppColorConstants.mirage,
        leading: GestureDetector(
          onTap: () {
            AppRoutes.pop(context);
          },
          child: Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
          width: width,
          height: height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "click here to select bluetooth device",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              SizedBox(
                height: height * .04,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: width * .7,
                    height: height * .08,
                    child: ButtonRoundedGradient(
                      buttonText: "Select Bluetooth",
                      buttonCallback: () async {
                        await Permission.bluetooth.request();
                        print(
                            "check bluetooth : ${Permission.bluetooth.isGranted}");
                        print(
                            "check bluetooth : ${Permission.location.isGranted}");
                        await Permission.locationAlways.request();

                        AppSettings.openBluetoothSettings().then((value) {
                          AppRoutes.makeFirst(context, RecentQueues());
                        });
                        // await SystemSettings.system().then((value1) {
                        //   print("setting press:");
                        //   AppRoutes.makeFirst(context, RecentQueues());
                        //   print("my settings value:");
                        // });
                        // AppRoutes.makeFirst(context, RecentQueues());
                      },
                    ),
                  ),
                  // InkWell(
                  //   onTap: () {
                  //     SystemSettings.bluetooth().then((value1) {
                  //       print("setting press:");
                  //       AppRoutes.makeFirst(context, RecentQueues());
                  //       print("my settings value:");
                  //     });
                  //     AppRoutes.makeFirst(context, RecentQueues());
                  //     // var _flutterBlue = FlutterBluePlus.instance;
                  //     // print("value of connected devices:");
                  //     // _flutterBlue.connectedDevices.then((value) {
                  //     //   print("value of connected devices: ${value[0].name}");
                  //     //   //Do your processing
                  //     // });
                  //   },
                  //   child: Container(
                  //     width: width * .6,
                  //     height: height * .08,
                  //     decoration: BoxDecoration(
                  //       color: AppColorConstants.darkNavy,
                  //       borderRadius: BorderRadius.circular(width * .03),
                  //     ),
                  //     child: Center(
                  //       child: Text(
                  //         "Select Bluetooth Device",
                  //         style: TextStyle(color: Colors.white, fontSize: 16),
                  //       ),
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ],
          )),
      // body: Container(
      //   width: width,
      //   height: height,
      //   padding: EdgeInsets.all(width * .03),
      //   child: ListView.builder(
      //     itemBuilder: (context, int index) {
      //       return Container(
      //           width: width,
      //           // height: height * .06,
      //           decoration: BoxDecoration(
      //               borderRadius: BorderRadius.circular(width * .03),
      //               color: Colors.blue[900]),
      //           padding: EdgeInsets.all(width * .03),
      //           margin: EdgeInsets.only(top: height * .03),
      //           child: Column(
      //             children: [
      //               Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //                 children: [
      //                   Flexible(
      //                     child: Text(
      //                       "${results[index].device}",
      //                       maxLines: 4,
      //                       overflow: TextOverflow.ellipsis,
      //                       style: TextStyle(color: Colors.white),
      //                     ),
      //                   ),
      //                   InkWell(
      //                     onTap: () async {
      //                       await results[index]
      //                           .device
      //                           .connect(autoConnect: false)
      //                           .then((value) {
      //                         results[index].device.discoverServices();
      //                         print("conneciton status: connected");
      //                       });
      //                     },
      //                     child: Container(
      //                       width: width * .2,
      //                       height: height * .06,
      //                       color: Colors.green,
      //                       child: Center(
      //                         child: Text(
      //                           "Connect",
      //                           style: TextStyle(color: Colors.white),
      //                         ),
      //                       ),
      //                     ),
      //                   )
      //                 ],
      //               ),
      //             ],
      //           ));
      //     },
      //     itemCount: results.length,
      //   ),
      // ),
      // body: RefreshIndicator(
      //   onRefresh: () => FlutterBluePlus.instance.startScan(
      //       timeout: const Duration(seconds: 4),
      //       allowDuplicates: false,
      //       scanMode: ScanMode.opportunistic),
      //   child: SingleChildScrollView(
      //     child: Column(
      //       children: <Widget>[
      //         StreamBuilder<List<BluetoothDevice>>(
      //           stream: Stream.periodic(const Duration(seconds: 2))
      //               .asyncMap((_) => FlutterBluePlus.instance.connectedDevices),
      //           initialData: const [],
      //           builder: (c, snapshot) => Column(
      //             children: snapshot.data!
      //                 .map((d) => ListTile(
      //                       title: Text(
      //                         d.name,
      //                         style: TextStyle(color: Colors.white),
      //                       ),
      //                       subtitle: Text(
      //                         d.id.toString(),
      //                         style: TextStyle(color: Colors.white),
      //                       ),
      //                       trailing: StreamBuilder<BluetoothDeviceState>(
      //                         stream: d.state,
      //                         initialData: BluetoothDeviceState.disconnected,
      //                         builder: (c, snapshot) {
      //                           if (snapshot.data ==
      //                               BluetoothDeviceState.connected) {
      //                             return ElevatedButton(
      //                               onPressed: () {},
      //                               child: const Text('OPEN'),
      //                               // onPressed: () => Navigator.of(context).push(
      //                               //     MaterialPageRoute(
      //                               //         builder: (context) =>
      //                               //             DeviceScreen(device: d))),
      //                             );
      //                           }
      //                           return Text(
      //                             snapshot.data.toString(),
      //                             style: TextStyle(color: Colors.white),
      //                           );
      //                         },
      //                       ),
      //                     ))
      //                 .toList(),
      //           ),
      //         ),
      //         StreamBuilder<List<ScanResult>>(
      //           stream: FlutterBluePlus.instance.scanResults,
      //           initialData: const [],
      //           builder: (c, snapshot) => Column(
      //             children: snapshot.data!
      //                 .map(
      //                   (r) => ScanResultTile(
      //                     result: r,
      //                     onTap: () => Navigator.of(context)
      //                         .push(MaterialPageRoute(builder: (context) {
      //                       r.device.connect();
      //                       return DeviceScreen(device: r.device);
      //                     })),
      //                   ),
      //                 )
      //                 .toList(),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),

      // floatingActionButton: StreamBuilder<bool>(
      //   stream: FlutterBluePlus.instance.isScanning,
      //   initialData: false,
      //   builder: (c, snapshot) {
      //     if (snapshot.data!) {
      //       return FloatingActionButton(
      //         child: const Icon(Icons.stop),
      //         onPressed: () => FlutterBluePlus.instance.stopScan(),
      //         backgroundColor: Colors.red,
      //       );
      //     } else {
      //       return FloatingActionButton(
      //           child: const Icon(Icons.search),
      //           onPressed: () => FlutterBluePlus.instance
      //               .startScan(timeout: const Duration(seconds: 4)));
      //     }
      //   },
      // ),
    );
    // buildUI(),
    // );
  }

//   Widget buildUI() => Scaffold(
//       backgroundColor: AppColorConstants.mirage,
//       body: Padding(
//         padding: EdgeInsets.symmetric(horizontal: 10.w),
//         child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               SizedBox(height: 41.h),
//               IconButton(
//                   icon: Icon(
//                     Icons.arrow_back_ios,
//                     color: AppColorConstants.roseWhite,
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   }),
//               SizedBox(height: 26.h),
//               // Text(AppTextConstants.editMusicSource),
//               Text(
//                 AppTextConstants.bluetoothSource,
//                 style: TextStyle(
//                     fontWeight: FontWeight.w700,
//                     color: AppColorConstants.roseWhite,
//                     fontSize: 30.sp),
//               ),
//               SizedBox(height: 36.h),
//               Container(
//                   margin: EdgeInsets.fromLTRB(0, 0, 0, 14.h),
//                   child: Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: <Widget>[
//                             Text(AppTextConstants.bluetooth,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.w600,
//                                     color: AppColorConstants.roseWhite
//                                         .withOpacity(0.7),
//                                     fontSize: 22)),
//                             SizedBox(height: 6.h),
//                             Text(
//                                 '${AppTextConstants.discoverableAs} "$_myDeviceName"',
//                                 style: TextStyle(
//                                     color: AppColorConstants.roseWhite
//                                         .withOpacity(0.55),
//                                     fontSize: 16)),
//                           ],
//                         ),
//                         // ignore: prefer_if_elements_to_conditional_expressions
//                         checkBluetooth == false
//                             ? FlutterSwitch(
//                                 width: 56,
//                                 height: 40,
//                                 valueFontSize: 15,
//                                 toggleSize: 35,
//                                 value: _bluetoothState.isEnabled,
//                                 borderRadius: 30,
//                                 onToggle: (bool val) async {
//                                   if (val) {
//                                     setState(() {
//                                       checkBluetooth = true;
//                                     });
//                                     // ignore: unrelated_type_equality_checks
//                                     if (FlutterBluetoothSerial
//                                             .instance.isEnabled ==
//                                         true) {
//                                       await FlutterBluetoothSerial.instance
//                                           .requestDisable()
//                                           .then((value) {
//                                         setState(() {
//                                           checkBluetooth = false;
//                                         });
//                                       }).catchError((onError) {
//                                         print("bluetooth issue: ${onError}");
//                                         setState(() {
//                                           checkBluetooth = false;
//                                         });
//                                       });
//                                     } else {
//                                       await FlutterBluetoothSerial.instance
//                                           .requestEnable()
//                                           .then((value) {
//                                         setState(() {
//                                           checkBluetooth = false;
//                                         });
//                                       }).catchError((onError) {
//                                         print("bluetooth issue: ${onError}");
//                                         setState(() {
//                                           checkBluetooth = false;
//                                         });
//                                       });
//                                     }
//                                   } else {
//                                     await FlutterBluetoothSerial.instance
//                                         .requestDisable()
//                                         .then((value) {
//                                       setState(() {
//                                         checkBluetooth = false;
//                                       });
//                                     }).catchError((onError) {
//                                       setState(() {
//                                         checkBluetooth = false;
//                                       });
//                                     });
//                                   }

//                                   setState(() {});
//                                 },
//                                 activeColor: Colors.green,
//                               )
//                             : Container(
//                                 width: 50,
//                                 height: 50,
//                                 child: CircularProgressIndicator(
//                                   color: Colors.green,
//                                 ),
//                               )
//                       ])),

//               Divider(color: AppColorConstants.paleSky),
//               Row(
//                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                   children: <Widget>[
//                     Text(AppTextConstants.myDevices,
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             color: AppColorConstants.roseWhite.withOpacity(0.7),
//                             fontSize: 22)),
//                     TextButton(
//                         onPressed: () {},
//                         child: Text(AppTextConstants.seeAll,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColorConstants.roseWhite,
//                                 fontSize: 13)))
//                   ]),
//               SizedBox(height: 15.h),
//               Expanded(
//                   child: RefreshIndicator(
//                       onRefresh: startScanningDevices,
//                       child: buildMyDevicesList()))
//             ]),
//       ));

//   Widget buildMyDevicesList() => ListView.builder(
//       itemCount: devicesFound.length,
//       itemBuilder: (BuildContext ctx, int index) {
//         final BluetoothDiscoveryResult result = devicesFound[index];
//         final BluetoothDevice device = result.device;
//         final String address = device.address;

//         return buildMyDeviceItem(
//             device: device,
//             callBack: () async {
//               try {
//                 bool bonded = false;
//                 if (device.isBonded) {
//                   await FlutterBluetoothSerial.instance
//                       .removeDeviceBondWithAddress(device.address);
//                 } else {
//                   (await FlutterBluetoothSerial.instance
//                       .bondDeviceAtAddress(device.address)
//                       .then((value) {
//                     setState(() {
//                       bonded = value!;
//                     });
//                     print("bounded value: $value");
//                   }).catchError((onError) {
//                     print("bluetooth connection issue: ${onError}");
//                     bonded = false;
//                     print("bounded value error: $onError");
//                   }))!;
//                 }
//                 setState(() {
//                   devicesFound[devicesFound.indexOf(result)] =
//                       BluetoothDiscoveryResult(
//                           device: BluetoothDevice(
//                             name: device.name ?? '',
//                             address: device.address,
//                             type: device.type,
//                             isConnected: device.isBonded,
//                             bondState: bonded
//                                 ? BluetoothBondState.bonded
//                                 : BluetoothBondState.none,
//                           ),
//                           rssi: result.rssi);
//                 });
//               } on Exception catch (e) {
//                 debugPrint('Error occurred while bonding');
//               }
//             });
//       });

//   Widget buildMyDeviceItem(
//           {required BluetoothDevice device, required VoidCallback callBack}) =>
//       ListTile(
//         onTap: callBack,
//         contentPadding: EdgeInsets.all(2.w),
//         title: Text('${device.name}',
//             style: TextStyle(
//                 color: AppColorConstants.roseWhite,
//                 fontWeight: FontWeight.w600,
//                 fontSize: 17)),
//         subtitle: Text(
//             device.isConnected
//                 ? AppTextConstants.connected
//                 : AppTextConstants.notConnected,
//             style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13)),
//         trailing: Container(
//           height: 50,
//           width: 50,
//           decoration: BoxDecoration(
//               borderRadius: BorderRadius.circular(8),
//               image: DecorationImage(
//                   image: device.isConnected
//                       ? const AssetImage(
//                           '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.bluetoothActiveImage}')
//                       : const AssetImage(
//                           '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.bluetoothInActiveImage}'))),
//         ),
//       );

//   Future<void> startScanningDevices() async {
//     await FlutterBluetoothSerial.instance.state.then((BluetoothState state) {
//       setState(() {
//         _bluetoothState = state;
//       });
//     });

//     //Get device name
//     FlutterBluetoothSerial.instance.name.then((String? name) {
//       setState(() {
//         _myDeviceName = name!;
//         print("my device name: ${name}");
//       });
//     });

//     // Listen for further state changes
//     FlutterBluetoothSerial.instance
//         .onStateChanged()
//         .listen((BluetoothState state) {
//       setState(() {
//         _bluetoothState = state;
//       });
//     });
//     await FlutterBluetoothSerial.instance
//         .getBondedDevices()
//         .then((List<BluetoothDevice> bondedDevices) {
//       setState(() {
//         devicesFound = bondedDevices
//             .map(
//               (BluetoothDevice device) =>
//                   BluetoothDiscoveryResult(device: device),
//             )
//             .toList();

//         // print("device founded: ${devicesFound.length}");
//       });
//     });
// // ignore: unawaited_futures
//     FlutterBluetoothSerial.instance.cancelDiscovery().then((value) {
//       _streamSubscription = FlutterBluetoothSerial.instance
//           .startDiscovery()
//           .listen((BluetoothDiscoveryResult r) {
//         print("listening");
//         debugPrint('DEVICE NAME ${r.device.name} TYPE ${r.device.type} ');
//         setState(() {
//           final int existingIndex = devicesFound.indexWhere(
//               (BluetoothDiscoveryResult element) =>
//                   element.device.address == r.device.address);
//           if (existingIndex >= 0) {
//             devicesFound[existingIndex] = r;
//           } else {
//             devicesFound.add(r);
//           }
//           for (int i = 0; i < devicesFound.length; i++) {
//             if (devicesFound[i].device.name == null ||
//                 devicesFound[i].device.name.toString() == 'null') {
//               devicesFound.removeAt(i);
//             }
//           }
//         });
//       });
//     });

//     debugPrint('Discovered devices:::: ${devicesFound.length}');

//     _streamSubscription!.onDone(() {
//       setState(() {
//         isScanning = false;
//       });
//     });
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//       ..add(IterableProperty<BluetoothDiscoveryResult>(
//           'devicesFound', devicesFound))
//       ..add(DiagnosticsProperty<bool>('isScanning', isScanning));
//   }
}

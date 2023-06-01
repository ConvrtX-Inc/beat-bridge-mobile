import 'dart:async';
import 'dart:io';
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/my_devices_model.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';
import 'package:system_settings/system_settings.dart';

///Step five
class StepFive extends StatefulWidget {
  ///Constructor
  const StepFive({required this.onStepFiveDone, Key? key}) : super(key: key);

  ///Callback
  final void Function() onStepFiveDone;

  @override
  _StepFiveState createState() => _StepFiveState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(ObjectFlagProperty<void Function()>.has(
        'onStepFiveDone', onStepFiveDone));
  }
}

class _StepFiveState extends State<StepFive> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _myDeviceName = '';
  bool checkBluetooth = false;
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> devicesFound =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isScanning = true;

  showSnack() {
    ScaffoldMessenger.of(context).showSnackBar(
        // ignore: prefer_const_constructors
        SnackBar(
            content: Text("Can't go back without completing Queue"),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 1)));
  }

  @override
  void initState() {
    super.initState();

    // Get current state
    FlutterBluetoothSerial.instance.state.then((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    //Get device name
    FlutterBluetoothSerial.instance.name.then((String? name) {
      setState(() {
        _myDeviceName = name!;
      });
    });

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    startScanningDevices();
  }

  @override
  void dispose() {
    _streamSubscription?.cancel();
    super.dispose();
  }

  var width, height;
  @override
  Widget build(BuildContext context) {
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return WillPopScope(
      onWillPop: () async => await showSnack(),
      child: Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: buildUI(),
      ),
    );
  }

  Widget buildUI() => Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w),
        child: Platform.isIOS
            ? Container(
                width: width,
                height: height * .8,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: height * .1,
                    ),
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
                              // await FlutterBluetoothSerial.instance.requestDisable();
                              SystemSettings.bluetooth().then((value1) {
                                print("setting press:");
                                // AppRoutes.makeFirst(context, RecentQueues());
                                print("my settings value:");
                              });
                            },
                          ),
                        ),
                        // InkWell(
                        //   onTap: () {

                        //     // AppRoutes.makeFirst(context, RecentQueues());
                        //     // var _flutterBlue = FlutterBluePlus.instance;
                        //     // print("value of connected devices:");
                        //     // _flutterBlue.connectedDevices.then((value) {
                        //     //   print("value of connected devices: ${value[0].name}");
                        //     //   //Do your processing
                        //     // });
                        //   },
                        //   child:

                        //   Container(
                        //     width: width * .6,
                        //     height: height * .08,
                        //     decoration: BoxDecoration(
                        //       color: AppColorConstants.darkNavy,
                        //       borderRadius: BorderRadius.circular(width * .03),
                        //     ),
                        //     child:

                        //     Center(
                        //       child: Text(
                        //         "Select Bluetooth Device",
                        //         style: TextStyle(
                        //             color: Colors.white, fontSize: 16),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ),
                    SizedBox(
                      height: height * .3,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 27.w, vertical: 16.h),
                          child: Container(
                            width: width * .5,
                            height: height * .08,
                            child: ButtonRoundedGradient(
                              buttonText: AppTextConstants.continueTxt,
                              buttonCallback: () async {
                                // await FlutterBluetoothSerial.instance.requestDisable();
                                widget.onStepFiveDone();
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ))
            : Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
                Widget>[
                // SizedBox(height: 41.h),
                // IconButton(
                //     icon: Icon(
                //       Icons.arrow_back_ios,
                //       color: AppColorConstants.roseWhite,
                //     ),
                //     onPressed: () {
                //       Navigator.of(context).pop();
                //     }),
                // SizedBox(height: 26.h),
                // // Text(AppTextConstants.editMusicSource),
                // Text(
                //   AppTextConstants.bluetoothSource,
                //   style: TextStyle(
                //       fontWeight: FontWeight.w700,
                //       color: AppColorConstants.roseWhite,
                //       fontSize: 30.sp),
                // ),
                SizedBox(height: 36.h),
                Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 14.h),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(AppTextConstants.bluetooth,
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      color: AppColorConstants.roseWhite
                                          .withOpacity(0.7),
                                      fontSize: 22)),
                              SizedBox(height: 6.h),
                              Text(
                                  '${AppTextConstants.discoverableAs} "$_myDeviceName"',
                                  style: TextStyle(
                                      color: AppColorConstants.roseWhite
                                          .withOpacity(0.55),
                                      fontSize: 16)),
                            ],
                          ),
                          checkBluetooth == false
                              ? FlutterSwitch(
                                  width: 56,
                                  height: 40,
                                  valueFontSize: 15,
                                  toggleSize: 35,
                                  value: _bluetoothState.isEnabled,
                                  borderRadius: 30,
                                  onToggle: (bool val) async {
                                    if (val) {
                                      setState(() {
                                        checkBluetooth = true;
                                      });
                                      // ignore: unrelated_type_equality_checks
                                      if (FlutterBluetoothSerial
                                              .instance.isEnabled ==
                                          true) {
                                        await FlutterBluetoothSerial.instance
                                            .requestDisable()
                                            .then((value) {
                                          setState(() {
                                            checkBluetooth = false;
                                          });
                                        }).catchError((onError) {
                                          print("bluetooth issue: ${onError}");
                                          setState(() {
                                            checkBluetooth = false;
                                          });
                                        });
                                      } else {
                                        await FlutterBluetoothSerial.instance
                                            .requestEnable()
                                            .then((value) {
                                          setState(() {
                                            checkBluetooth = false;
                                          });
                                        }).catchError((onError) {
                                          print("bluetooth issue: ${onError}");
                                          setState(() {
                                            checkBluetooth = false;
                                          });
                                        });
                                      }
                                    } else {
                                      await FlutterBluetoothSerial.instance
                                          .requestDisable()
                                          .then((value) {
                                        setState(() {
                                          checkBluetooth = false;
                                        });
                                      }).catchError((onError) {
                                        setState(() {
                                          checkBluetooth = false;
                                        });
                                      });
                                    }

                                    setState(() {});
                                  },
                                  activeColor: Colors.green,
                                )
                              : Container(
                                  width: 50,
                                  height: 50,
                                  child: CircularProgressIndicator(
                                    color: Colors.green,
                                  ),
                                )
                          // FlutterSwitch(
                          //   width: 56,
                          //   height: 40,
                          //   valueFontSize: 15,
                          //   toggleSize: 35,
                          //   value: _bluetoothState.isEnabled,
                          //   borderRadius: 30,
                          //   onToggle: (bool val) async {
                          //     if (val) {
                          //       await FlutterBluetoothSerial.instance
                          //           .requestEnable();
                          //     } else {
                          //       await FlutterBluetoothSerial.instance
                          //           .requestDisable();
                          //     }

                          //     setState(() {});
                          //   },
                          //   activeColor: Colors.green,
                          // )
                        ])),

                Divider(color: AppColorConstants.paleSky),
                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(AppTextConstants.myDevices,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color:
                                  AppColorConstants.roseWhite.withOpacity(0.7),
                              fontSize: 22)),
                      TextButton(
                          onPressed: () {
                            setState(() {});
                          },
                          child: Text(AppTextConstants.seeAll,
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: AppColorConstants.roseWhite,
                                  fontSize: 13)))
                    ]),
                SizedBox(height: 15.h),
                Expanded(
                    child: RefreshIndicator(
                        onRefresh: startScanningDevices,
                        child: buildMyDevicesList())),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 27.w, vertical: 16.h),
                      child: ButtonRoundedGradient(
                        buttonText: AppTextConstants.continueTxt,
                        buttonCallback: () async {
                          // await FlutterBluetoothSerial.instance.requestDisable();
                          widget.onStepFiveDone();
                        },
                      ),
                    ),
                  ],
                )
              ]),
      ));

  Widget buildMyDevicesList() => ListView.builder(
      itemCount: devicesFound.length,
      itemBuilder: (BuildContext ctx, int index) {
        final BluetoothDiscoveryResult result = devicesFound[index];
        final BluetoothDevice device = result.device;
        final String address = device.address;

        return buildMyDeviceItem(
            device: device,
            callBack: () async {
              try {
                bool bonded = false;
                // if (device.isBonded) {
                //   await FlutterBluetoothSerial.instance
                //       .removeDeviceBondWithAddress(address);
                // } else {
                //   bonded = (await FlutterBluetoothSerial.instance
                //       .bondDeviceAtAddress(address))!;
                // }
                if (device.isBonded) {
                  await FlutterBluetoothSerial.instance
                      .removeDeviceBondWithAddress(device.address);
                } else {
                  // ignore: null_check_always_fails
                  (await FlutterBluetoothSerial.instance
                      .bondDeviceAtAddress(device.address)
                      .then((value) {
                    setState(() {
                      bonded = value!;
                    });
                    print("bounded value: $value");
                  }).catchError((onError) {
                    print("bluetooth connection issue: ${onError}");
                    bonded = false;
                    print("bounded value error: $onError");
                  }))!;
                }
                setState(() {
                  devicesFound[devicesFound.indexOf(result)] =
                      BluetoothDiscoveryResult(
                          device: BluetoothDevice(
                            name: device.name ?? '',
                            address: address,
                            type: device.type,
                            isConnected: bonded,
                            bondState: bonded
                                ? BluetoothBondState.bonded
                                : BluetoothBondState.none,
                          ),
                          rssi: result.rssi);
                });
              } on Exception catch (e) {
                debugPrint('Error occurred while bonding');
              }
            });
      });

  Widget buildMyDeviceItem(
          {required BluetoothDevice device, required VoidCallback callBack}) =>
      ListTile(
        onTap: callBack,
        contentPadding: EdgeInsets.all(2.w),
        title: Text('${device.name}',
            style: TextStyle(
                color: AppColorConstants.roseWhite,
                fontWeight: FontWeight.w600,
                fontSize: 17)),
        subtitle: Text(
            device.isConnected
                ? AppTextConstants.connected
                : AppTextConstants.notConnected,
            style: TextStyle(color: AppColorConstants.paleSky, fontSize: 13)),
        trailing: Container(
          height: 50,
          width: 50,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(8),
              image: DecorationImage(
                  image: device.isConnected
                      ? const AssetImage(
                          '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.bluetoothActiveImage}')
                      : const AssetImage(
                          '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.bluetoothInActiveImage}'))),
        ),
      );
  Future<void> startScanningDevices() async {
    await FlutterBluetoothSerial.instance.state.then((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });

    //Get device name
    FlutterBluetoothSerial.instance.name.then((String? name) {
      setState(() {
        _myDeviceName = name!;
        print("my device name: ${name}");
      });
    });

    // Listen for further state changes
    FlutterBluetoothSerial.instance
        .onStateChanged()
        .listen((BluetoothState state) {
      setState(() {
        _bluetoothState = state;
      });
    });
    await FlutterBluetoothSerial.instance
        .getBondedDevices()
        .then((List<BluetoothDevice> bondedDevices) {
      setState(() {
        devicesFound = bondedDevices
            .map(
              (BluetoothDevice device) =>
                  BluetoothDiscoveryResult(device: device),
            )
            .toList();

        // print("device founded: ${devicesFound.length}");
      });
    });
// ignore: unawaited_futures
    FlutterBluetoothSerial.instance.cancelDiscovery().then((value) {
      _streamSubscription = FlutterBluetoothSerial.instance
          .startDiscovery()
          .listen((BluetoothDiscoveryResult r) {
        print("listening");
        debugPrint('DEVICE NAME ${r.device.name} TYPE ${r.device.type} ');
        setState(() {
          final int existingIndex = devicesFound.indexWhere(
              (BluetoothDiscoveryResult element) =>
                  element.device.address == r.device.address);
          if (existingIndex >= 0) {
            devicesFound[existingIndex] = r;
          } else {
            devicesFound.add(r);
          }
          for (int i = 0; i < devicesFound.length; i++) {
            if (devicesFound[i].device.name == null ||
                devicesFound[i].device.name.toString() == 'null') {
              devicesFound.removeAt(i);
            }
          }
        });
      });
    });

    debugPrint('Discovered devices:::: ${devicesFound.length}');

    _streamSubscription!.onDone(() {
      setState(() {
        isScanning = false;
      });
    });
  }

  // Future<void> startScanningDevices() async {
  //   await FlutterBluetoothSerial.instance
  //       .getBondedDevices()
  //       .then((List<BluetoothDevice> bondedDevices) {
  //     setState(() {
  //       devicesFound = bondedDevices
  //           .map(
  //             (BluetoothDevice device) =>
  //                 BluetoothDiscoveryResult(device: device),
  //           )
  //           .toList();
  //     });
  //   });

  //   _streamSubscription = FlutterBluetoothSerial.instance
  //       .startDiscovery()
  //       .listen((BluetoothDiscoveryResult r) {
  //     debugPrint('DEVICE NAME ${r.device.name} TYPE ${r.device.type} ');
  //     setState(() {
  //       final int existingIndex = devicesFound.indexWhere(
  //           (BluetoothDiscoveryResult element) =>
  //               element.device.address == r.device.address);
  //       if (existingIndex >= 0) {
  //         devicesFound[existingIndex] = r;
  //       } else {
  //         devicesFound.add(r);
  //       }
  //       for (int i = 0; i < devicesFound.length; i++) {
  //         if (devicesFound[i].device.name == null ||
  //             devicesFound[i].device.name.toString() == 'null') {
  //           devicesFound.removeAt(i);
  //         }
  //       }
  //     });
  //   });

  //   debugPrint('Discovered devices:::: ${devicesFound.length}');

  //   _streamSubscription!.onDone(() {
  //     setState(() {
  //       isScanning = false;
  //     });
  //   });
  // }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<BluetoothDiscoveryResult>(
          'devicesFound', devicesFound))
      ..add(DiagnosticsProperty<bool>('isScanning', isScanning));
  }
}

// class _StepFiveState extends State<StepFive> {
//   bool isBluetoothOn = true;

//   final List<MyDevicesModel> myDevicesList =
//       StaticDataService.getMyDevicesMockData();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         backgroundColor: AppColorConstants.mirage,
//         body: SingleChildScrollView(child: buildStepFiveUI(context)));
//   }

//   Widget buildStepFiveUI(BuildContext context) {
//     return Column(children: <Widget>[
//       Padding(
//         padding: EdgeInsets.symmetric(horizontal: 16.w),
//         child: Padding(
//             padding: EdgeInsets.symmetric(horizontal: 11.w),
//             child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: <Widget>[
//                   Container(
//                     margin: EdgeInsets.fromLTRB(0, 0, 0, 14.h),
//                     child: Text(AppTextConstants.connectWithBluetooth,
//                         style: TextStyle(
//                             fontWeight: FontWeight.w600,
//                             color: AppColorConstants.roseWhite,
//                             fontSize: 22)),
//                   ),
//                   Divider(color: AppColorConstants.paleSky),
//                   Container(
//                     margin: EdgeInsets.fromLTRB(0, 24.h, 0, 24.h),
//                     child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: <Widget>[
//                           Column(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: <Widget>[
//                               Text(AppTextConstants.bluetooth,
//                                   style: TextStyle(
//                                       fontWeight: FontWeight.w600,
//                                       color: AppColorConstants.roseWhite
//                                           .withOpacity(0.7),
//                                       fontSize: 22)),
//                               Text(
//                                   '${AppTextConstants.discoverableAs} "David\'s IPhone"',
//                                   style: TextStyle(
//                                       color: AppColorConstants.roseWhite
//                                           .withOpacity(0.55),
//                                       fontSize: 16)),
//                             ],
//                           ),
//                           FlutterSwitch(
//                             width: 56,
//                             height: 40,
//                             valueFontSize: 15,
//                             toggleSize: 35,
//                             value: isBluetoothOn,
//                             borderRadius: 30,
//                             onToggle: (bool val) {
//                               setState(() {
//                                 isBluetoothOn = val;
//                               });
//                             },
//                             activeColor: Colors.green,
//                           )
//                         ]),
//                   ),
//                   Divider(color: AppColorConstants.paleSky),
//                   Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: <Widget>[
//                         Text(AppTextConstants.myDevices,
//                             style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 color: AppColorConstants.roseWhite
//                                     .withOpacity(0.7),
//                                 fontSize: 22)),
//                         TextButton(
//                             onPressed: () {},
//                             child: Text(AppTextConstants.seeAll,
//                                 style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     color: AppColorConstants.roseWhite,
//                                     fontSize: 13)))
//                       ]),
//                 ])),
//       ),
//       ListView.builder(
//           padding: EdgeInsets.symmetric(horizontal: 27.w),
//           itemCount: myDevicesList.length,
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemBuilder: (BuildContext ctx, int index) {
//             return Column(
//               crossAxisAlignment: CrossAxisAlignment.stretch,
//               children: <Widget>[buildMyDeviceItem(context, index)],
//             );
//           }),
//       Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: <Widget>[
//           Padding(
//             padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 16.h),
//             child: ButtonRoundedGradient(
//               buttonText: AppTextConstants.continueTxt,
//               buttonCallback: () {
//                 widget.onStepFiveDone();
//               },
//             ),
//           ),
//         ],
//       )
//     ]);
//   }

//   Widget buildMyDeviceItem(BuildContext context, int index) {
//     return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
//         Widget>[
//       SizedBox(height: 24.h),
//       Row(
//         children: <Widget>[
//           Padding(
//               padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
//               child: Container(
//                 height: 50,
//                 width: 50,
//                 decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8),
//                     image: DecorationImage(
//                         image:
//                             AssetImage(myDevicesList[index].deviceImageUrl))),
//               )),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: <Widget>[
//               Text(myDevicesList[index].name,
//                   style: TextStyle(
//                       color: AppColorConstants.roseWhite,
//                       fontWeight: FontWeight.w600,
//                       fontSize: 17)),
//               SizedBox(height: 8.h),
//               Text(
//                   myDevicesList[index].isConnected
//                       ? AppTextConstants.connected
//                       : AppTextConstants.notConnected,
//                   style:
//                       TextStyle(color: AppColorConstants.paleSky, fontSize: 13))
//             ],
//           ),
//           const Spacer(),
//           Container(
//             height: 50,
//             width: 50,
//             decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(8),
//                 image: DecorationImage(
//                     image: myDevicesList[index].isConnected
//                         ? const AssetImage(
//                             '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.bluetoothActiveImage}')
//                         : const AssetImage(
//                             '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.bluetoothInActiveImage}'))),
//           )
//         ],
//       )
//     ]);
//   }

//   @override
//   void debugFillProperties(DiagnosticPropertiesBuilder properties) {
//     super.debugFillProperties(properties);
//     properties
//       ..add(DiagnosticsProperty<bool>('isBluetoothOn', isBluetoothOn))
//       ..add(IterableProperty<MyDevicesModel>('myDevicesList', myDevicesList));
//   }
// }

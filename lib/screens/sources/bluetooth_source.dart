import 'dart:async';
import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';

///Bluetooth Source Screen
class BluetoothSourceScreen extends StatefulWidget {
  ///Constructor
  const BluetoothSourceScreen({Key? key}) : super(key: key);

  @override
  _BluetoothSourceScreenState createState() => _BluetoothSourceScreenState();
}

class _BluetoothSourceScreenState extends State<BluetoothSourceScreen> {
  BluetoothState _bluetoothState = BluetoothState.UNKNOWN;
  String _myDeviceName = '';
  bool checkBluetooth = false;
  StreamSubscription<BluetoothDiscoveryResult>? _streamSubscription;
  List<BluetoothDiscoveryResult> devicesFound =
      List<BluetoothDiscoveryResult>.empty(growable: true);
  bool isScanning = true;

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
    super.dispose();
    _streamSubscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: buildUI(),
    );
  }

  Widget buildUI() => Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10.w),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 41.h),
              IconButton(
                  icon: Icon(
                    Icons.arrow_back_ios,
                    color: AppColorConstants.roseWhite,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  }),
              SizedBox(height: 26.h),
              // Text(AppTextConstants.editMusicSource),
              Text(
                AppTextConstants.bluetoothSource,
                style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColorConstants.roseWhite,
                    fontSize: 30.sp),
              ),
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
                        // ignore: prefer_if_elements_to_conditional_expressions
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
                      ])),

              Divider(color: AppColorConstants.paleSky),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(AppTextConstants.myDevices,
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColorConstants.roseWhite.withOpacity(0.7),
                            fontSize: 22)),
                    TextButton(
                        onPressed: () {},
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
                      child: buildMyDevicesList()))
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
                if (device.isBonded) {
                  await FlutterBluetoothSerial.instance
                      .removeDeviceBondWithAddress(device.address);
                } else {
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
                            address: device.address,
                            type: device.type,
                            isConnected: device.isBonded,
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

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<BluetoothDiscoveryResult>(
          'devicesFound', devicesFound))
      ..add(DiagnosticsProperty<bool>('isScanning', isScanning));
  }
}

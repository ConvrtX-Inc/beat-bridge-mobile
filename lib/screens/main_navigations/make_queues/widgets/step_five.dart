import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/my_devices_model.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_switch/flutter_switch.dart';

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
  bool isBluetoothOn = true;

  final List<MyDevicesModel> myDevicesList = StaticDataService.getMyDevicesMockData();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: SingleChildScrollView(child: buildStepFiveUI(context)));
  }

  Widget buildStepFiveUI(BuildContext context) {
    return Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 0, 0, 14.h),
                    child: Text(AppTextConstants.connectWithBluetooth,
                        style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColorConstants.roseWhite,
                            fontSize: 22)),
                  ),
                  Divider(color: AppColorConstants.paleSky),
                  Container(
                    margin: EdgeInsets.fromLTRB(0, 24.h, 0, 24.h),
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
                              Text(
                                  '${AppTextConstants.discoverableAs} "David\'s IPhone"',
                                  style: TextStyle(
                                      color: AppColorConstants.roseWhite
                                          .withOpacity(0.55),
                                      fontSize: 16)),
                            ],
                          ),
                          FlutterSwitch(
                            width: 56,
                            height: 40,
                            valueFontSize: 15,
                            toggleSize: 35,
                            value: isBluetoothOn,
                            borderRadius: 30,
                            onToggle: (bool val) {
                              setState(() {
                                isBluetoothOn = val;
                              });
                            },
                            activeColor: Colors.green,
                          )
                        ]),
                  ),
                  Divider(color: AppColorConstants.paleSky),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(AppTextConstants.myDevices,
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: AppColorConstants.roseWhite
                                    .withOpacity(0.7),
                                fontSize: 22)),
                        TextButton(
                            onPressed: () {},
                            child: Text(AppTextConstants.seeAll,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColorConstants.roseWhite,
                                    fontSize: 13)))
                      ]),
                ])),
      ),
      ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: 27.w),
          itemCount: myDevicesList.length,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (BuildContext ctx, int index) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[buildMyDeviceItem(context, index)],
            );
          }),
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 27.w, vertical: 16.h),
            child: ButtonRoundedGradient(
              buttonText: AppTextConstants.allDone,
              buttonCallback: () {
                widget.onStepFiveDone();
              },
            ),
          ),
        ],
      )
    ]);
  }

  Widget buildMyDeviceItem(BuildContext context, int index) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
        Widget>[
      SizedBox(height: 24.h),
      Row(
        children: <Widget>[
          Padding(
              padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
              child: Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    image: DecorationImage(
                        image:
                            AssetImage(myDevicesList[index].deviceImageUrl))),
              )),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(myDevicesList[index].name,
                  style: TextStyle(
                      color: AppColorConstants.roseWhite,
                      fontWeight: FontWeight.w600,
                      fontSize: 17)),
              SizedBox(height: 8.h),
              Text(
                  myDevicesList[index].isConnected
                      ? AppTextConstants.connected
                      : AppTextConstants.notConnected,
                  style:
                      TextStyle(color: AppColorConstants.paleSky, fontSize: 13))
            ],
          ),
          const Spacer(),
          Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                    image: myDevicesList[index].isConnected
                        ? const AssetImage(
                            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.bluetoothActiveImage}')
                        : const AssetImage(
                            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.bluetoothInActiveImage}'))),
          )
        ],
      )
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DiagnosticsProperty<bool>('isBluetoothOn', isBluetoothOn))
      ..add(IterableProperty<MyDevicesModel>('myDevicesList', myDevicesList));
  }
}

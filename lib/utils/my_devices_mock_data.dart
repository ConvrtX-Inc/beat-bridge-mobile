import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/my_devices_model.dart';

/// Static data data for My Devices
class MyDevicesMockDataUtils {
  List<MyDevicesModel> getMyDevicesMockData() {
    return <MyDevicesModel>[
      MyDevicesModel(
        id: 1,
        name: 'Sony',
        isConnected: true,
        deviceImageUrl: '${AssetsPathConstants.assetsPNGPath}/sony.png'
      ),
      MyDevicesModel(
          id: 2,
          name: 'JBL Roomie',
          isConnected: false,
          deviceImageUrl: '${AssetsPathConstants.assetsPNGPath}/jbl.png'
      ),
      MyDevicesModel(
          id: 3,
          name: 'Yaz Device',
          isConnected: false,
          deviceImageUrl: '${AssetsPathConstants.assetsPNGPath}/yaz.png'
      ),

    ];
  }
}

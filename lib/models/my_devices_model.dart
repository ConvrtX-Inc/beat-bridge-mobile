///  My Devices Model
class MyDevicesModel {
  /// Constructor
  MyDevicesModel({
    required this.name,
    required this.isConnected,
    required this.deviceImageUrl,
    required this.id
  });

  /// Initialization for id
  int id;

  /// Initialization for device name
  String name;

  /// Initialization for device image url
  String deviceImageUrl;

  /// Initialization for is connected
  bool isConnected;


}

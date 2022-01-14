import 'package:flutter/material.dart';

///Model for profile settings
class ProfileSettingsModel{
  ///Constructor
  ProfileSettingsModel({
    this.icon = '',
    this.name ='',
    this.routePath = ''
});

  ///initialization
  String icon, name , routePath;
}


///Model for system settings
class SystemSettingsModel{
  ///Constructor
  SystemSettingsModel({
    this.icon = const Icon(Icons.settings),
    this.name ='',
    this.routePath = ''
  });

  ///initialization
  String  name , routePath;
  
  ///Initialization for icon
  Widget icon;
}

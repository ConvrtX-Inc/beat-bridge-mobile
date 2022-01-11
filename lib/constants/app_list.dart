import 'package:beatbridge/models/profile_settings_model.dart';

/// Class for app constant list
class AppListConstants {
  /// Constructor
  AppListConstants();

  /// use in profile settings screen
  final List<String> profileSettingsIcons = <String>[
    'profile.png',
    'friends.png',
    'playlist.png',
    'subscribe.png',
    'faq.png',
    'contact.png',
    'settings.png'
  ];

  /// use in profile settings screen
  final List<String> profileSettingsText = <String>[
    'Profile details',
    'Friends',
    'Playlist',
    'Subscribe',
    'FAQ’s',
    'Contact',
    'Settings'
  ];

  ///Profile Settings List
  final List<ProfileSettingsModel> profileSettings = <ProfileSettingsModel>[
    ProfileSettingsModel(
      name: 'Profile Details',
      icon: 'profile.png',
     ),
    ProfileSettingsModel(
      name: 'Friends',
      icon: 'friends.png',
      routePath: '/friends'
    ),
    ProfileSettingsModel(
      name: 'Playlist',
      icon: 'playlist.png',
    ),
    ProfileSettingsModel(
      name: 'Subscribe',
      icon: 'subscribe.png',
    ),
    ProfileSettingsModel(
      name: "FAQ's",
      icon: 'faq.png',
    ),
    ProfileSettingsModel(
      name: 'Contact',
      icon: 'contact.png',
      routePath: '/support'
    ),
    ProfileSettingsModel(
      name: 'Settings',
      icon: 'settings.png',
    ),
  ];

  /// use in profile settings screen
  final List<String> avatarImages = <String>[
    'avatar1.png',
    'avatar2.png',
    'avatar3.png',
    'avatar4.png',
    'avatar5.png',
    'avatar6.png',
    'avatar7.png',
    'avatar8.png',
    'avatar9.png',
    'avatar10.png',
    'avatar11.png',
    'avatar12.png',
    'avatar13.png',
    'avatar14.png',
    'avatar15.png',
    'avatar16.png'
  ];
}

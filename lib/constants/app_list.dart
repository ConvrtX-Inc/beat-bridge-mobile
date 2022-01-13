import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/music_platform_model.dart';
import 'package:beatbridge/models/settings_model.dart';
import 'package:beatbridge/models/subscription_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

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
        name: 'Friends', icon: 'friends.png', routePath: '/friends'),
    ProfileSettingsModel(
      name: 'Playlist',
      icon: 'playlist.png',
    ),
    ProfileSettingsModel(
        name: 'Subscribe', icon: 'subscribe.png', routePath: '/subscribe'),
    ProfileSettingsModel(
      name: "FAQ's",
      icon: 'faq.png',
    ),
    ProfileSettingsModel(
        name: 'Contact', icon: 'contact.png', routePath: '/contact_us'),
    ProfileSettingsModel(
        name: 'Settings', icon: 'settings.png', routePath: '/system_settings'),
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

  /// use in profile settings screen
  final List<SubscriptionModel> subscriptions = <SubscriptionModel>[
    SubscriptionModel(
      price: AppTextConstants.monthlySubscriptionPrice,
      value: 2.99,
    ),
    SubscriptionModel(
      price: AppTextConstants.quarterlySubscriptionPrice,
      value: 5.99,
    ),
    SubscriptionModel(
      price: AppTextConstants.yearlySubscriptionPrice,
      value: 7.99,
    )
  ];

  ///Profile Settings List
  final List<SystemSettingsModel> systemSettings = <SystemSettingsModel>[
    SystemSettingsModel(
        name: 'Music Source',
        icon: const Icon(Icons.music_note_outlined),
        routePath: '/music_source'),
    SystemSettingsModel(
        name: 'Bluetooth Source',
        icon: const Icon(Icons.bluetooth),
        routePath: '/bluetooth_source'),
    SystemSettingsModel(
        name: 'Support',
        icon: SvgPicture.asset(
            '${AssetsPathConstants.assetsSVGPath}/support.svg'),
        routePath: '/support'),
  ];

  ///Music Source List
  final List<MusicPlatformModel> musicSourceList = <MusicPlatformModel>[
    MusicPlatformModel(
      name: AppTextConstants.spotify,
      logoImagePath:
      '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.spotifyLogoImage}',
      isSelected:true
    ),
    MusicPlatformModel(
      name: AppTextConstants.soundCloud,
      logoImagePath:
          '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.soundCloudLogoImage}',
    ),
    MusicPlatformModel(
        name: AppTextConstants.itunes,
        logoImagePath:
            '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.itunesLogoImage}'),
  ];
}

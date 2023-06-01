// ignore_for_file: always_specify_types

import 'dart:convert';

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/app_list.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/screens/auths/logins/screens/login.dart';
import 'package:beatbridge/utils/logout_helper.dart';
import 'package:bs_flutter_modal/bs_flutter_modal.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:spotify/spotify.dart';
import 'package:spotify_sdk/spotify_sdk.dart';

import '../../main.dart';

/// Screen for register input
class ProfileSettigs extends StatefulWidget {
  /// Constructor
  const ProfileSettigs({Key? key}) : super(key: key);

  @override
  _ProfileSettigsState createState() => _ProfileSettigsState();
}

class _ProfileSettigsState extends State<ProfileSettigs> {
  /// use in profile settings screen
  String selectedAvatar = Global.imagetemppath.toString();
  var width, height;

  @override
  Widget build(BuildContext context) {
    print(
        "my profile image is in profile: ${UserSingleton.instance.profileImage}");
    width = MediaQuery.of(context).size.width;
    height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 41.h),
              Row(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 26.w),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                      icon: Icon(Icons.close, color: Colors.white, size: 15.w),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 41.h),
              Row(
                children: [
                  SizedBox(
                    width: width * .08,
                  ),
                  Text(
                    AppTextConstants.heyWelcome,
                    style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColorConstants.roseWhite,
                        fontSize: 14),
                  ),
                ],
              ),
              Padding(
                padding: EdgeInsets.only(left: width * .08, right: width * .08),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (Username.toString() != null)
                      Text(
                        Username.toString(),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColorConstants.lavender,
                          fontSize: 28,
                          fontFamily: AppTextConstants.gilroyBold,
                        ),
                      )
                    else
                      Text(''),
                    if (UserSingleton.instance.profileImage != null)
                      Container(
                        width: MediaQuery.of(context).size.width * .18,
                        height: MediaQuery.of(context).size.height * .08,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          image: DecorationImage(
                            image: NetworkImage(
                                'https://beat.softwarealliancetest.tk${UserSingleton.instance.profileImage}'
                                // Global.imagetemppath,
                                ),
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    else
                      Container()
                  ],
                ),
              ),
              SizedBox(height: 15.h),
              Column(
                children: List<Widget>.generate(
                    AppListConstants().profileSettings.length, (int index) {
                  return Column(
                    children: <Widget>[
                      InkWell(
                        onTap: () async {
                          if (AppListConstants().profileSettings[index].name ==
                              'Logout') {
                            setState(() {
                              UserSingleton.instance.myaccessToken = null;
                            });
                            print('=== Logout ===');
                            await storage.deleteAll();
                            await SpotifySdk.pause().then((value) async {
                              await Navigator.pushAndRemoveUntil<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      LoginScreen(),
                                ),
                                (route) =>
                                    false, // disable back feature set to false
                              );
                            }).catchError((onError) async {
                              await Navigator.pushAndRemoveUntil<dynamic>(
                                context,
                                MaterialPageRoute<dynamic>(
                                  builder: (BuildContext context) =>
                                      LoginScreen(),
                                ),
                                (route) =>
                                    false, // disable back feature set to false
                              );
                            });

                            // await SpotifySdk.pause();
                          } else if (AppListConstants()
                                  .profileSettings[index]
                                  .routePath !=
                              '') {
                            Navigator.pushNamed(
                                context,
                                AppListConstants()
                                    .profileSettings[index]
                                    .routePath);
                          }
                        },
                        child: Padding(
                            padding: EdgeInsets.symmetric(
                                horizontal: 10.w, vertical: 10.h),
                            child: ListTile(
                              leading: Container(
                                height: 18.h,
                                width: 18.w,
                                transform: Matrix4.translationValues(0, 2, 0),
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    // AppListConstants.profileSettingsIcons[index]
                                    image: UserImage != null
                                        ? UserImage
                                        : AssetImage(
                                            '${AssetsPathConstants.assetsPNGPath}/${AppListConstants().profileSettings[index].icon}'),
                                    fit: BoxFit.fitHeight,
                                  ),
                                ),
                              ),
                              title: Text(
                                AppListConstants().profileSettings[index].name,
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: AppColorConstants.roseWhite,
                                    fontSize: 14),
                              ),
                              trailing: Icon(Icons.chevron_right,
                                  color: Colors.white, size: 15.w),
                            )),
                      ),
                      if (index <
                          AppListConstants().profileSettingsIcons.length)
                        const Divider(
                          color: Colors.white,
                        )
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String? Username;
  FlutterSecureStorage storage = FlutterSecureStorage();

  _asyncMethod() async {
    final String? name = await storage.read(key: 'username');
    setState(() {
      Username = name;
    });
  }

  @override
  void initState() {
    super.initState();
    getProfile();
    _asyncMethod();
    //  getImage();
  }

  var profileImage;
  getProfile() async {
    profileImage = await storage.read(key: 'profileimage');
    print("my profile image is: $profileImage");
  }

  loader() {
    CircularProgressIndicator();
  }
  //   Future<Image> getImage() async {
  // final SharedPreferences prefs = await SharedPreferences.getInstance();
  // Uint8List bytes = base64Decode(prefs.getString('image').toString());
  //  UserImage==bytes;
  //  print(UserImage);
  // return Image.memory(bytes);

}

var UserImage;

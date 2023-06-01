import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/app_list.dart';
import 'package:beatbridge/models/subscription_model.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';

///Subscribe Screen
class SubscribeScreen extends StatefulWidget {
  ///Constructor
  const SubscribeScreen({Key? key}) : super(key: key);

  @override
  _SubscribeScreenState createState() => _SubscribeScreenState();
}

class _SubscribeScreenState extends State<SubscribeScreen> {
  int selectedIndex = 0;
  final List<SubscriptionModel> subscriptions =
      AppListConstants().subscriptions;

  @override
  void initState() {
    WidgetsFlutterBinding.ensureInitialized();

    super.initState();
    Stripe.publishableKey = dotenv.env['STRIPE_PUBLISHABLE_KEY'].toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
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
                Text(
                  AppTextConstants.subscribe,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.roseWhite,
                      fontSize: 30.sp),
                ),
                SizedBox(height: 26.h),
                Text(
                  AppTextConstants.subscribeDescriptionText,
                  style: TextStyle(color: AppColorConstants.roseWhite),
                ),
                SizedBox(height: 32.h),
                SizedBox(height: 26.h),
                for (int i = 0; i < subscriptions.length; i++)
                  buildSubscribeButton(i),
                SizedBox(height: 26.h),
                Text(
                  AppTextConstants.subscribeDescriptionText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: AppColorConstants.paleSky, fontSize: 14.sp),
                ),
              ]),
        ));
  }

  Widget buildSubscribeButton(int index) => Column(children: <Widget>[
        // if (selectedIndex == index)
        ButtonRoundedGradient(
            buttonText: subscriptions[index].price,
            buttonCallback: () async {
              setState(() {
                selectedIndex = index;
              });
              await Navigator.pushNamed(context, '/card_input',
                  arguments: subscriptions[selectedIndex]);
            }),
        // else
        //   ButtonAppRoundedButton(
        //       firstBGColor: AppColorConstants.paleSky.withOpacity(0.12),
        //       secondBGColor: AppColorConstants.paleSky.withOpacity(0.12),
        //       buttonColor: Colors.white,
        //       buttonCallback: () {
        //         setState(() {
        //           selectedIndex = index;
        //         });
        //         Navigator.pushNamed(context, '/card_input', arguments:
        //         subscriptions[selectedIndex]
        //         );

        //       },
        //       buttonText: subscriptions[index].price),
        SizedBox(height: 20.h),
      ]);

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(IterableProperty<SubscriptionModel>('subscriptions', subscriptions))
      ..add(IntProperty('selectedIndex', selectedIndex));
  }
}

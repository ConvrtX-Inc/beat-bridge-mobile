import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/models/apis/api_standard_return.dart';
import 'package:beatbridge/models/subscription_model.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/utils/helpers/validator_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:intl/intl.dart';

///Card Input Screen
class CardInputScreen extends StatefulWidget {
  ///Constructor
  const CardInputScreen({@required this.selectedSubscription, Key? key})
      : super(key: key);

  ///Route Parameter for selected subscription
  final SubscriptionModel? selectedSubscription;

  @override
  _CardInputScreenState createState() => _CardInputScreenState();

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(DiagnosticsProperty<SubscriptionModel?>(
        'selectedSubscription', selectedSubscription));
  }
}

class _CardInputScreenState extends State<CardInputScreen> {
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _postalCodeController = TextEditingController();

  final CardFormEditController _cardFormController = CardFormEditController();

  static final GlobalKey<FormState> cardFormGlobalKey = GlobalKey<FormState>();

  late double subscriptionPrice;
  String subscriptionCode = '';
  bool isPaymentInProgress = false;
  String _email = '';
  String _fullName = '';
  String _address = '';
  String _postalCode = '';
  String _city = '';
  final ValidatorHelper _globalValidator = ValidatorHelper();
  final ThemeData theme = ThemeData.light().copyWith(
    inputDecorationTheme: InputDecorationTheme(
        filled: true,
        floatingLabelBehavior: FloatingLabelBehavior.always,
        contentPadding: const EdgeInsets.all(12),
        fillColor: AppColorConstants.paleSky.withOpacity(0.12),
        hintStyle: TextStyle(color: AppColorConstants.paleSky)),
  );

  @override
  void initState() {
    super.initState();
    WidgetsFlutterBinding.ensureInitialized();
    subscriptionPrice = widget.selectedSubscription!.value;
    subscriptionCode = widget.selectedSubscription!.code;
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
                SizedBox(height: 32.h),
                IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColorConstants.roseWhite,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                SizedBox(height: 26.h),
                Expanded(
                    child: Form(
                        key: cardFormGlobalKey, child: buildPaymentInfoUI()))
              ]),
        ));
  }

  Widget buildPaymentInfoUI() => SingleChildScrollView(
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            AppTextConstants.enterYourBillingInfo,
            style: TextStyle(color: AppColorConstants.roseWhite),
          ),
          SizedBox(height: 22.h),
          FormHelper.inputFieldWidgetWithController(
            context,
            AppTextConstants.fullName,
            AppTextConstants.fullName,
            (String onValidateValue) {
              if (onValidateValue.isEmpty) {
                return '${AppTextConstants.fullName} cannot be empty';
              }

              return null;
            },
            (String onSavedValue) {
              _fullName = onSavedValue.trim();
            },
            separatorHeight: 15,
            controller: _fullNameController,
          ),
          SizedBox(height: 15.h),
          FormHelper.inputFieldWidgetWithController(
            context,
            AppTextConstants.email,
            AppTextConstants.email,
            (String onValidateValue) {
              if (onValidateValue.isEmpty) {
                return '${AppTextConstants.email} cannot be empty';
              }
              if (!_globalValidator.isValidEmail(onValidateValue)) {
                return AppTextConstants.invalidEmailFormat;
              }
              return null;
            },
            (String onSavedValue) {
              _email = onSavedValue.trim();
            },
            separatorHeight: 15,
            controller: _emailController,
          ),
          SizedBox(height: 15.h),
          FormHelper.inputFieldWidgetWithController(
            context,
            AppTextConstants.address,
            AppTextConstants.address,
            (String onValidateValue) {
              return null;
            },
            (String onSavedValue) {
              _address = onSavedValue.trim();
            },
            separatorHeight: 15,
            controller: _addressController,
          ),
          SizedBox(height: 15.h),
          Row(
            children: <Widget>[
              Expanded(
                child: FormHelper.inputFieldWidgetWithController(
                  context,
                  AppTextConstants.city,
                  AppTextConstants.city,
                  (String onValidateValue) {
                    return null;
                  },
                  (String onSavedValue) {
                    _city = onSavedValue.trim();
                  },
                  separatorHeight: 15,
                  controller: _cityController,
                ),
              ),
              SizedBox(width: 10.w),
              Expanded(
                child: FormHelper.inputFieldWidgetWithController(
                  context,
                  AppTextConstants.postalCode,
                  AppTextConstants.postalCode,
                  (String onValidateValue) {
                    return null;
                  },
                  (String onSavedValue) {
                    _postalCode = onSavedValue.trim();
                  },
                  separatorHeight: 15,
                  controller: _postalCodeController,
                ),
              )
            ],
          ),
          SizedBox(height: 15.h),
          Text(
            AppTextConstants.cardInfo,
            style:
                TextStyle(color: AppColorConstants.roseWhite, fontSize: 18.sp),
          ),
          SizedBox(height: 15.h),
          Theme(
            data: theme,
            child: Container(
              alignment: Alignment.center,
              child: CardField(
                style: const TextStyle(color: Colors.white),
                onCardChanged: (_) {},
                decoration: InputDecoration(
                  labelStyle: const TextStyle(color: Colors.white),
                  labelText: theme.inputDecorationTheme.floatingLabelBehavior ==
                          FloatingLabelBehavior.always
                      ? 'Card Details'
                      : null,
                ),
              ),
            ),
          ),
          SizedBox(height: 15.h),
          ButtonRoundedGradient(
              isLoading: isPaymentInProgress,
              buttonText: 'Pay \$ $subscriptionPrice',
              buttonCallback: handlePayment),
          SizedBox(height: 15.h),
        ],
      ));

  //Function for payment
  Future<void> handlePayment() async {
    try {
      if (validateAndSave()) {
        debugPrint('Details ${_cardFormController.details}');
        setState(() {
          isPaymentInProgress = !isPaymentInProgress;
        });
        // 1. Initialize customer billing detail
        final BillingDetails billingDetails = BillingDetails(
            email: _email,
            name: _fullName,
            address: Address(
                city: _city,
                country: '',
                postalCode: _postalCode,
                line1: _address,
                line2: '',
                state: ''));

        //2. Create payment method
        final PaymentMethod paymentMethod =
            await Stripe.instance.createPaymentMethod(PaymentMethodParams.card(
          billingDetails: billingDetails,
        ));

        //3. Call Payment API for payment intent
        /*
      Stripe only allows integer value for price so
      we need to change the price (amount) into cent by (*100)
      See: https://stripe.com/docs/api/charges
     */
        final int amount = (subscriptionPrice * 100).round();

        final APIStandardReturnFormat result =
            await APIServices().pay(amount, paymentMethod.id);
        if (result.statusCode == 201) {
          await addSubscription();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
                  'Unable to process the payment!: ${AppTextConstants.anErrorOccurred}')));
        }
        setState(() {
          isPaymentInProgress = false;
        });
      }
    } on Exception catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Unable to process the payment!: ${AppTextConstants.anErrorOccurred}')));
      setState(() {
        isPaymentInProgress = false;
      });
    }
  }

  Future<void> addSubscription() async {
    final DateTime startDate = DateTime.now();
    final String endDate =
        DateFormat('yyyy-MM-dd').format(getEndDate(startDate));
    final APIStandardReturnFormat result = await APIServices()
        .addUserSubscription(DateFormat('yyyy-MM-dd').format(startDate),
            endDate, subscriptionCode, subscriptionPrice);
    if (result.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Success!: The payment was confirmed successfully!')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              'Unable to Create User Subscription!: ${AppTextConstants.anErrorOccurred}')));
    }
  }

  bool validateAndSave() {
    final FormState? form = cardFormGlobalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  DateTime getEndDate(DateTime date) {
    DateTime endDate = DateTime.now();
    switch (subscriptionCode) {
      case 'MONTHLY':
        endDate = DateTime(date.year, date.month + 1, date.day);
        break;
      case 'QUARTERLY':
        endDate = DateTime(date.year, date.month + 3, date.day);
        break;
      case 'YEARLY':
        endDate = DateTime(date.year, date.month + 12, date.day);
    }

    return endDate;
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(DoubleProperty('subscriptionPrice', subscriptionPrice))
      ..add(
          DiagnosticsProperty<bool>('isPaymentInProgress', isPaymentInProgress))
      ..add(DiagnosticsProperty<ThemeData>('theme', theme))
      ..add(StringProperty('subscriptionCode', subscriptionCode));
  }
}

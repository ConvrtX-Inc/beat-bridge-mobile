import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///Create Ticket Screen
class CreateTicketScreen extends StatefulWidget {
  ///Constructor
  const CreateTicketScreen({Key? key}) : super(key: key);

  @override
  _CreateTicketScreenState createState() => _CreateTicketScreenState();
}

class _CreateTicketScreenState extends State<CreateTicketScreen> {
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _ticketNoController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();

  String _subject = '';
  String _ticketNo = '';
  String _description = '';


  static final GlobalKey<FormState> createTicketFormGlobalKey =
      GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20.w),
          child: SingleChildScrollView(
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
                  AppTextConstants.support,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.roseWhite,
                      fontSize: 30.sp),
                ),
                SizedBox(height: 26.h),
                Form(
                    key: createTicketFormGlobalKey,
                    child: buildCreateTicketUI()),
              ]))),
    );
  }

  Widget buildCreateTicketUI() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          FormHelper.inputFieldWidgetWithController(
              context, AppTextConstants.subject, AppTextConstants.subject,
              (String onValidateValue) {
            if (onValidateValue.isEmpty) {
              return '${AppTextConstants.subject} cannot be empty';
            }

            return null;
          }, (String onSavedValue) {
                _subject = onSavedValue.trim();
          },
              separatorHeight: 15,
              controller: _subjectController,
              inputPlaceholder: AppTextConstants.writeHere),
          SizedBox(height: 26.h),
          FormHelper.inputFieldWidgetWithController(
              context, AppTextConstants.ticketNo, AppTextConstants.ticketNo,
              (String onValidateValue) {
            if (onValidateValue.isEmpty) {
              return '${AppTextConstants.ticketNo} cannot be empty';
            }

            return null;
          }, (String onSavedValue) {
                _ticketNo = onSavedValue.trim();
          },
              separatorHeight: 15,
              controller: _ticketNoController,
              inputPlaceholder: AppTextConstants.writeHere),
          SizedBox(height: 26.h),
          FormHelper.inputFieldWidgetWithController(
              context,
              AppTextConstants.description,
              AppTextConstants.description, (String onValidateValue) {
            if (onValidateValue.isEmpty) {
              return '${AppTextConstants.description} cannot be empty';
            }

            return null;
          }, (String onSavedValue) {
                _description = onSavedValue.trim();
          },
              separatorHeight: 15,
              minLines: 8,
              maxLines: null,
              controller: _descriptionController,
              inputPlaceholder: AppTextConstants.writeHere),
          SizedBox(height: 26.h),
          ButtonRoundedGradient(buttonText: AppTextConstants.submit, buttonCallback: createTicket),
          SizedBox(height: 26.h),
        ],
      );


  void createTicket(){
    if(validateAndSave()){
      debugPrint('send ticket... $_subject $_ticketNo $_description');
    }
  }
  bool validateAndSave() {
    final FormState? form = createTicketFormGlobalKey.currentState;
    if (form!.validate()) {
      form.save();
      return true;
    }
    return false;
  }
}

import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/constantsclass.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/users/user_model.dart';
import 'package:beatbridge/screens/supports/support.dart';
import 'package:beatbridge/utils/approutes.dart';
import 'package:beatbridge/utils/helpers/form_helper.dart';
import 'package:beatbridge/utils/services/rest_api_service.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded.dart';
import 'package:beatbridge/widgets/buttons/app_button_rounded_gradient.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

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
  bool loading = false;
  static final GlobalKey<FormState> createTicketFormGlobalKey =
      GlobalKey<FormState>();

  void saveMessage(String constTicketId,String message) async{
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
    var userID = await secureStorage.read(key: 'userID');
    var name = await secureStorage.read(key: 'username');
    var userImage = "https://beat.softwarealliancetest.tk${UserSingleton.instance.profileImage}";
    if(userImage == "https://beat.softwarealliancetest.tk")
      {
        userImage = "";
      }
    else{
      userImage = 'https://beat.softwarealliancetest.tk${UserSingleton.instance.profileImage}';
    }


      /////////////
    FirebaseFirestore.instance
        .collection('messages')
        .doc(constTicketId)
        .set({
      'name': name,
      'image': userImage,
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    }, SetOptions(merge: true))
        .then((value) => print('New field added to document'))
        .catchError((error) => print('Failed to add new field: $error'));

    print('ticket iD: $constTicketId');
    FirebaseFirestore.instance
        .collection('messages')
        .doc('$constTicketId')
        .collection('texts')
        .add({
      'receiverAdminId' : 'e3aae445-314b-4acd-9559-e61f3caeb958',
      'ticketid' : constTicketId,
      'userid' :userID,
      'text': message,
      'description': message,
      // 'timestamp': FieldValue.serverTimestamp(),
      //  'timestamp': '${timestamp}'
      'profilepic': userImage,
      'username': name,
      'type': 'in',
      'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
    })
        .then((value) => print("Message saved"))
        .catchError((error) => print("Failed to save message: $error"));
  }
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
          // SizedBox(height: 26.h),
          // FormHelper.inputFieldWidgetWithController(
          //     context, AppTextConstants.ticketNo, AppTextConstants.ticketNo,
          //     (String onValidateValue) {
          //   if (onValidateValue.isEmpty) {
          //     return '${AppTextConstants.ticketNo} cannot be empty';
          //   }

          //   return null;
          // }, (String onSavedValue) {
          //       _ticketNo = onSavedValue.trim();
          // },
          //     separatorHeight: 15,
          //     controller: _ticketNoController,
          //     inputPlaceholder: AppTextConstants.writeHere),
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
          loading == true
              ? Center(child: CircularProgressIndicator())
              : ButtonRoundedGradient(
                  buttonText: AppTextConstants.submit,
                  buttonCallback: createTicket),
          SizedBox(height: 26.h),
        ],
      );

  void createTicket() {
    print('hererere description');
    print('hererere description:' + _descriptionController.text);

    // Navigator.of(context).pop();
    if (validateAndSave()) {
      debugPrint('send ticket... $_subject $_ticketNo $_description');
    }
  }

  void _showToast(BuildContext context, String message) {
    Fluttertoast.showToast(
        msg: "$message",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.grey,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        textColor: Colors.white,
        fontSize: 16.0);
    // ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text(message), duration: const Duration(seconds: 1)));
  }

  bool validateAndSave() {
    final FormState? form = createTicketFormGlobalKey.currentState;
    if (form!.validate()) {
      setState(() {
        loading = true;
      });
      BaseHelper()
          .addSupport(_subjectController.text.toString().trim(), _descriptionController.text.toString().trim(), context).then((value) {

        if (value.toString().contains("id")) {
          String id = ticketResponseModel.id.toString();
          print('idddddd ticket ' + id);
          saveMessage(id, _descriptionController.text);
          AppRoutes.replace(context, SupportScreen());
        } else {
          _showToast(context, "Something went Wrong!");
        }
        print("add new ticket response: ${value.toString()}");
        setState(() {
          loading = false;
        });
      });
      // BaseHelper().getFaq(context).then((value) {
      //   print("add new ticket response: ${value.successResponse}");
      // });
      form.save();
      return true;
    }
    return false;
  }
}

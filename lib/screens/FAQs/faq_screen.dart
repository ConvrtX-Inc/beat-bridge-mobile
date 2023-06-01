import 'package:accordion/accordion.dart';
import 'package:accordion/controllers.dart';
import 'package:beatbridge/helpers/basehelper.dart';
import 'package:beatbridge/models/faqsmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../constants/app_constants.dart';

class FAQ_Screen extends StatefulWidget {
  const FAQ_Screen();
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return _FAQ_Screen();
  }
}

class _FAQ_Screen extends State<FAQ_Screen> {
  List<FaqResult> faqResult = [];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    BaseHelper().getFAQ(context).then((value) {
      setState(() {
        faqResult = value;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColorConstants.mirage,
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 22.w),
              child:
                  Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                SizedBox(height: 41.h),
                IconButton(
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                    icon: Icon(
                      Icons.arrow_back_ios,
                      color: AppColorConstants.roseWhite,
                      size: 15.w,
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    }),
                SizedBox(height: 26.h),
                Text(
                  AppTextConstants.FAQ,
                  style: TextStyle(
                      fontWeight: FontWeight.w700,
                      color: AppColorConstants.roseWhite,
                      fontFamily: 'Gilroy-Bold',
                      fontSize: 22.sp),
                ),
                SizedBox(height: 16.h),
                Text(
                  "How can we help you?",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      color: AppColorConstants.roseWhite,
                      fontFamily: 'Gilroy-Bold',
                      fontSize: 24.sp),
                ),
                SizedBox(height: 16.h),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemBuilder: (context, int index) {
                    return Column(
                      children: [
                        Accordion(
                            maxOpenSections: 2,
                            headerBackgroundColorOpened:
                                AppColorConstants.mirage,
                            scaleWhenAnimating: true,
                            openAndCloseAnimation: true,
                            headerPadding: const EdgeInsets.symmetric(
                                vertical: 7, horizontal: 15),
                            sectionOpeningHapticFeedback:
                                SectionHapticFeedback.heavy,
                            sectionClosingHapticFeedback:
                                SectionHapticFeedback.light,
                            children: [
                              AccordionSection(
                                rightIcon: const Icon(Icons.add_outlined,
                                    color: Color.fromARGB(255, 253, 244, 244)),
                                isOpen: false,
                                contentBorderColor: AppColorConstants.mirage,

                                contentBorderRadius: 0,
                                // leftIcon: const Icon(Icons.insights_rounded, color: Colors.white),
                                headerBackgroundColor: AppColorConstants.mirage,
                                headerBackgroundColorOpened:
                                    AppColorConstants.mirage,
                                header: Text('${faqResult[index].question}?',
                                    style: TextStyle(
                                        color: AppColorConstants.roseWhite,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700)),
                                contentBackgroundColor:
                                    AppColorConstants.mirage,
                                content: Text("${faqResult[index].description}",
                                    style: TextStyle(
                                        color: AppColorConstants.roseWhite,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w400)),
                                contentHorizontalPadding: 20,
                                contentBorderWidth: 0,
                                // onOpenSection: () => print('onOpenSection ...'),
                                // onCloseSection: () => print('onCloseSection ...'),
                              ),
                            ]),
                        Divider(
                          color: AppColorConstants.roseWhite,
                        ),
                      ],
                    );
                  },
                  itemCount: faqResult.length,
                )
              ])),
        ));
  }
}

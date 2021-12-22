import 'package:beatbridge/constants/app_constants.dart';
import 'package:beatbridge/constants/asset_path.dart';
import 'package:beatbridge/models/recent_queue_model.dart';
import 'package:beatbridge/utils/services/static_data_service.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

///All Queue Screen
class AllQueueScreen extends StatefulWidget {
  ///Constructor
  const AllQueueScreen({Key? key}) : super(key: key);

  @override
  _AllQueueScreenState createState() => _AllQueueScreenState();
}

class _AllQueueScreenState extends State<AllQueueScreen> {
  final List<RecentQueueModel> queueList = StaticDataService.getRecentQueues();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColorConstants.mirage,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.w),
        child:   buildAllQueuesUI(),
      ),
    );
  }

  Widget buildAllQueuesUI() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SizedBox(height: 41.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.w),
          child: IconButton(icon: Icon(Icons.arrow_back_ios,color: AppColorConstants.roseWhite,),onPressed: (){
            Navigator.of(context).pop();
          },)
        ),
        SizedBox(height: 36.h),
        Padding(
            padding: EdgeInsets.symmetric(horizontal: 11.w),
            child: Text(
              AppTextConstants.allQueues,
              style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: AppColorConstants.roseWhite,
                  fontSize: 22),
            )),
        SizedBox(height: 26.h),
        Expanded(child:buildQueueItemList())
      ]);
  }

  Widget buildQueueItemList(){
    return ListView.builder(
      padding: EdgeInsets.symmetric(horizontal: 11.w),
      itemCount: queueList.length,
      itemBuilder: (BuildContext context , int index){
        return buildQueueItem(index);
      },
    );
  }


  Widget buildQueueItem(int index) {
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return AppColorConstants.roseWhite;
      }
      return AppColorConstants.artyClickPurple;
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(height: 24.h),
          Row(
            children: <Widget>[
              Padding(
                  padding: EdgeInsets.fromLTRB(0, 0, 20.h, 0),
                  child: Container(
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          image: DecorationImage(
                            image:
                            AssetImage(queueList[index].thumbnailUrl),
                            fit: BoxFit.fitHeight,
                          )),
                      child: Align(
                          child: Image.asset(
                              '${AssetsPathConstants.assetsPNGPath}/${AssetsNameConstants.playButtonImage}')))),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(queueList[index].name,
                      style: TextStyle(
                          color: AppColorConstants.roseWhite,
                          fontWeight: FontWeight.w600,
                          fontSize: 18.sp)),
                  SizedBox(height: 8.h),
                  Text('${queueList[index].totalSongs} Songs',
                      style: TextStyle(
                          color: AppColorConstants.paleSky, fontSize: 13)),
                  SizedBox(height: 8.h),
                  buildMusicPlatformsUsedRow(context, index)
                ],
              ),
              const Spacer(),
              Transform.scale(
                  scale: 1.5,
                  child: Checkbox(
                      value: queueList[index].isSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          queueList[index].isSelected = value!;
                        });
                      },
                      checkColor: AppColorConstants.rubberDuckyYellow,
                      fillColor: MaterialStateProperty.resolveWith(getColor),
                      side: MaterialStateBorderSide.resolveWith(
                            (Set<MaterialState> states) => BorderSide(
                          width: 2,
                          color: AppColorConstants.paleSky,
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5))))
            ],
          ),
          SizedBox(height: 14.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                'Created by: ${queueList[index].createdBy}',
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 16.sp),),
              Text(
                queueList[index].createdAt,
                style: TextStyle(
                    color: AppColorConstants.paleSky,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1,
                    fontSize: 14.sp),)
            ],
          ),
          SizedBox(height: 16.h),
          Divider(color: AppColorConstants.paleSky,)
        ]);
  }

  Widget buildMusicPlatformsUsedRow(BuildContext context, int index) {
    return Column(children: <Widget>[
      Row(
        children: <Widget>[
          for (int i = 0; i < queueList[index].musicPlatformsUsed.length; i++)
            Padding(padding:EdgeInsets.symmetric(horizontal: 2.w),child:Image(
                image: AssetImage(
                    queueList[index].musicPlatformsUsed[i].logoImagePath),
                height: 18,
                width: 18)),

        ],
      )
    ]);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IterableProperty<RecentQueueModel>('queueList', queueList));
  }
}

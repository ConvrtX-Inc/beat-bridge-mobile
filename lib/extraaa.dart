// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_secure_storage/flutter_secure_storage.dart';
// import 'package:intl/intl.dart';
//
// import '../../constants/app_constants.dart';
// import '../../constants/constantsclass.dart';
// import '../../helpers/basehelper.dart';
// import '../../models/support/support_model.dart';
// import '../../models/users/user_model.dart';
//
// int i = 0;
// //https://beat.softwarealliancetest.tk${UserSingleton.instance.profileImage}
//
// class SupportThreadScreen extends StatefulWidget {
//   const SupportThreadScreen({super.key});
//
//
//   @override
//   SupportThreadScreenState createState() => SupportThreadScreenState();
// }
//
// class SupportThreadScreenState extends State<SupportThreadScreen> {
//   final chatMsgTextController = TextEditingController();
// /////////
//   var timestamp = DateTime.now().millisecondsSinceEpoch;
// ///////////
//   void saveMessage(String message) async{
//     final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
//     var userID = await secureStorage.read(key: 'userID');
//     final String? name = await secureStorage.read(key: 'username');
//
//     FirebaseFirestore.instance
//         .collection('messages')
//     // .doc('$userID').
//     //  .collection('ticketid').
//         .doc('$constTicketId')
//         .collection('texts')
//         .add({
//       'receiverAdminId' : 'e3aae445-314b-4acd-9559-e61f3caeb958',
//       'ticketid' : constTicketId,
//       'description' : constDescription,
//       'userid' :userID,
//       'text': message,
//       'profilepic': 'https://beat.softwarealliancetest.tk${UserSingleton.instance.profileImage}',
//       'username': name,
//       'type': 'in',
//       // 'timestamp': FieldValue.serverTimestamp(),
//       //  'timestamp': '${timestamp}'
//       'timestamp': DateTime.now().millisecondsSinceEpoch.toString(),
//     })
//         .then((value) => print("Message saved"))
//         .catchError((error) => print("Failed to save message: $error"));
//   }
//
//   // final _auth = FirebaseAuth.instance;
//   var userID;
//   @override
//   void initState() {
//     super.initState();
//     getuserId();
//   }
//
//   getuserId()async{
//     final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
//     await secureStorage.read(key: 'userID').then((value) {
//       setState(() {
//         userID=value;
//       });
//     });
//   }
//
//   List<SupportListModel> supportList = <SupportListModel>[];
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: AppColorConstants.mirage,
//
//       appBar: AppBar(
//         iconTheme:  IconThemeData(color: Colors.white),
//         elevation: 0,
//         automaticallyImplyLeading: false,
//         backgroundColor: Colors.white10,
//         title: Row(
//           children: <Widget>[
//             SizedBox(width: 8,),
//             IconButton(
//               padding: EdgeInsets.zero,
//               constraints: const BoxConstraints(),
//               icon: Icon(Icons.arrow_back_ios,color: AppColorConstants.roseWhite,),onPressed: (){
//               Navigator.of(context).pop();
//             },
//             ),
//             SizedBox(width: 15,),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: const <Widget>[
//                 Text(
//                   'BeatBridge',
//                   style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 18,
//                       color: Colors.white),
//                 ),
//                 Text('by spotify',
//                     style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 10,
//                         color: Colors.white))
//               ],
//             ),
//           ],
//         ),
//       ),
//       body: Column(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         crossAxisAlignment: CrossAxisAlignment.stretch,
//         children: <Widget>[
//           ChatStream(
//
//             userID,
//           ),
//           Container(
//             // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//             padding:  EdgeInsets.only(left: 10, right: 10, top: 10, bottom: 30),
//             decoration: kMessageContainerDecoration,
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: <Widget>[
//                 Expanded(
//                   child: Material(
//                     borderRadius: BorderRadius.circular(50),
//                     color: Colors.white,
//                     elevation: 5,
//                     child: Padding(
//                       padding:
//                       const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
//                       child: TextField(
//                         onChanged: (value) {},
//                         controller: chatMsgTextController,
//                         decoration: kMessageTextFieldDecoration,
//                       ),
//                     ),
//                   ),
//                 ),
//                 MaterialButton(
//                   shape: const CircleBorder(),
//                   color: AppColorConstants.violet,
//                   onPressed: (){
//                     saveMessage(chatMsgTextController.text);
//                     chatMsgTextController.clear();
//                   },
//                   child:  Padding(
//                     padding: EdgeInsets.all(10.0),
//                     child: Icon(
//                       Icons.send,
//                       color: Colors.white,
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
//   Widget ChatStream(userId){
//     return StreamBuilder<QuerySnapshot>(
//       stream: FirebaseFirestore.instance
//           .collection('messages')
//       // .doc('${userId}').//////user id
//       //  collection('ticketid').
//           .doc('${constTicketId}')
//           .collection('texts')
//           .orderBy('timestamp', descending: true)
//       // .limit(20)
//           .snapshots(),
//       builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
//         print("my snapshot data: ${snapshot.data!.docs.length}");
//         if (!snapshot.hasData) {
//           return  Center(child: CircularProgressIndicator());
//         }
//         return Expanded(
//           child: ListView.builder(
//             reverse: true,
//             shrinkWrap: true,
//             itemCount: snapshot.data!.docs.length,
//             itemBuilder: (BuildContext context, int index) {
//               // DateTime timestamp = DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]["timestamp"].toString()) ?? 1000000);
//               // String formattedTimex = DateFormat('h:mm a').format(timestamp);
//               return snapshot.data!.docs[index]['userid'].toString()!=userId.toString()?
//               Container(
//                 height: 0,
//                 width: 0,
//               )
//                   :
//               Padding(
//                 padding:  EdgeInsets.all(12.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Material(
//                       borderRadius: BorderRadius.only(
//                         bottomLeft: Radius.circular(50),
//                         topLeft: Radius.circular(50) ,
//                         bottomRight: Radius.circular(50),
//                         topRight:Radius.circular(0),
//                       ),
//                       color: AppColorConstants.violet,
//                       elevation: 5,
//                       child: Padding(
//                         padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//                         child: Text(
//                           snapshot.data!.docs[index]['text'],
//                           style: TextStyle(
//                             color:  Colors.white,
//                             fontFamily: 'Poppins',
//                             fontSize: 15,
//                           ),
//                         ),
//                       ),
//                     ),
//                     SizedBox(height: 5,),
//                     Container(
//                       padding: EdgeInsets.symmetric(horizontal: 10),
//
//                       // child:  Text('${formattedTimex}',
//                       // child:Text(snapshot.data!.docs[index]['timestamp'].toString(),
//                       child: Text(
//                         // DateFormat('dd MMM yyyy, hh:mm a').format(
//                         DateFormat('h:mm a').format(
//                           DateTime.fromMillisecondsSinceEpoch(
//                             int.parse(snapshot.data!.docs[index]['timestamp'].toString()),
//                           ),
//                         ),
//                         style: TextStyle(
//                           color:  Colors.white54,
//                           fontFamily: 'Poppins',
//                           fontSize: 10,
//                         ),),
//                       // subtitle: Text(snapshot.data!.docs[index]['timestamp'].toString(),
//                       //  DateTime.now().millisecondsSinceEpoch
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         );
//
//
//       },
//     );
//   }
// }
//
// const kSendButtonTextStyle = TextStyle(
//   color: Colors.lightBlueAccent,
//   fontWeight: FontWeight.bold,
//   fontSize: 18.0,
// );
//
// const kMessageTextFieldDecoration = InputDecoration(
//   contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
//   hintText: 'Type your message here...',
//   hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14),
//   border: InputBorder.none,
// );
//
// const kMessageContainerDecoration = BoxDecoration(
//   // border: Border(
//   //   top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
//   // ),
// );
// // '${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]["timestamp"].toString()) ?? 1000000).hour}:${DateTime.fromMillisecondsSinceEpoch(int.parse(snapshot.data!.docs[index]["timestamp"].toString()) ?? 1000000).minute}'
// // Text('${formattedTimex}',
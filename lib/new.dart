import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';



final _firestore = FirebaseFirestore.instance;
String username = 'User';
String email = 'user@example.com';
String ? messageText;

class ChatterScreen extends StatefulWidget {
  const ChatterScreen({super.key});

  @override
  ChatterScreenState createState() => ChatterScreenState();
}

class ChatterScreenState extends State<ChatterScreen> {
  final chatMsgTextController = TextEditingController();

  void saveMessage(String message) async{
    final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
   var userID = await secureStorage.read(key: 'userID');
    FirebaseFirestore.instance
        .collection('messages')
        .doc('$userID')
        .collection('texts')
        .add({
      'text': message,
      'timestamp': FieldValue.serverTimestamp(),
    })
        .then((value) => print("Message saved"))
        .catchError((error) => print("Failed to save message: $error"));
  }

  // final _auth = FirebaseAuth.instance;
var userID;
  @override
  void initState() {
    super.initState();
    getuserId();
    }

getuserId()async{
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();
  userID = await secureStorage.read(key: 'userID');
}
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Colors.deepPurple),
        elevation: 0,
        bottom: PreferredSize(
          preferredSize: const Size(25, 10),
          child: Container(
            decoration: const BoxDecoration(
              // color: Colors.blue,

              // borderRadius: BorderRadius.circular(20)
            ),
            constraints: const BoxConstraints.expand(height: 1),
            // child: LinearProgressIndicator(
            //   valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            //   backgroundColor: Colors.blue[100],
            // ),
          ),
        ),
        backgroundColor: Colors.white10,
        title: Row(
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const <Widget>[
                Text(
                  'BeatBridge',
                  style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 16,
                      color: Colors.deepPurple),
                ),
                Text('by spotify',
                    style: TextStyle(
                        fontFamily: 'Poppins',
                        fontSize: 8,
                        color: Colors.deepPurple))
              ],
            ),
          ],
        ),
        actions: <Widget>[
          GestureDetector(
            child: const Icon(Icons.more_vert),
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          ChatStream(

            userId: userID,
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            decoration: kMessageContainerDecoration,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Expanded(
                  child: Material(
                    borderRadius: BorderRadius.circular(50),
                    color: Colors.white,
                    elevation: 5,
                    child: Padding(
                      padding:
                      const EdgeInsets.only(left: 8.0, top: 2, bottom: 2),
                      child: TextField(
                        onChanged: (value) {},
                        controller: chatMsgTextController,
                        decoration: kMessageTextFieldDecoration,
                      ),
                    ),
                  ),
                ),
                MaterialButton(
                  shape: const CircleBorder(),
                  color: Colors.blue,
                  onPressed: (){
                    saveMessage(chatMsgTextController.text);
                    chatMsgTextController.clear();
                  },
                  child:  Padding(
                    padding: EdgeInsets.all(10.0),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatStream extends StatelessWidget {
var userId;
ChatStream({required this.userId});
  Stream<QuerySnapshot> getMessages() {

    return FirebaseFirestore.instance
        .collection('messages')
        .doc('$userId')  //////user id
        .collection('texts')
        .orderBy('timestamp', descending: true)
        .limit(20)
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getMessages(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (!snapshot.hasData) {
          return const CircularProgressIndicator();
        }
        List<QueryDocumentSnapshot> documents = snapshot.data!.docs;
        return Expanded(
          child: ListView.builder(
            reverse: true,
            shrinkWrap: true,
            itemCount: documents.length,
            itemBuilder: (BuildContext context, int index) {
              return Padding(
                padding:  EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Material(
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(50),
                        topLeft: Radius.circular(50) ,
                        bottomRight: Radius.circular(50),
                        topRight:Radius.circular(0),
                      ),
                      color:  Colors.blue,
                      elevation: 5,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: Text(
                       documents[index]['text'],
                          style: TextStyle(
                            color:  Colors.white,
                            fontFamily: 'Poppins',
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(DateTime.now().toString()),
                      // subtitle: Text(documents[index]['timestamp'].toString()),
                    //  DateTime.now().millisecondsSinceEpoch
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

// class MessageBubble extends StatelessWidget {
//   const MessageBubble({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(12.0),
//       child: Column(
//         // crossAxisAlignment: user ? CrossAxisAlignment.end : CrossAxisAlignment.start,
//         children: <Widget>[
//           Container(
//             padding: const EdgeInsets.symmetric(horizontal: 10),
//             child: const Text(
//               'Sender',
//               style: TextStyle(
//                   fontSize: 13, fontFamily: 'Poppins', color: Colors.black87),
//             ),
//           ),
//           const Material(
//             // borderRadius: BorderRadius.only(
//             //   bottomLeft: Radius.circular(50),
//             //   topLeft: user ? Radius.circular(50) : Radius.circular(0),
//             //   bottomRight: Radius.circular(50),
//             //   topRight: user ? Radius.circular(0) : Radius.circular(50),
//             // ),
//             // color: user ? Colors.blue : Colors.white,
//             elevation: 5,
//             child: Padding(
//               padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               child: Text(
//                 'Admin',
//                 style: TextStyle(
//                   // color: user ? Colors.white : Colors.blue,
//                   fontFamily: 'Poppins',
//                   fontSize: 15,
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

const kSendButtonTextStyle = TextStyle(
  color: Colors.lightBlueAccent,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

const kMessageTextFieldDecoration = InputDecoration(
  contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
  hintText: 'Type your message here...',
  hintStyle: TextStyle(fontFamily: 'Poppins', fontSize: 14),
  border: InputBorder.none,
);

const kMessageContainerDecoration = BoxDecoration(
  // border: Border(
  //   top: BorderSide(color: Colors.lightBlueAccent, width: 2.0),
  // ),

);
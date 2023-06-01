import 'package:flutter/material.dart';

class SeeAllQueues extends StatefulWidget {
  const SeeAllQueues({Key? key}) : super(key: key);

  @override
  State<SeeAllQueues> createState() => _SeeAllQueuesState();
}

class _SeeAllQueuesState extends State<SeeAllQueues> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView.separated(
          separatorBuilder: (context, index) => Divider(
            color: Colors.black,
          ),
          itemCount: 20,
          itemBuilder: (context, index) => Padding(
            padding: EdgeInsets.all(8.0),
            child: Center(child: Text("Index $index")),
          ),
        )
      ),
    );
  }
}

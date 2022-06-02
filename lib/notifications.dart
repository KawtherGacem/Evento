import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:  AppBar(
        leading: BackButton(
          color: Color(0xFF50519E),
          onPressed: (){
            Get.off(context);
          },
        ),
        centerTitle: true,
        title: Container(
            alignment: Alignment.center,
            width: 125,
            // margin: EdgeInsets.only(left: 10),
            child: Text("Notifications",
              style: const TextStyle(color: Color(0xFF50519E),
                  fontSize: 35,fontWeight: FontWeight.bold
              ),)
          // Image.asset("assets/logotwil.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),

    );
  }
}

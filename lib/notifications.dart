import 'package:evetoapp/dashboard.dart';
import 'package:evetoapp/homePage.dart';
import 'package:evetoapp/providers/eventProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:provider/provider.dart';

import 'models/Event.dart';

class Notifications extends StatefulWidget {
  const Notifications({Key? key}) : super(key: key);

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {

  List<Event> events=[] ;


  @override
  Widget build(BuildContext context) {

    final EventProvider = Provider.of<eventProvider>(context);

    GetNotifications(){
      events =EventProvider.favoriteEvents.where((element) => element.startingDate!.toDate().difference(DateTime.now())<Duration(days: 7)).toList();
    };
    GetNotifications();
    return Scaffold(
      appBar:  AppBar(
        leading: BackButton(
          color: Color(0xFF50519E),
          onPressed: (){
            Get.to(Dashboard(user: FirebaseAuth.instance.currentUser!,));
          },
        ),
        centerTitle: true,
        title: Container(
            alignment: Alignment.center,
            width: 150,
            // margin: EdgeInsets.only(left: 10),
            child: Text("Notifications",
              style: const TextStyle(color: Color(0xFF50519E),
                  fontSize: 25,fontWeight: FontWeight.bold
              ),)
          // Image.asset("assets/logotwil.png"),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: ListView.builder(
        itemCount: events.length,

          itemBuilder: (BuildContext context,index){
            return Column(
              children: [
                (ListTile(
                  title: Text("il reste "+events[index].startingDate!.toDate().difference(DateTime.now()).inDays.toString()+
                   " jours a l'événement"+ events[index].title!+" ne le ratez pas."              ),

                )),
                Divider()
              ],
            );

          }),
    );
  }
}

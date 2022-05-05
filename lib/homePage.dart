
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'eventPage.dart';


class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>  {
  FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
            leadingWidth: 200,
            leading: Container(
              margin: EdgeInsets.only(left: 10),
              child: Image.asset("assets/logotwil.png"),
            ),
            elevation: 0,
            backgroundColor: Colors.white,
            // title: ,
            //   ,
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFF513ADA),
                ), onPressed: () {  },
              ),
              CircleAvatar(
                radius: 20,
                backgroundImage: Image.network(_auth.currentUser?.photoURL ?? "").image,

              ),
            ],
        ),
        Container(
          child: Flexible(
            child: Column(
              mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Text('All',
                        textAlign: TextAlign.start,
                        style: TextStyle(color: Colors.black)
                    ),
                  ),
                  Expanded(
                    child: FutureBuilder(
                      future: getEvents(),
                      builder: (context,AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (context, index) {
                                return Card(
                                  child: GestureDetector(
                                      child: Container(
                                          child: Column(
                                            children: [
                                              // Image(image: Image.network(snapshot.data[index].data()["photoUrl"]).image),
                                              Text(snapshot.data[index].data()["title"],),
                                            ],
                                          )),
                                      onTap: (){
                                          Get.to(EventPage(event: snapshot.data[index]));
                                        },
                                      ),
                                );
                          });
                        } else
                          if (snapshot.hasError) {
                          return Text('${snapshot.error}');
                        }
                        // By default, show a loading spinner.
                        return Center(
                          heightFactor: 50,
                            widthFactor: 50,
                            child: CircularProgressIndicator(semanticsLabel: "Loading events...",
                              strokeWidth: 2,color: Colors.black,));
                      },
                    ),
                    // child: ListView.builder(
                    //   itemCount: 10,
                    //   itemBuilder: (BuildContext ctx, int index) {
                    //     return Card(
                    //       shape: RoundedRectangleBorder(
                    //         borderRadius: BorderRadius.circular(20)
                    //       ),
                    //       child: Text("testing testing "),
                    //     );
                    //   },
                    // ),
                  )
                ]
            ),
          ),

        )


      ],
    );
  }
  Future getEvents() async {
    var firestore = FirebaseFirestore.instance;
    QuerySnapshot qn =await firestore.collection("events").get();
    return qn.docs;
  }
  }



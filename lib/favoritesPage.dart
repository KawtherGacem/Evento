import 'package:evetoapp/providers/eventProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'eventPage.dart';

class FavoutitesPage extends StatefulWidget {
  const FavoutitesPage({Key? key}) : super(key: key);

  @override
  State<FavoutitesPage> createState() => _FavoutitesPageState();
}

class _FavoutitesPageState extends State<FavoutitesPage> {

  FirebaseAuth _auth = FirebaseAuth.instance;


  @override
  Widget build(BuildContext context) {
    final EventProvider = Provider.of<eventProvider>(context);

    return Scaffold(
        // key: _scaffoldKey,
        // drawer: Drawer(
        //   child: SingleChildScrollView(
        //     child: Container(
        //       child: Column(
        //         children: [
        //           ProfileScreen(),
        //
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        appBar:  AppBar(
          leading: IconButton(
            icon:  CircleAvatar(
              radius: 15,
              backgroundImage: Image
                  .network(
                _auth.currentUser?.photoURL ?? "", fit: BoxFit.fitWidth,)
                  .image,
            ), onPressed: () {  },
            // onPressed: () => _scaffoldKey.currentState?.openDrawer(),


          ),

          leadingWidth: 50,
          centerTitle: true,
          title: Container(
            width: 125,
            // margin: EdgeInsets.only(left: 10),
            child: Image.asset("assets/logotwil.png"),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          // title: ,
          //   ,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Color(0xFF513ADA),
                size: 35,
              ), onPressed: () {},
            ),
          ],
        ),
        body:  RefreshIndicator(
          onRefresh: () { return EventProvider.loadEvents(); },
          child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, left: 10),
                  child: Text('All',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black,)
                  ),
                ),
                // if (currentLocation != null &&
                // currentAddress != null)
                // Text(currentAddress!,),
                // Flexible(
                //   child: FutureBuilder(
                //     future: getEvents(),
                //     builder: (context, AsyncSnapshot snapshot) {
                //       if (snapshot.hasData) {
                //         return
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: ListView.builder(
                          padding: EdgeInsets.only(top: 0),
                          itemCount: EventProvider.events.length,
                          itemBuilder: (context, index) {
                            return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15)
                                ),
                                margin: EdgeInsets.only(bottom: 20),
                                elevation: 2,
                                child: GestureDetector(
                                  child: Container(
                                      height: 270,
                                      child: Column(
                                        children: [
                                          Stack(
                                            // fit: StackFit.
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius
                                                    .only(
                                                  topLeft: Radius
                                                      .circular(
                                                      15.0),
                                                  topRight: Radius
                                                      .circular(
                                                      15.0),
                                                  // bottomRight: Radius
                                                  //     .circular(25.0),
                                                  // bottomLeft: Radius
                                                  //     .circular(25.0),
                                                ),
                                                child: Container(
                                                  height: 200,
                                                  width: 372,
                                                  child: Image(
                                                    image: Image
                                                        .network(
                                                        EventProvider
                                                            .events[index]
                                                            .photoUrl!)
                                                        .image,
                                                    fit: BoxFit.cover,
                                                    color: Colors.black54
                                                        .withOpacity(0.1),
                                                    colorBlendMode: BlendMode
                                                        .colorBurn,
                                                    frameBuilder: (
                                                        BuildContext context,
                                                        Widget child,
                                                        int? frame,
                                                        bool wasSynchronouslyLoaded) {
                                                      if (wasSynchronouslyLoaded ||
                                                          frame != null) {
                                                        return Container(
                                                          child: child,
                                                          foregroundDecoration: const BoxDecoration(
                                                              gradient: LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    Color(
                                                                        0xCC000000),
                                                                    Color(
                                                                        0x00000000),
                                                                    Color(
                                                                        0x00000000),

                                                                    Color(
                                                                        0xA6000000),
                                                                    Color(
                                                                        0xD5000000),
                                                                  ]
                                                              )
                                                          ),
                                                          height: 220,
                                                          width: double
                                                              .infinity,
                                                        );
                                                      } else {
                                                        return Container(
                                                          child: CircularProgressIndicator(
                                                              color: Colors
                                                                  .grey,
                                                              value: null,
                                                              backgroundColor: Colors
                                                                  .white),
                                                          alignment: Alignment(
                                                              0, 0),
                                                          constraints: BoxConstraints
                                                              .expand(),
                                                        );
                                                      }
                                                    },
                                                    // loadingBuilder: (BuildContext context, Widget child,
                                                    // ImageChunkEvent? loadingProgress) {
                                                    // if (loadingProgress == null) {
                                                    // return child;
                                                    // }
                                                    // return Center(
                                                    // child: CircularProgressIndicator(
                                                    //       value: loadingProgress.expectedTotalBytes != null
                                                    //       ? loadingProgress.cumulativeBytesLoaded /
                                                    //       loadingProgress.expectedTotalBytes!
                                                    //           : null,),
                                                    //     );}),
                                                  ),
                                                ),
                                              ),

                                              Positioned(
                                                bottom: 15,
                                                left: 13,
                                                right: 20,
                                                child: Text(EventProvider
                                                    .events[index].title!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight: FontWeight
                                                          .w800,
                                                      fontFamily: "Lato"),),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(25)),
                                            height: 30,
                                            child: Row(
                                              children: [
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  onTap: () {
                                    Get.to(EventPage(
                                        event: EventProvider
                                            .events[index]));
                                  },

                                )
                              //   } else if (snapshot.hasError) {
                              //     return Text('${snapshot.error}');
                              //   }
                              //   // By default, show a loading spinner.
                              //   return Center(
                              //       heightFactor: 50,
                              //       widthFactor: 50,
                              //       child: CircularProgressIndicator(
                              //         semanticsLabel: "Loading events...",
                              //         strokeWidth: 2, color: Colors.black,));
                              // },
                            );

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
                          })
                  ),
                )]
          ),
        )


    );
  }

}

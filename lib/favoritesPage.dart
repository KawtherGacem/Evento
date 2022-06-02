import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/models/Event.dart';
import 'package:evetoapp/providers/eventProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'controllers/eventController.dart';
import 'eventPage.dart';

class FavoutitesPage extends StatefulWidget {
  const FavoutitesPage( {Key? key}) : super(key: key);

  @override
  State<FavoutitesPage> createState() => _FavoutitesPageState();
}

class _FavoutitesPageState extends State<FavoutitesPage> {

  // FirebaseAuth _auth = FirebaseAuth.instance;
  late List<Event> favorites ;
  EventController eventController = EventController();

  void initState() {
    eventController.loadEvents();
    GetFav();
    super.initState();
  }
 void GetFav() async{
    favorites = await eventController.getFavorites();

 }
  @override
  Widget build(BuildContext context) {



    return Scaffold(
        appBar:  AppBar(
          centerTitle: true,
          title: Container(
            alignment: Alignment.center,
            width: 125,
            // margin: EdgeInsets.only(left: 10),
            child: Text("Favoris",
              style: const TextStyle(color: Color(0xFF50519E),
              fontSize: 35,fontWeight: FontWeight.bold
            ),)
            // Image.asset("assets/logotwil.png"),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
        ),

        body:  Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10, left: 25,bottom: 5),
                child: Text('Vos événements favoris',
                    textAlign: TextAlign.start,
                    style: TextStyle(color: Colors.black,)
                ),
              ),
              Flexible(
                child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 25),
                    child: ListView.builder(
                        physics: BouncingScrollPhysics(),
                        padding: EdgeInsets.only(top: 0),
                        itemCount: favorites.length,
                        itemBuilder: (context, index) {
                          return Card(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                              margin: EdgeInsets.only(bottom: 20),
                              elevation: 2,
                              child: GestureDetector(
                                child: SizedBox(
                                    height: 260,
                                    child: Column(
                                      children: [
                                        Stack(
                                          // fit: StackFit.
                                          children: [
                                            ClipRRect(
                                              borderRadius:
                                              const BorderRadius.only(
                                                topLeft: Radius.circular(15.0),
                                                topRight: Radius.circular(15.0),
                                                // bottomRight: Radius
                                                //     .circular(25.0),
                                                // bottomLeft: Radius
                                                //     .circular(25.0),
                                              ),
                                              child: SizedBox(
                                                height: 200,
                                                width: 372,
                                                child: Image(
                                                  image: Image.network(
                                                      favorites[index]
                                                          .photoUrl!)
                                                      .image,
                                                  fit: BoxFit.cover,
                                                  color: Colors.black54
                                                      .withOpacity(0.1),
                                                  colorBlendMode:
                                                  BlendMode.colorBurn,
                                                  frameBuilder: (BuildContext
                                                  context,
                                                      Widget child,
                                                      int? frame,
                                                      bool
                                                      wasSynchronouslyLoaded) {
                                                    if (wasSynchronouslyLoaded ||
                                                        frame != null) {
                                                      return Container(
                                                        child: child,
                                                        foregroundDecoration:
                                                        const BoxDecoration(
                                                            gradient: LinearGradient(
                                                                begin: Alignment
                                                                    .topCenter,
                                                                end: Alignment
                                                                    .bottomCenter,
                                                                colors: [
                                                                  Color(0x00000000),
                                                                  Color(0x00000000),
                                                                  Color(0x00000000),
                                                                  Color(0x94000000),
                                                                  Color(0xD5000000),
                                                                ])),
                                                      );
                                                    } else {
                                                      return Container(
                                                        child:
                                                        CircularProgressIndicator(
                                                            color:
                                                            Colors.grey,
                                                            value: null,
                                                            backgroundColor:
                                                            Colors.white),
                                                        alignment:
                                                        Alignment(0, 0),
                                                        constraints:
                                                        BoxConstraints
                                                            .expand(),
                                                      );
                                                    }
                                                  },
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              bottom: 15,
                                              left: 13,
                                              right: 20,
                                              child: Text(
                                                favorites[index].title!,
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 17,
                                                    fontWeight: FontWeight.w800,
                                                    fontFamily: "Lato"),
                                              ),
                                            ),
                                            Positioned(
                                                right: 10,
                                                top: 10,
                                                child: CircleAvatar(
                                                  backgroundColor:
                                                  Color(0x57000000),
                                                  child: Padding(
                                                    padding:
                                                    EdgeInsets.only(left: 4),
                                                    child: LikeButton(
                                                      animationDuration: Duration(
                                                          milliseconds: 3000),
                                                      isLiked: eventController.events[index].likes
                                                          .contains(FirebaseAuth
                                                          .instance
                                                          .currentUser!
                                                          .uid),
                                                      onTap: (isLiked) async {
                                                        await addToFavorites(
                                                            eventController.events[index]
                                                                .id,
                                                            isLiked);
                                                        if (isLiked) {
                                                          eventController.events[index].likes
                                                              .remove(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid);
                                                        }else{
                                                          eventController.events[index].likes
                                                              .add(FirebaseAuth
                                                              .instance
                                                              .currentUser!
                                                              .uid);
                                                        }
                                                        setState((){
                                                          eventController.getFavorites();
                                                          favorites=eventController.favorites;
                                                        });

                                                        // final success =
                                                        //     await addToFavorites(
                                                        //         EventProvider
                                                        //             .events[index]
                                                        //             .id,
                                                        //         isLiked);
                                                        // EventProvider
                                                        //     .loadEvents();
                                                        return !isLiked;
                                                      },
                                                    ),
                                                  ),
                                                ))
                                          ],
                                        ),
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                              BorderRadius.circular(25)),
                                          height: 60,
                                          child: Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                            children: [
                                              Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        top: 5, left: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons.date_range,
                                                          color:
                                                          Color(0x9D070407),
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        Padding(
                                                          padding:
                                                          const EdgeInsets
                                                              .only(top: 3.0),
                                                          child: Text(
                                                            DateFormat(
                                                                'MM/dd/yyyy')
                                                                .format(favorites[index]
                                                                .startingDate!
                                                                .toDate()),
                                                            style: TextStyle(
                                                                color: Color(
                                                                    0xFF070407)),
                                                          ),
                                                        )
                                                      ],
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 8.0),
                                                    child: Row(
                                                      children: [
                                                        Icon(
                                                          Icons
                                                              .location_on_outlined,
                                                          color:
                                                          Color(0x9D070407),
                                                        ),
                                                        SizedBox(
                                                          width: 3,
                                                        ),
                                                        FutureBuilder(
                                                            future: getLocation(
                                                                favorites[index]
                                                                    .eventLocation!),
                                                            initialData:
                                                            "Loading location..",
                                                            builder: (BuildContext
                                                            context,
                                                                AsyncSnapshot<
                                                                    String>
                                                                text) {
                                                              return Text(
                                                                  text
                                                                      .requireData,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0xFF070407)));
                                                            }),
                                                      ],
                                                    ),
                                                  ),
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    bottom: 25.0, right: 9),
                                                child: Row(
                                                  children: [
                                                    Icon(
                                                      Icons.access_time,
                                                      color: Color(0x9D070407),
                                                    ),
                                                    SizedBox(
                                                      width: 3,
                                                    ),
                                                    Text(
                                                      DateFormat('hh:mm').format(
                                                          favorites[index]
                                                              .startingDate!
                                                              .toDate()),
                                                    ),
                                                  ],
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      ],
                                    )),
                                onTap: () {
                                  Get.to(EventPage(
                                      event: favorites[index],isRecommended: false));
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
                        })),
              )]
        )


    );
  }

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<bool> addToFavorites(String? id, bool isLiked) async {
    if (!isLiked) {
      await firestoreInstance.collection("events").doc(id).update({
        "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
    } else {
      await firestoreInstance.collection("events").doc(id).update({
        "likes":
        FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });
    }
    return true;
  }
  Future<String> getLocation(Map<String, dynamic> eventLocation) async {
    String loc;
    GeoPoint location = eventLocation["geopoint"];

    List<Placemark> placemarks =
    await placemarkFromCoordinates(location.latitude, location.longitude);

    Placemark place = placemarks[0];
    List<String> addres = place.street!.split(" ");
    if (addres.length > 4) {
      loc =
      ("${addres[0]} ${addres[1]} ${addres[3]} ${addres[4]},${place.locality}");
    } else {
      loc = ("${place.street},${place.locality}");
    }

    return loc;
  }

}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/controllers/eventController.dart';
import 'package:evetoapp/controllers/loginController.dart';
import 'package:evetoapp/controllers/userController.dart';
import 'package:evetoapp/editeProfile.dart';
import 'package:evetoapp/models/users/User.dart';
import 'package:evetoapp/signUp.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geocoding/geocoding.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:intl/intl.dart';
import 'eventPage.dart';
import 'models/Event.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required String uid})
      : _uid = uid,
        super(key: key);

  final String _uid;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late List<Event> Events ;
  UserController userController = UserController();
  EventController eventController= EventController();
  UserModel user = UserModel();
  bool? isUserProfile;

  Map<String, dynamic>? map;
  @override
  initState() {
    eventController.loadEvents();
    Events = eventController.events.where((element) => element.uid==user.uid).toList();
    // print(object)
    getData().then((value) => user = value);
    super.initState();
  }

  Future<UserModel> getData() async {
    try {
      user = await userController.GetUser(widget._uid);
      print(user.fullName ?? "");
      // var snap= await FirebaseFirestore.instance.collection('users').doc(widget._uid).get();
      // userData = snap.data()!;
      setState(() {
        print(user.uid);
        print(widget._uid);
        isUserProfile = (user.uid == widget._uid);
        print(isUserProfile);
      });
    } catch (e) {
      print(e);
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          user.fullName ?? "",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: Colors.black),

      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xff74EDED),
                    backgroundImage:user!.photoURL != null? Image.network(user.photoURL!).image:
                    Image.asset("assets/avatar.png").image
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            user.fullName ?? "",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: Text("Edit Profile",
                                  style: TextStyle(color: Colors.black)),
                            ),
                            style: OutlinedButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size(0, 30),
                                side: BorderSide(
                                  color: Colors.deepPurpleAccent,
                                )),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditeProfile(user: user)),
                              );
                            },
                          ),
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  top: 15,
                ),
                child: Text(
                  user.fullName ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
               Container(
                 height: 400,
                 child: ListView.builder(
                     physics: BouncingScrollPhysics(),
                     padding: EdgeInsets.only(top: 0),
                     itemCount: Events.length,
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
                                                   Events[index]
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
                                             Events[index].title!,
                                             style: TextStyle(
                                                 color: Colors.white,
                                                 fontSize: 17,
                                                 fontWeight: FontWeight.w800,
                                                 fontFamily: "Lato"),
                                           ),
                                         ),
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
                                                       Color(0x9B000000),
                                                     ),
                                                     SizedBox(
                                                       width: 3,
                                                     ),
                                                     Padding(
                                                       padding:
                                                       const EdgeInsets
                                                           .only(top: 3.0),
                                                       child: Text(
                                                         DateFormat('MM/dd/yyyy').format(Events[index].startingDate!.toDate()),
                                                         style: TextStyle(
                                                             color: Color(
                                                                 0x9B000000),fontSize: 14),
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
                                                       Color(0x9B000000),
                                                     ),
                                                     SizedBox(
                                                       width: 3,
                                                     ),
                                                     FutureBuilder(
                                                         future: getLocation(
                                                             Events[index]
                                                                 .eventLocation!),
                                                         initialData:
                                                         "Loading location..",
                                                         builder: (BuildContext
                                                         context,
                                                             AsyncSnapshot<
                                                                 String>
                                                             text) {
                                                           return Padding(
                                                             padding: const EdgeInsets.only(top: 3.0),
                                                             child: Text(
                                                                 text
                                                                     .requireData,
                                                                 style: TextStyle(
                                                                     color: Color(
                                                                         0x9B000000),fontSize: 13)),
                                                           );
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
                                                   color: Color(0x9B000000),
                                                 ),
                                                 SizedBox(
                                                   width: 3,
                                                 ),
                                                 Text(
                                                   DateFormat('Hm').format(
                                                       Events[index]
                                                           .startingDate!
                                                           .toDate()),
                                                   style: TextStyle(
                                                       color: Color(
                                                           0x9B000000),fontSize: 13),
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
                                   event: Events[index],isRecommended: false));
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
                     }),
               )



            ]),
          ),
        ],
      ),
    );
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
  }}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/controllers/eventController.dart';
import 'package:evetoapp/providers/eventProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'models/Event.dart';
class EventPage extends StatefulWidget {
  const EventPage({Key? key, required Event event,required bool isRecommended})
      : _event = event,
        _isRecommended=isRecommended,
        super(key: key);

  final Event _event;
  final bool _isRecommended;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late bool isReco;
  late Event event;
  EventController eventController = EventController();
  int index = 0;

  final Set<Marker> markers = Set();
  late final LatLng position ;
  late GeoPoint eventLocation ;

  @override
  void initState() {
    event =widget._event ;
    // event.title="Groupe Iwal";
    // event.inscriptionUrl="https://docs.google.com/forms/d/e/1FAIpQLSdFPyVFQ65NaF1REfGWIARCP07oRr6NDEBkzG-ktnmgo9NIow/viewform?usp=sf_link";
    // event.description="Le groupe @iwal_officiel fondé par le duo de Nasrine et de Fayssal de puis plus de 5 ans, a révolutionné la chanson chaoui moderne, il s’est produit dans plusieurs villes en général, Batna, Alger, Béjaïa… Et prochainement le 26 & 27 Mai 2022 à 19h au théâtre la fourmi à Oran 🔥🔥🔥         Zone des sièges, USTO, collé à l’hôtel liberté.";
    isReco =widget._isRecommended;
    index = eventController.events.indexWhere((element) => element.id==event.id);
    eventLocation= event.eventLocation!["geopoint"];
    position= LatLng(eventLocation.latitude, eventLocation.longitude);
    markers.add(Marker(
      //add first marker
      markerId: MarkerId(position.toString()),
      position: position, //position of marker
      infoWindow: InfoWindow(
        //popup info
        title: 'Event location',
      ),
      icon: BitmapDescriptor.defaultMarker, //Icon for Marker
    ));
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
        body:SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            height: MediaQuery.of(context).size.height+100,
            padding: EdgeInsets.all(0),
            child: Stack(
              children:<Widget> [
                 Positioned(
                   top: 0,
                   child: SizedBox(
                    height: 300,
                    width: MediaQuery.of(context).size.width,
                    child: Image(
                      image:
                      // Image.asset("assets/iwal.jpg").image,
                      Image.network(event.photoUrl!).image,
                      fit: BoxFit.cover,
                      color: Colors.black54.withOpacity(0.1),
                      colorBlendMode: BlendMode.colorBurn,
                      frameBuilder: (BuildContext
                      context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                        if (wasSynchronouslyLoaded || frame != null) {
                          return Container(
                            child: child,
                            foregroundDecoration:
                            const BoxDecoration(
                                gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Color(
                                          0x00000000),
                                      Color(
                                          0x00000000),
                                      Color(
                                          0x00000000),
                                      Color(
                                          0x00000000),
                                      Color(
                                          0x00000000),
                                    ])),
                            // height: 130,
                            width: double
                                .infinity,
                          );
                        } else {
                          return Container(
                            child: CircularProgressIndicator(
                                color: Colors.grey,
                                value: null,
                                backgroundColor: Colors.white),
                            alignment: Alignment(0, 0),
                            constraints: BoxConstraints.expand(),
                          );
                        }
                      },
                    ),
                ),
                 ),
                Positioned(
                  width: MediaQuery.of(context).size.width,
                  top: 250,
                  child: SingleChildScrollView(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft:Radius.circular(25))
                      ),
                     child: SingleChildScrollView(
                       physics: BouncingScrollPhysics(),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Row(
                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(left: 25.0,top: 25),
                                 child: Text(event.title!,style: TextStyle(color: Colors.black87,fontSize: 25,fontWeight: FontWeight.w800,letterSpacing: 0.3,fontFamily: "Lato",)),
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(top: 25.0,right: 25.0),
                                 child: CircleAvatar(
                                   backgroundColor:
                                   Color(0x57000000),
                                   child: Padding(
                                     padding:
                                     EdgeInsets.only(left: 4),
                                     child: LikeButton(
                                       animationDuration: Duration(
                                           milliseconds: 300),
                                       isLiked: event.likes
                                           .contains(FirebaseAuth
                                           .instance
                                           .currentUser!
                                           .uid),
                                       onTap: (isLiked) async {
                                         await addToFavorites(
                                             event.id, isLiked);


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
                                           if (isReco) {
                                             eventController.getRec();
                                           }
                                           event=eventController.events[index];
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
                                         return !isLiked;
                                       },
                                     ),
                                   ),
                                 ),
                               )
                             ],
                           ),
                           SizedBox(height: 20,),
                           Padding(
                             padding: const EdgeInsets.only(left: 25.0),
                             child: Text("Description",style: TextStyle(color: Color(
                                 0xE2070407),fontSize: 15,fontWeight: FontWeight.w800,letterSpacing: 0.3,fontFamily: "Lato",)),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(top: 8.0,right: 20,left: 20),
                             child: Divider(),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(top: 10,right: 25.0,left: 25),
                             child: Text(event.description!,textAlign: TextAlign.justify,),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(top: 8.0,right: 20,left: 20),
                             child: Divider(),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(left: 25.0,top: 15),
                             child: Text("Inscription",style: TextStyle(color: Color(
                                 0xE2070407),fontSize: 15,fontWeight: FontWeight.w800,letterSpacing: 0.3,fontFamily: "Lato",)),
                           ),
                           ( event.inscriptionUrl=="Public")?
                           Padding(
                             padding: const EdgeInsets.symmetric(horizontal: 25.0),
                             child: TextField(
                                 enabled: false,
                                 decoration: InputDecoration(
                                   prefixIcon: Icon(Icons.public),
                                   contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                   hintText: "Public",
                                   border: OutlineInputBorder(
                                     // borderRadius: BorderRadius.circular(30),
                                   ),
                                 )
                             ),
                           )
                               :Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 25.0,vertical: 10),
                                 child: TextField(
                                 enabled: false,
                                 decoration: InputDecoration(
                                   labelText: event.inscriptionUrl,
                                   labelStyle: TextStyle(color: Colors.blue),
                                   prefixIcon: Icon(Icons.link),
                                   suffixIcon: IconButton(
                                     icon: Icon( Icons.copy),
                                     onPressed: () async {
                                       await Clipboard.setData(ClipboardData(text: event.inscriptionUrl));
                                       ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                         content: Text('Copied to clipboard'),
                                       ));
                                     },
                                   ),
                                   contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                                   border: OutlineInputBorder(
                                     borderRadius: BorderRadius.circular(10),
                                   ),
                                 )
                           ),
                               ),
                           Row(
                             children: [
                               Padding(
                                 padding: const EdgeInsets.only(left: 25.0,top: 15),
                                 child: Text("Début",style: TextStyle(color: Color(
                                     0xE2070407),fontSize: 15,fontWeight: FontWeight.w800,letterSpacing: 0.3,fontFamily: "Lato",)),
                               ),
                               Padding(
                                 padding: const EdgeInsets.only(left: 140,top: 15),
                                 child: Text("Fin",style: TextStyle(color: Color(
                                     0xE2070407),fontSize: 15,fontWeight: FontWeight.w800,letterSpacing: 0.3,fontFamily: "Lato",)),
                               ),
                             ],
                           ),
                           Padding(
                             padding: const EdgeInsets.only(top: 5,right: 20,left: 20),
                             child: Divider(),
                           ),
                           Padding(
                             padding: const EdgeInsets.only(left: 23.0,top: 5),
                             child: Row(children: [
                                 Icon(
                                   Icons.date_range_rounded,
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
                                     DateFormat(
                                         'MM/dd/yyyy')
                                         .format(event
                                         .startingDate!
                                         .toDate()),
                                     style: TextStyle(
                                         color: Color(
                                             0x9B000000),fontSize: 14),
                                   ),
                                 ),
                               SizedBox(width: 5,),
                               Row(
                                 children: [
                                   Padding(
                                     padding: const EdgeInsets.only(top: 3.0),
                                     child: Text(
                                       DateFormat('Hm').format(event.startingDate!.toDate()),
                                       style: TextStyle(
                                           color: Color(
                                               0x9B000000),fontSize: 13),
                                     ),
                                   ),
                                   SizedBox(width: 40,),
                                   Icon(
                                     Icons.date_range_rounded,
                                     color:
                                     Color(0x9B000000),
                                   ),
                                   SizedBox(
                                     width: 5,
                                   ),
                                   Padding(
                                     padding:
                                     const EdgeInsets
                                         .only(top: 3.0),
                                     child: Text(
                                       DateFormat(
                                           'MM/dd/yyyy')
                                           .format(event
                                           .endingDate!
                                           .toDate()),
                                       style: TextStyle(
                                           color: Color(
                                               0x9B000000),fontSize: 14),
                                     ),

                                   ),
                                   SizedBox(width: 3,),
                                   Row(
                                     children: [
                                       Padding(
                                         padding: const EdgeInsets.only(top: 3.0),
                                         child: Text(
                                           DateFormat('Hm').format(event.endingDate!.toDate()),
                                           style: TextStyle(
                                               color: Color(
                                                   0x9B000000),fontSize: 13),
                                         ),
                                       ),
                                 ],
                               ),
                               ],

                                 ),

                                 ],

                                 ),
                               ),
                           SizedBox(height: 17,),
                           Padding(
                             padding: const EdgeInsets.only(left: 25.0,right: 25),
                             child: Container(
                               decoration: BoxDecoration(
                                   borderRadius: BorderRadius.circular(25)),
                               padding: EdgeInsets.all(0),
                               margin: EdgeInsets.all(0),
                               height: 130,
                               child: GoogleMap(
                                 // gestureRecognizers:
                                 // <Factory<OneSequenceGestureRecognizer>>[
                                 //   new Factory<OneSequenceGestureRecognizer>(
                                 //         () => new EagerGestureRecognizer(),
                                 //   ),
                                 // ].toSet(),
                                 mapToolbarEnabled: true,
                                 initialCameraPosition: CameraPosition(
                                   target: position,
                                   zoom: 10,
                                 ),
                                 onMapCreated: _onMapCreated,
                                 compassEnabled: true,
                                 onTap: (object) async {
                                   double lat= position.latitude;
                                   double long=position.longitude;
                                   String googleUrl = 'https://www.google.com/maps/search/?api=1&query=$lat,$long';
                                   if (await canLaunchUrlString(googleUrl)) {
                                   await launchUrlString(googleUrl);
                                   } else {
                                   throw 'Could not open the map.';
                                   }
                                 },
                                 markers: markers,
                               ),
                             ),
                           ),




                         ],
                       ),
                     ),
                    ),
                  ),
                )
              ],

            ),
          ),
        ));
  }

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<bool> addToFavorites(String? id, bool isLiked) async {
    if (!isLiked) {
      await firestoreInstance.collection("events").doc(id).update({
        "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
      await firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "favorites": FieldValue.arrayUnion([id])
      });
    } else {
      await firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "favorites": FieldValue.arrayRemove([id])
      });
      await firestoreInstance.collection("events").doc(id).update({
        "likes":
        FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });
    }
    return true;
  }

  void _onMapCreated(GoogleMapController controller) {
  }
}


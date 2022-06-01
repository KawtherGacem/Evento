import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/providers/eventProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'models/Event.dart';
class EventPage extends StatefulWidget {
  const EventPage({Key? key, required Event event})
      : _event = event,

        super(key: key);
  final Event _event;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Event event;

  @override
  void initState() {
    event =widget._event ;

    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    final EventProvider = Provider.of<eventProvider>(context);

    return Scaffold(
        body:Container(
          padding: EdgeInsets.all(0),
          child: Stack(
            children:<Widget> [
               Positioned(
                 top: 0,
                 child: SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: Image(
                    image: Image.asset("assets/people.png").image,
                    // Image.network(event.photoUrl!).image,
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
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(25),topLeft:Radius.circular(25))
                    ),
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
                                     final success =
                                     await addToFavorites(
                                        event.id,
                                         isLiked);
                                     EventProvider
                                         .loadEvents();
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
                         padding: const EdgeInsets.only(top: 8.0,right: 20,left: 20),
                         child: Divider(),
                       ),
                       Padding(
                         padding: const EdgeInsets.only(left: 23.0,top: 10),
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
                           Padding(
                             padding: const EdgeInsets.only(top: 8.0,right: 20,left: 20),
                             child: Divider(),
                           ),
                             ],

                             ),
                           )




                     ],
                   ),
                  ),
                ),
              )
            ],

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
}


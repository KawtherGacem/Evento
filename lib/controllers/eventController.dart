import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/models/Event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/users/User.dart';

class EventController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Event>> getEvents() async{
    return firestore.collection("events").where("endingDate",isGreaterThan: Timestamp.fromDate(DateTime.now())).get().then((result) {
      List<Event> events =[];
      var event;
      for( event in result.docs){
        events.add(Event.fromJson(event.data()));
      }
      return events;
    });

  }
  Future<List<Event>> getRecommendedEvents() async{

    FirebaseAuth _auth = FirebaseAuth.instance;
    String uid =_auth.currentUser!.uid;
    List<dynamic> userCategory = await GetUserCategory(uid);

    Query query = firestore.collection("events").where("category",arrayContainsAny: userCategory);
    return query.where("endingDate",isGreaterThan: Timestamp.fromDate(DateTime.now())).get().then((result) {
      List<Event> events =[];
      var event;
      for( event in result.docs){
        events.add(Event.fromJson(event.data()));
      }
      return events;
    });

  }

  Future<List<dynamic>> GetUserCategory(String uid) async {
    UserModel user=UserModel();
    var doc= await firestore.collection("users").doc(uid);
    await doc.get().then((value) => user.category = value.data()!["category"]);
    print(user.category);
    return user.category;

  }


}
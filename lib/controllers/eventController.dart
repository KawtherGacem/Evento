import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/models/Event.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class EventController{
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Event>> getEvents() async{
    return firestore.collection("events").get().then((result) {
      List<Event> events =[];
      var event;
      for( event in result.docs){
        events.add(Event.fromJson(event.data()));
      }
      return events;
    });

  }
  Future<List<Event>> getRecommendedEvents() async{
    Query query = firestore.collection("events").where("category",arrayContainsAny: ["medecine", "computer science"]);
    return query.get().then((result) {
      List<Event> events =[];
      var event;
      for( event in result.docs){
        events.add(Event.fromJson(event.data()));
      }
      return events;
    });

  }


}
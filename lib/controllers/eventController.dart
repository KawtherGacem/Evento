import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/models/Event.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

import '../models/users/User.dart';

class EventController{
  List<Event> events =[];

  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<List<Event>> getEvents() async{
    return firestore.collection("events").where("endingDate",isGreaterThan: Timestamp.fromDate(DateTime.now())).get().then((result) {
      // List<Event> events =[];
      var event;
      for( event in result.docs){
        events.add(Event.fromJson(event.data()));
      }
      _deleteCacheDir();
      return events;
    });

  }
  Future<List<Event>> getRecommendedEvents() async{
    String uid =FirebaseAuth.instance.currentUser!.uid;
    List<dynamic> userThemes = await GetUserThemes(uid);
    List<Event> recommendeEvents =[];
    recommendeEvents = events
        .where((event) => userThemes
        .any((element) => event.themes.contains(element)))
        .toList();

    // Query query = firestore.collection("events").where("themes",arrayContainsAny: userThemes);
    // return query.where("endingDate",isGreaterThan: Timestamp.fromDate(DateTime.now())).get().then((result) {
    //   var event;
    //   for( event in result.docs){
    //     recommendeEvents.add(Event.fromJson(event.data()));
    //   }
      // _deleteCacheDir();

      return recommendeEvents;
  }

  Future<List<Event>> getFavorites() async {
    List<Event> favoritEvents =[];
    String uid =FirebaseAuth.instance.currentUser!.uid;

    favoritEvents = events
        .where((event) => event.likes.contains(uid))
        .toList();

    // Query query = firestore.collection("events").where("likes",arrayContainsAny: [uid]);
    // return query.where("endingDate",isGreaterThan: Timestamp.fromDate(DateTime.now())).get().then((result) {
    //   List<Event> events =[];
    //   var event;
    //   for( event in result.docs){
    //     events.add(Event.fromJson(event.data()));
    //   }
    //   print(events[0].title);
    //   _deleteCacheDir();

      return favoritEvents;
  }

  Future<List<dynamic>> GetUserThemes(String uid) async {
    UserModel user=UserModel();
    var doc= await firestore.collection("users").doc(uid);
    await doc.get().then((value) => user.themes = value.data()!["themes"]);
    print(user.themes);
    _deleteCacheDir();
    return user.themes;

  }

  Future<void> _deleteCacheDir() async {
    final cacheDir = await getTemporaryDirectory();

    if (cacheDir.existsSync()) {
      cacheDir.deleteSync(recursive: true);
    }
  }

  putEvents(){

  }

}
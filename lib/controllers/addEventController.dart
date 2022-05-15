import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/addEvent.dart';
import 'package:evetoapp/models/users/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class addEventController {

  final firestoreInstance = FirebaseFirestore.instance;

   Future<void> addNewEvent(String title,String description,List<String> list,User? user,String downLoadUrl, String date, String time, GeoFirePoint eventLocation) async {
     var userName,photoUrl;
     await GetUser(user!.uid).then((value) => userName = value.userName);
     await GetUser(user.uid).then((value) => photoUrl = value.photoURL);
    if (userName!=null) {
      firestoreInstance.collection("events").add(
        {
          "title" : title,
          "description" : description,
          "uid" : user.uid,
          "organizerName":userName,
          "organizerPhoto":photoUrl,
          "date":date,
          "time":time,
          "eventLocation":eventLocation.data,
          "photoUrl":downLoadUrl,
          "category" : list
        }).then((value){
      print(value.id);
    });
    }
  }

  Future<UserModel> GetUser(String uid) async {
    UserModel user=UserModel();
    var doc= await firestoreInstance.collection("users").doc(uid);
    firestoreInstance.collection("users").doc(uid).get().then((value){
    });
      await doc.get().then((value) => user.photoURL = value.data()!["photoUrl"]);
      await doc.get().then((value) => user.userName = value.data()!["userName"]);
    return user;

  }


}


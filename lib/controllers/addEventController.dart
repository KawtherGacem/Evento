import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/addEvent.dart';
import 'package:firebase_auth/firebase_auth.dart';

class addEventController {

  final firestoreInstance = FirebaseFirestore.instance;

   void addNewEvent(String title,String description,List<String> list,User? user,String downLoadUrl) {
    firestoreInstance.collection("events").add(
        {
          "title" : title,
          "description" : description,
          "uid" : user?.uid,
          "organizerName":user?.displayName,
          "organizerPhoto":user?.photoURL,
          "photoUrl":downLoadUrl,
          "category" : list
        }).then((value){
      print(value.id);
    });
  }

}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/addEvent.dart';

class addEventController {

  final firestoreInstance = FirebaseFirestore.instance;

   void addNewEvent(String title,String description,List<String> list,String? uid) {
    firestoreInstance.collection("events").add(
        {
          "title" : title,
          "description" : description,
          "uid" : uid,
          "category" : list
        }).then((value){
      print(value.id);
    });
  }

}
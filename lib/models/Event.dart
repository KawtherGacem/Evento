import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Event {
  String? id;
  String? title;
  String? description;
  String? uid;
  String? organizerPhoto;
  String? organizerName;
  String? photoUrl;
  String? time;
  String? date;
  GeoPoint? eventLocation;
  List<dynamic> category=[];


  Event(this.id, this.title, this.description, this.uid,this.organizerPhoto, this.organizerName, this.category, this.photoUrl, this.date, this.time , this.eventLocation);

  Event.fromJson(Map<String,dynamic> json){
    id =json["id"];
    title = json["title"];
    description = json["description"];
    organizerPhoto = json["organizerPhoto"];
    organizerName = json["organizerName"];
    uid = json["uid"];
    category = json["category"];
    photoUrl = json["photoUrl"];
    time= json["time"];
    date= json["date"];
    eventLocation= json["eventLocation"];
  }
}

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
  Timestamp? startingDate;
  Timestamp? endingDate;
  Map<String,dynamic>? eventLocation;
  String? inscriptionUrl;
  List<dynamic> category=[];
  List<dynamic> likes=[];


  Event(this.id, this.title, this.description, this.uid,this.organizerPhoto, this.organizerName, this.category, this.photoUrl, this.startingDate, this.endingDate , this.eventLocation, this.inscriptionUrl,this.likes);

  Event.fromJson(Map<String,dynamic> json){
    id =json["id"];
    title = json["title"];
    description = json["description"];
    organizerPhoto = json["organizerPhoto"];
    organizerName = json["organizerName"];
    uid = json["uid"];
    category = json["category"];
    photoUrl = json["photoUrl"];
    startingDate= json["startingDate"];
    endingDate= json["endingDate"];
    eventLocation= json["eventLocation"];
    inscriptionUrl=json["inscriptionUrl"];
    likes=json["likes"];
  }
}

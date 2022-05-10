import 'package:flutter/foundation.dart';

class Event {
  String? id;
  String? title;
  String? description;
  String? uid;
  String? organizerPhoto;
  String? organizerName;
  String? photoUrl;
  List<dynamic> category=[];


  Event(this.id, this.title, this.description, this.uid,this.organizerPhoto, this.organizerName, this.category, this.photoUrl);
// String? date;
  // String? time;
  // String? address;
  // String? photo;
  // String? inscriptionUrl;
  // String? nbrInterested;
  // String? category;
  // String? organizer;

  Event.fromJson(Map<String,dynamic> json){
    id =json["id"];
    title = json["title"];
    description = json["description"];
    organizerPhoto = json["organizerPhoto"];
    organizerName = json["organizerName"];
    uid = json["uid"];
    category = json["category"];
    photoUrl = json["photoUrl"];
  }
}

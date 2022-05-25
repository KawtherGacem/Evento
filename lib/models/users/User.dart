import 'dart:ffi';

class UserModel {
  String? uid;
  String? email;
  String? fullName;
  String? userName;
  String? photoURL;
  List<dynamic> category=[];


  UserModel({this.uid, this.email, this.fullName, this.userName,this.photoURL,});


  //
  // factory UserModel.fromMap(map){
  //   return UserModel(
  //     uid: map('uid'),
  //     email: map('email'),
  //     firstName: map('firstName'),
  //     lastName: map('lastName')
  //   );
  // }

  // Map<String,dynamic> toMap(){
  //   return {
  //     'uid': uid,
  //     'email': email,
  //     'fullName': fullName,
  //     'userName': userName
  //   };
  // }


  UserModel.fromJson(Map<String,dynamic>? json){
    fullName = json!["fullName"];
    userName = json["userName"];
    email = json["email"];
    photoURL = json["photo"];
    email =json["email"];
    category=json["category"];
    uid=json["uid"];
  }

  // Map<String,dynamic> toJson(){
  //   final Map<String,dynamic> data = new Map<String,dynamic>();
  //   data["firstname"]= this.firstName;
  //   data["lastname"]= this.firstName;
  //   data["email"]= this.firstName;
  //   data["photoURL"]= this.firstName;
  //
  //   return data;
  // }

}
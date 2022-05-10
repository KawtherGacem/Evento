import 'dart:ffi';

class UserModel {
  String? uid;
  String? email;
  String? fullName;
  String? userName;
  String? photoURL;
  Array? category;


  UserModel({this.uid, this.email, this.fullName, this.userName,this.photoURL});

  String? get _uid => uid;
  String? get _email  => email;
  String? get _fullName => fullName;
  String? get _userName => userName;
  String? get _photoURL => photoURL;



  //
  // factory UserModel.fromMap(map){
  //   return UserModel(
  //     uid: map('uid'),
  //     email: map('email'),
  //     firstName: map('firstName'),
  //     lastName: map('lastName')
  //   );
  // }

  Map<String,dynamic> toMap(){
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'userName': userName
    };
  }


  // UserModel.fromJson(Map<String,dynamic> json){
  //   firstName = json["firstname"];
  //   lastName = json["lastName"];
  //   email = json["email"];
  //   photoURL = json["photoURL"];
  // }

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
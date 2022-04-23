class UserModel {
  String? uid;
  String? email;
  String? firstName;
  String? lastName;
  String? photoURL;

  UserModel({this.uid, this.email, this.firstName, this.lastName,this.photoURL});


  factory UserModel.fromMap(map){
    return UserModel(
      uid: map('uid'),
      email: map('email'),
      firstName: map('firstName'),
      lastName: map('lastName')
    );
  }

  Map<String,dynamic> toMap(){
    return {
      'uid': uid,
      'email': email,
      'firstName': firstName,
      'lastName': lastName
    };
  }

  UserModel.fromJson(Map<String,dynamic> json){
    firstName = json["firstname"];
    lastName = json["lastName"];
    email = json["email"];
    photoURL = json["photoURL"];
  }

  Map<String,dynamic> toJson(){
    final Map<String,dynamic> data = new Map<String,dynamic>();
    data["firstname"]= this.firstName;
    data["lastname"]= this.firstName;
    data["email"]= this.firstName;
    data["photoURL"]= this.firstName;

    return data;
  }

}
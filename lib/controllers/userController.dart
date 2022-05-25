import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/users/User.dart';

class UserController {
  final firestoreInstance = FirebaseFirestore.instance;


  Future<UserModel> GetUser(String uid) async {
    UserModel user=UserModel();
    await firestoreInstance.collection("users").doc(uid).get().then((value) =>
    user= UserModel.fromJson(value.data()));
    // print(user.fullName);
    return user;

  }
}
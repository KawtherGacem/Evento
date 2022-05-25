import 'package:evetoapp/controllers/userController.dart';
import 'package:evetoapp/models/users/User.dart';
import 'package:flutter/cupertino.dart';

class UserProvider extends ChangeNotifier{
  UserModel user = UserModel();
  UserController userController = UserController();
  UserProvider.initialize() {

  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/controllers/userController.dart';
import 'package:evetoapp/editeProfile.dart';
import 'package:evetoapp/models/users/User.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key? key, required String uid})
      : _uid = uid,
        super(key: key);

  final String _uid;

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  UserController userController = UserController();
  UserModel user = UserModel();
  bool? isUserProfile;
  @override
  initState() {
    getData().then((value) => user = value);
    super.initState();
  }

  Future<UserModel> getData() async {
    try {
      user = await userController.GetUser(widget._uid);
      print(user.fullName ?? "");
      // var snap= await FirebaseFirestore.instance.collection('users').doc(widget._uid).get();
      // userData = snap.data()!;
      setState(() {
        print(user.uid);
        print(widget._uid);
        isUserProfile = (user.uid == widget._uid);
        print(isUserProfile);
      });
    } catch (e) {
      print(e);
    }
    return user;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(
          user.fullName ?? "",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 50,
                    backgroundColor: Color(0xff74EDED),
                    backgroundImage: Image.asset("assets/avatar.JPG").image,
                  ),
                  Expanded(
                    flex: 1,
                    child: Column(children: [
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            user.fullName ?? "",
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          OutlinedButton(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 50),
                              child: Text("Edit Profile",
                                  style: TextStyle(color: Colors.black)),
                            ),
                            style: OutlinedButton.styleFrom(
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                                minimumSize: Size(0, 30),
                                side: BorderSide(
                                  color: Colors.deepPurpleAccent,
                                )),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => Editeprofile()),
                              );
                            },
                          ),
                        ],
                      ),
                    ]),
                  ),
                ],
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  top: 15,
                ),
                child: Text(
                  user.fullName ?? "",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.only(
                  top: 1,
                ),
                child: Text('bio'),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}

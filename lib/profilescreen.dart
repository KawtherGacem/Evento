import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/editeProfile.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfileScreen extends StatefulWidget {
  final String uid;
  const ProfileScreen({Key? key, required this.uid}) : super(key: key);
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {

  var userData = {};


  @override
  void initState() {
    super.initState();
    getData();
  }
  getData() async {
    try {
      var snap= await FirebaseFirestore.instance.collection('users').doc(widget.uid).get();
      userData = snap.data()!;
      setState(() {

      });
    }
    catch (e) {
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        title: Text(userData['fullName'],
          style:
          TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),

      body:ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),

            child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 50,
                        backgroundColor: Color(0xff74EDED),
                        backgroundImage: Image.asset("assets/avatar.JPG").image,
                      ),
                      Expanded(
                        flex: 1,
                        child:Column(
                            children:[
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    userData['fullName'],
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
                                      padding: const EdgeInsets.symmetric(horizontal: 50),
                                      child: Text("Edit Profile", style: TextStyle(color: Colors.black)),
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
                                        MaterialPageRoute(builder: (context) => Editeprofile()),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ]
                        ),
                      ),
                    ],
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 15,),
                    child: Text(userData['fullName'], style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),),
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.only(top: 1,),
                    child: Text('bio'),
                  ),
                ]),
          ),
        ],
      ),
    );
  }

}
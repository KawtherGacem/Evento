import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HeaderDrawer extends StatefulWidget {
  @override
  _HeaderDrawerState createState() => _HeaderDrawerState();
}

class _HeaderDrawerState extends State<HeaderDrawer> {
  FirebaseAuth _auth = FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color(0xFF604BE0),
      width: double.infinity,
      height: 200,
      padding: EdgeInsets.only(top: 20.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(bottom: 10),
            height: 90,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image:  Image.network(_auth.currentUser?.photoURL ?? "user", fit: BoxFit.fitWidth,).image,
              ),
            ),
          ),
          Text(
            _auth.currentUser!.displayName ?? "",
            style: TextStyle(color: Colors.white70, fontSize: 20),
          ),
          Text(
            _auth.currentUser!.email ?? "",
            style: TextStyle(
              color: Colors.white60,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }
}
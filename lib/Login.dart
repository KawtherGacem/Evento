import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  @override
  _LogindState createState() => _LogindState();
}

class _LogindState  {

}


class _DashboardState extends State<Login> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/jdid.jpg"),
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
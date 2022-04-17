import 'dart:ui';

import 'package:evetoapp/dashboard.dart';
import 'package:evetoapp/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'homePage.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  final _formKey = GlobalKey<FormState>();
  final TextEditingController emailController = new TextEditingController();
  final TextEditingController passwordController = new TextEditingController();

  final _auth = FirebaseAuth.instance;
  String? errorMessage;

  @override
  Widget build(BuildContext context) {

    final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      // validator: ,
      cursorColor: Color(0xFF513ADA),
      onSaved: (value){
        emailController.text = value!;
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20,15,20,15),
          hintText: "Email",
          hintStyle: TextStyle(fontFamily: "RobotoMono"),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      // validator: ,
      cursorColor: Color(0xFF513ADA),

      onSaved: (value){
        passwordController.text = value!;
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key_rounded),
          contentPadding: EdgeInsets.fromLTRB(20,15,20,15),
          hintText: "Password",
          hintStyle: TextStyle(fontFamily: "RobotoMono"),
          // enabledBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(color: Color(0xFF513ADA)),
          // ),
          // focusedBorder: UnderlineInputBorder(
          //   borderSide: BorderSide(color: Color(0xFF513ADA)),
          // ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )
      ),
      obscureText: true,
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xFF513ADA),
      child: MaterialButton(
        padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
        login(emailController.text, passwordController.text);
        },
        child: Text("Login",textAlign: TextAlign.center,style: TextStyle(
            fontSize:20 ,color: Color(0xFFFFFFFF),fontWeight: FontWeight.bold,
            fontFamily: "RobotoMono"
        )),
      ),
    );

    return Scaffold(
      body:SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height
          ),
          child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("images/background2.png"),
                  fit: BoxFit.fill,
                )
            ),
            child: Container(
              padding: EdgeInsets.all(0),
              child: Padding(
                padding: const EdgeInsets.only(right: 60.0,left: 60),
                child: Form(
                  key: _formKey,
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Column(
                      // mainAxisAlignment:MainAxisAlignment.center,
                      // crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top:60),
                          height: 170,
                          child: Image.asset("images/logo-evento.png",
                            fit: BoxFit.contain,),
                        ),
                        Container(
                            margin: EdgeInsets.only(top:35),
                            child: emailField),
                        Container(
                            margin: EdgeInsets.only(top:20),
                            child: passwordField),
                        Container(
                            margin: EdgeInsets.only(top:35),
                            child: loginButton),
                        Container(
                          margin: EdgeInsets.only(top:12),
                          child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Text("Don't have an account? "),
                                GestureDetector(
                                  onTap: (){
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  SignUp()));
                                  } ,
                                  child: Text(
                                    "SignUp",
                                    style: TextStyle(
                                        color: Colors.grey,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15),
                                  ),
                                )
                              ]),
                        )
                      ],


                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  void login(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
          Fluttertoast.showToast(msg: "Login Successful"),
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => HomePage())),
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "invalid-email":
            errorMessage = "Your email address appears to be malformed.";

            break;
          case "wrong-password":
            errorMessage = "Your password is wrong.";
            break;
          case "user-not-found":
            errorMessage = "User with this email doesn't exist.";
            break;
          case "user-disabled":
            errorMessage = "User with this email has been disabled.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Signing in with Email and Password is not enabled.";
            break;
          default:
            errorMessage = "An undefined Error happened.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
}

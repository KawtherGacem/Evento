import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/dashboard.dart';
import 'package:evetoapp/selectPage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

import 'homePage.dart';
import 'models/users/User.dart';
class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>(debugLabel: 'SignUpPageKey');
  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  var _image;
  var DownLoadUrl;

  final fullNameEditingController = new TextEditingController();
  final userNameEditingController = new TextEditingController();
  final emailEditingController = new TextEditingController();
  final passwordEditingController = new TextEditingController();
  final confirmPasswordEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    //full name field
    final fullNameField = TextFormField(
        autofocus: false,
        controller: fullNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{3,}$');
          if (value!.isEmpty) {
            return ("Full Name cannot be Empty");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid name(Min. 3 Character)");
          }
          return null;
        },
        onSaved: (value) {
          fullNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nom Complet",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ));

    //username field
    final userNameField = TextFormField(
        autofocus: false,
        controller: userNameEditingController,
        keyboardType: TextInputType.name,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Username ne doit pas etre vide");
          }
          return null;
        },
        onSaved: (value) {
          userNameEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.account_circle),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Nom d'utilisateur",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ));

    //email field
    final emailField = TextFormField(
        autofocus: false,
        controller: emailEditingController,
        keyboardType: TextInputType.emailAddress,
        validator: (value) {
          if (value!.isEmpty) {
            return ("Please Enter Your Email");
          }
          // reg expression for email validation
          if (!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]")
              .hasMatch(value)) {
            return ("Please Enter a valid email");
          }
          return null;
        },
        onSaved: (value) {
          emailEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.mail),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Email",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ));

    //password field
    final passwordField = TextFormField(
        autofocus: false,
        controller: passwordEditingController,
        obscureText: true,
        validator: (value) {
          RegExp regex = new RegExp(r'^.{6,}$');
          if (value!.isEmpty) {
            return ("Password is required");
          }
          if (!regex.hasMatch(value)) {
            return ("Enter Valid Password(Min. 6 Character)");
          }
        },
        onSaved: (value) {
          passwordEditingController.text = value!;
        },
        textInputAction: TextInputAction.next,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Mot de passe",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ));

    //confirm password field
    final confirmPasswordField = TextFormField(
        autofocus: false,
        controller: confirmPasswordEditingController,
        obscureText: true,
        validator: (value) {
          if (confirmPasswordEditingController.text !=
              passwordEditingController.text) {
            return "Password don't match";
          }
          return null;
        },
        onSaved: (value) {
          confirmPasswordEditingController.text = value!;
        },
        textInputAction: TextInputAction.done,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.vpn_key),
          contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          hintText: "Confirmer mot de passe",
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          ),
        ));

    Future uploadPic(BuildContext context) async {
      Reference ref = FirebaseStorage.instance.ref();
      TaskSnapshot addImg = await ref
          .child("image/" + DateTime.now().toString())
          .putFile(_image!);
      if (addImg.state == TaskState.success) {
        print("added to Firebase Storage");
      }
      var DUrl = addImg.ref.getDownloadURL();
      await DUrl.then((result) {
        setState(() {
          if (result is String) {
            DownLoadUrl = result;
            print(DownLoadUrl);

          }
        });
      });
    }

    //signup button
    final signUpButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: Color(0xFF513ADA),
      child: MaterialButton(
          padding: EdgeInsets.fromLTRB(20, 15, 20, 15),
          minWidth: MediaQuery.of(context).size.width,
          onPressed: () async {
            await uploadPic(context);
            signUp(emailEditingController.text, passwordEditingController.text);
          },
          child: Text(
            "Inscrire",
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold),
          )),
    );

    Future getImage() async {
      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image!.path);
      });
    }


    return Scaffold(
       // IconButton(
       //    icon: Icon(Icons.arrow_back, color: Color(0xFF513ADA)),
       //    onPressed: () {
       //      // passing this to our root
       //      Navigator.of(context).pop();
       //    },
       //  ),
      body: SingleChildScrollView(

            child: ConstrainedBox(
               constraints: BoxConstraints(
              minHeight: MediaQuery.of(context).size.height
             ),
            child: Container(
              decoration: const BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/signUpBackground.png"),
                    fit: BoxFit.fill,
                  )
              ),
              child: Padding(
                padding: const EdgeInsets.all(60.0),
                child: Form(
                  key: _formKey,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          margin: EdgeInsets.only(top:10),
                          height: 60,
                          width: 250,
                          child: Image.asset("assets/logotwil.png",
                            fit: BoxFit.contain,),
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Stack(
                          children: [
                            Container(
                              width: 120,
                              height: 120,
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFF513ADA), width: 4),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(100),
                                ),
                              ),
                              child: ClipOval(
                                child:  _image != null
                                    ? Image.file(
                                  _image!,
                                  width: 170,
                                  height: 170,
                                  fit: BoxFit.cover,
                                )
                                    : Image.asset(
                                 "assets/avatar.png",
                                  width: 170,
                                  height: 170,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  height: 40,
                                  width: 40,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      width: 4,
                                      color: Color(0xFF513ADA),
                                    ),
                                    color: Color(0xFF513ADA),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.only(top: 0.0),
                                    child: IconButton(
                                      onPressed: () async{
                                        getImage();
                                      },

                                      icon: const Icon(
                                        Icons.edit,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ))
                          ],
                        ),
                        Container(
                            margin: EdgeInsets.only(top:20),
                            child: fullNameField),
                        Container(
                            margin: EdgeInsets.only(top:20),
                            child: userNameField),
                        Container(
                            margin: EdgeInsets.only(top:20),
                            child: emailField),
                        Container(
                            margin: EdgeInsets.only(top:20),
                            child: passwordField),
                        Container(
                            margin: EdgeInsets.only(top:20),
                            child: confirmPasswordField),
                        Container(
                            margin: EdgeInsets.only(top:30),
                            child: signUpButton),

                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
    );
  }

  void signUp(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .createUserWithEmailAndPassword(email: email, password: password)
            .then((value) => {postDetailsToFirestore()})
            .catchError((e) {
          Fluttertoast.showToast(msg: e!.message);
        });
      } on FirebaseAuthException catch (error) {
        switch (error.code) {
          case "email-already-in-use":
            errorMessage = "ce email est déja utilisé.";
            break;
          case "invalid-email":
            errorMessage = "votre email est invalide.";
            break;
          case "weak-password":
            errorMessage = "votre mot de passe est faible.";
            break;
          case "too-many-requests":
            errorMessage = "Too many requests";
            break;
          case "operation-not-allowed":
            errorMessage = "Creation du compte n'est pas autorisé.";
            break;
          default:
            errorMessage = "Error indéfini.";
        }
        Fluttertoast.showToast(msg: errorMessage!);
        print(error.code);
      }
    }
  }
  postDetailsToFirestore() async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User? user = _auth.currentUser;
    user!.updatePhotoURL(DownLoadUrl);
    await firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .set(
        {"uid" : user?.uid,
        "fullName" : fullNameEditingController.text,
        "userName" : userNameEditingController.text,
        "email":user?.email,
        "photo":DownLoadUrl,
        "themes" : ["Informatique","Biologie","Mathématiques","Physique","Chimie","Économie",
          "Électronique","Histoire-géographie","Géopolitique","Sciences politiques","littérature","philosophie",
          "Art","Music","Médicine","Environnement"]
        }).then((_) {
          print(user?.uid);
        });
    Fluttertoast.showToast(msg: "Account created successfully :) ");

    Navigator.pushAndRemoveUntil(
        (context),
        MaterialPageRoute(builder: (context) => SelectPage(user: user,)),
            (route) => false);
  }
}

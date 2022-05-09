import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/models/users/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:evetoapp/providers/eventProvider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';

import '../dashboard.dart';
import '../login.dart';

class LoginController with ChangeNotifier{

  static Future<User?> signInWithGoogle({required BuildContext context}) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user;

    final GoogleSignIn googleSignIn = GoogleSignIn();

    final GoogleSignInAccount? googleSignInAccount =
    await googleSignIn.signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication googleSignInAuthentication =
      await googleSignInAccount.authentication;

      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );

      try {
        final UserCredential userCredential =
        await auth.signInWithCredential(credential);

        user = userCredential.user!;
      } on FirebaseAuthException catch (e) {
        if (e.code == 'account-exists-with-different-credential') {
          Fluttertoast.showToast(msg: e.code);

        } else if (e.code == 'invalid-credential') {
          Fluttertoast.showToast(msg: e.code);

        }
      } catch (e) {
        Fluttertoast.showToast(msg: e.toString());
      }    }
    // puting data in firestore db

    UserModel userModel = UserModel();
    userModel.email = user?.email;
    userModel.uid = user?.uid;
    userModel.fullName = user?.displayName;
    userModel.userName = user?.displayName;
    userModel.photoURL =user?.photoURL;

    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

    await firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .set(
        {"uid" : user?.uid,
          "fullName" : user?.displayName,
          "userName" : user?.displayName,
          "email":user?.email,
          "photo":user?.photoURL,
          "category" : ["computer science","biology","art"]
        }).then((_) {
      print(user?.uid);
      firebaseFirestore
          .collection("users")
          .doc(user?.uid)
          .collection("likedEvents")
          .add({"eventID": "true"});
    });


    if (user != null) {
      Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => MultiProvider(providers: [
          ChangeNotifierProvider.value(value: eventProvider.initialize())
        ],
            child: Dashboard(user: user!))),
      );
    }
    return user;
  }

  static Future<void> signOut({required BuildContext context}) async {
    final GoogleSignIn googleSignIn = GoogleSignIn();

    try {

        await googleSignIn.signOut();

      await FirebaseAuth.instance.signOut();
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error signing out. Try again.');

    }
  }
  static Future<FirebaseApp> initializeFirebase({
    required BuildContext context,
  }) async {
    FirebaseApp firebaseApp = await Firebase.initializeApp();

    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              textTheme:GoogleFonts.nunitoSansTextTheme(
                Theme.of(context).textTheme,
              )
          ),
          home:
          Dashboard(user: user,),
        )
        ),
      );
    }else{
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => Login(
          ),
        ),
      );
    }

    return firebaseApp;
  }}
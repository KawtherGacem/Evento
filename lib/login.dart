
import 'package:evetoapp/signUp.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'controllers/loginController.dart';
import 'dashboard.dart';

class Login extends StatefulWidget {
  const Login({GlobalKey? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();

}

class _LoginState extends State<Login> {
  static final TextEditingController emailController = TextEditingController();
  static final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  final _auth = FirebaseAuth.instance;
  String? errorMessage;
  @override
  // void initState() {
  // super.initState();
  // }

  @override
  Widget build(BuildContext context) {

     final emailField = TextFormField(
      autofocus: false,
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      // validator: ,
      cursorColor: const Color(0xFF513ADA),
      onSaved: (value){
        if (value != null) {
          emailController.text = value;
        }
      },
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white54,
          prefixIcon: const Icon(Icons.mail,color: Color(0xFF513ADA)),
          contentPadding: EdgeInsets.symmetric(horizontal:20.w,vertical:30.h),
          hintText: "Email",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF513ADA)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )
      ),
    );

    final passwordField = TextFormField(
      autofocus: false,
      controller: passwordController,
      // validator: ,
      cursorColor: const Color(0xFF513ADA),
      onSaved: (value){
        if (value != null) {
          passwordController.text = value;
        }
      },
      textInputAction: TextInputAction.done,
      decoration: InputDecoration(
        labelStyle: TextStyle(fontSize: 50.sp),
        filled: true,
          fillColor: Colors.white54,
          prefixIcon: const Icon(Icons.vpn_key_rounded,color:  Color(0xFF513ADA)),
          contentPadding: EdgeInsets.symmetric(horizontal:20.w,vertical:30.h),
          hintText: "Password",
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
            borderSide: const BorderSide(color: Color(0xFF513ADA)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(30),
          )
      ),
      obscureText: true,
    );

    final loginButton = Material(
      elevation: 5,
      borderRadius: BorderRadius.circular(30),
      color: const Color(0xFF513ADA),
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        onPressed: (){
        login(emailController.text, passwordController.text);
        },
        child: Text("Login",textAlign: TextAlign.center,style: TextStyle(
            fontSize:55.sp ,color: const Color(0xFFFFFFFF),fontWeight: FontWeight.bold,
        )),
      ),
    );

    return ScreenUtilInit(
          designSize: const Size(1080,2280),
          builder: (_) {
            return Scaffold(
              resizeToAvoidBottomInset:false,
              body: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                      minHeight: MediaQuery
                          .of(context)
                          .size
                          .height
                  ),
                  child: Container(
                    decoration: const BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/background2.png"),
                          fit: BoxFit.fill,
                        )
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 150.w),
                            child: Form(
                              key: _formKey,
                              child: SingleChildScrollView(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.only(top: 150.h),
                                      height: 550.h,
                                      child: Image.asset(
                                        "assets/logo-evento.png",
                                        fit: BoxFit.contain,),
                                    ),
                                    Container(
                                        margin: EdgeInsets.only(top: 100.h),
                                        child: emailField),
                                    Container(
                                        margin: EdgeInsets.only(top: 70.h),
                                        child: passwordField),
                                    Container(
                                        margin: EdgeInsets.only(top: 70.h),
                                        child: loginButton),
                                    Container(
                                      margin: EdgeInsets.only(top: 30.h),
                                      child: Row(
                                          mainAxisAlignment: MainAxisAlignment
                                              .center,
                                          children: <Widget>[
                                            Text("Don't have an account? ",
                                              style: TextStyle(
                                                  fontSize: 40.sp
                                              ),),
                                            GestureDetector(
                                              onTap: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            const SignUp()));
                                              },
                                              child: Text(
                                                "SignUp",
                                                style: TextStyle(
                                                    color: Colors.grey,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 40.sp),
                                              ),
                                            )
                                          ]),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Container(
                            margin: EdgeInsets.only(top: 370.h, left: 150.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Or continue with",
                                  style: TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 40.sp),
                                ),
                                Container(
                                  margin: EdgeInsets.symmetric(vertical: 40.h),
                                  child: Row(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(3.h),
                                        height: 170.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                50)
                                        ),
                                        child: GestureDetector(
                                          child: Image.asset("assets/google.png",
                                            fit: BoxFit.contain,),
                                          onTap: () {
                                            LoginController.signInWithGoogle(context: context);
                                            // if (user != null) {
                                            //   Navigator.push(
                                            //     context,
                                            //     MaterialPageRoute(builder: (context) => Dashboard(user: user)),
                                            //   );
                                            // }
                                            },
                                        ),
                                      ),
                                      Container(
                                        margin: EdgeInsets.symmetric(
                                            horizontal: 40.h),
                                        padding: EdgeInsets.all(3.h),
                                        height: 170.h,
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius: BorderRadius.circular(
                                                50)
                                        ),
                                        child: Image.asset("assets/facebook.png",
                                          fit: BoxFit.contain,),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          });
  }
  void login(String email, String password) async {
    if (_formKey.currentState!.validate()) {
      try {
        await _auth
            .signInWithEmailAndPassword(email: email, password: password)
            .then((uid) => {
           if (_auth.currentUser != null) {
          Fluttertoast.showToast(msg: "Login Successful"),
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => Dashboard(user: _auth.currentUser!))

        ),}
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
      }
    }
  }


}


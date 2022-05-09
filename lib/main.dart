import 'package:evetoapp/controllers/loginController.dart';
import 'package:evetoapp/providers/eventProvider.dart';
import "package:firebase_core/firebase_core.dart";
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MultiProvider(
      providers: [ChangeNotifierProvider.value(value: eventProvider.initialize())],
      child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: Size(1080,2280),
      builder: (_) {
        return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
                textTheme:GoogleFonts.nunitoSansTextTheme(
                  Theme.of(context).textTheme,
                )
            ),
            home: splashscreen(),
        );
      },
    );
  }
}
class splashscreen extends StatefulWidget { //new class for splashscreen
  const splashscreen({Key? key}) : super(key: key);

  @override
  _splashscreenState createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  @override
  initState() {
    Future.delayed(Duration(seconds:5), () { //her duration is 6s
       Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
            textTheme:GoogleFonts.nunitoSansTextTheme(
             Theme.of(context).textTheme,
            )
           ),
           home:
           // const Login(),
            FutureBuilder(
             future: LoginController.initializeFirebase(context: context),
             builder: (context, snapshot) {
               if (snapshot.hasError) {
                 return Text('Error initializing Firebase');
               } else if (snapshot.connectionState == ConnectionState.done) {
                 return Container();
               }
               return const CircularProgressIndicator(
                 valueColor: AlwaysStoppedAnimation<Color>(
                   Color(0xFF513ADA),
                 ),
               );
             },
           ),
              );}
          ));//move it to dashboard screen
    });
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body:
      Center(
        child: Container(
          margin: EdgeInsets.all(10.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [

              Lottie.asset('assets/logoanime.json'),
            ],
          ),
        ),
      ),

    );


  }
}


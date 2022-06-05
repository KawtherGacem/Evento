import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'login.dart';
class SkipPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) =>
      SafeArea(
        child: IntroductionScreen(
          pages: [
            PageViewModel(
              bodyWidget: Text("profitez de différents événements culturels musicaux et artistiques ou scientifiques .",textAlign: TextAlign.justify,style: TextStyle(fontSize: 24),),
              titleWidget: Text(""),
              image: Container(
                height: 400,
                width: 400,
                margin: EdgeInsets.only(top: 0,right: 0),
                child: Image.asset("assets/skip1.png",width: 600,)),
              decoration: getPageDecoration(),
            ),
            PageViewModel(
              bodyWidget: Text("avec des notifications quotidiennes, vous ne manquerez pas vos événements et vous n'aurez pas à vous inquiéter",textAlign: TextAlign.justify,style: TextStyle(fontSize: 22),),
              titleWidget: Text(""),
              image: Image.asset("assets/skip2.png"),
              decoration: getPageDecoration(),
            ),
          ],
          done: Text('Read', style: TextStyle(fontWeight: FontWeight.w600,fontSize: 20)),
          onDone: () => goToHome(context),
          showSkipButton: true,
          skip: Text('Skip',style: TextStyle(fontSize: 20),),
          onSkip: () => goToHome(context),
          next: Icon(Icons.arrow_forward),
          dotsDecorator: getDotDecoration(),
          onChange: (index) => print('Page $index selected'),
          globalBackgroundColor: Colors.white,
          dotsFlex: 0,
          nextFlex: 0,
          // isProgressTap: false,
          // isProgress: false,
          // showNextButton: false,
          // freeze: true,
          // animationDuration: 1000,
        ),
      );
  void goToHome(context) => Navigator.of(context).pushReplacement(
    MaterialPageRoute(builder: (_) => Login()),
  );
  // Widget buildImage(String path) =>
  //     Center(child: Image.asset(path,height: 700, width: 370,fit: BoxFit.cover,));
  DotsDecorator getDotDecoration() => DotsDecorator(
    color: Color(0xFFBDBDBD),
    //activeColor: Colors.orange,
    size: Size(10, 10),
    activeSize: Size(22, 10),
    activeShape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(24),
    ),
  );
  PageDecoration getPageDecoration() => PageDecoration(
    pageColor: Colors.white,
    imagePadding: EdgeInsets.all(30),
  );
}
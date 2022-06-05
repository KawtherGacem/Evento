import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/dashboard.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'filterChip.dart';

class SelectPage extends StatefulWidget {
  const SelectPage({Key? key, required User user}) : super(key: key);


  @override
  State<SelectPage> createState() => _SelectPageState();
}


class _SelectPageState extends State<SelectPage> {
  List<String> selectedThemesList = [];
  List<String> themesList = [
    "Informatique",
    "Biologie",
    "Mathématiques",
    "Physique",
    "Chimie",
    "Économie",
    "Électronique",
    "Histoire-géographie",
    "Géopolitique",
    "Sciences politiques",
    "littérature",
    "philosophie",
    "Art",
    "Music",
    "Médicine",
    "Environnement",
    "Cuisine"
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child:  Column(
          // mainAxisAlignment: MainAxisAlignment.center,
          // crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height:60 ,),
            Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50.0,vertical: 40),
            child:
            Image(image: Image.asset("assets/logotwil.png").image),),
            Padding(
              padding: const EdgeInsets.only(right: 50.0,),
              child:
            Text("Selectionner vos themes préférés",style: TextStyle(fontSize: 20),),),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: SingleChildScrollView(
                child: FilterChips(
                  categories:
                  themesList,
                  onSelectionChanged:
                      (selectedList) {
                    setState(() {
                      selectedThemesList =
                          selectedList;
                    });
                  },

                ),
              ),
            ),
            SizedBox(
              height: 40,
            ),
            Material(
              elevation: 5,
              borderRadius: BorderRadius.circular(30),
              color: const Color(0xFF513ADA),
              child: MaterialButton(
                minWidth: 200,
                onPressed: (){
                  addThemes(selectedThemesList);
                  Get.to(Dashboard(user: FirebaseAuth.instance.currentUser!));
                },
                child: Text("Confirmer",textAlign: TextAlign.center,style: TextStyle(
                  fontSize:15 ,color: const Color(0xFFFFFFFF),fontWeight: FontWeight.bold,
                )),
              ),
            )

          ],
        ),
      ),
    );
  }

  Future<void> addThemes(List<String> selectedThemesList) async {
    FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
    User user= FirebaseAuth.instance.currentUser!;
    await firebaseFirestore
        .collection("users")
        .doc(user?.uid)
        .update(
        {
          "themes" : selectedThemesList
        }).then((_) {
      print(user?.uid);
    });
  }
}

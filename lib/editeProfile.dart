import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'controllers/loginController.dart';




class Editeprofile extends StatefulWidget {
  @override
  _EditeprofileState createState() => _EditeprofileState();
}
class _EditeprofileState extends State<Editeprofile> {
  File? pickedImage;
  bool showPassword = false;
  bool loading = false;
  var _image;
  var photoURL;
  LoginController photoajouter= LoginController();

  Widget imagePickerOption() {
    return Container(
      child: ClipRRect(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(10.0),
          topRight: Radius.circular(10.0),
        ),
        child: Container(
          color: Colors.white,
          height: 250,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  "Pic Image From",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    pickImage(ImageSource.camera);
                  },
                  icon: const Icon(Icons.camera),
                  label: const Text("CAMERA"),
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    pickImage(ImageSource.gallery);
                  },
                  icon: const Icon(Icons.image),
                  label: const Text("GALLERY"),
                ),
                const SizedBox(
                  height: 10,
                ),
                ElevatedButton.icon(
                  onPressed: () {
                    Get.back();
                  },
                  icon: const Icon(Icons.close),
                  label: const Text("CANCEL"),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  pickImage(ImageSource imageType) async {
    final _storage = FirebaseStorage.instance;
    try {
      final photo = await ImagePicker().pickImage(source: imageType);

      if (photo == null) return;
      final tempImage = File(photo.path);
      setState(() {
        pickedImage = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 1,
        iconTheme: IconThemeData(color: Colors.black),
        actions: [
          IconButton(
            icon: Icon(
              Icons.check,
              color: Colors.white,
            ),
            onPressed: (
                ) {
            },
          ),
        ],
      ),
      body: Container(
        padding: EdgeInsets.only(left: 16, top: 25, right: 16),
        child: GestureDetector(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Text(
                "Modifier Profile",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
              ),
              SizedBox(
                height: 15,
              ),
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 150,
                      height: 150,


                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.deepPurpleAccent, width: 4),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(100),
                        ),
                      ),
                      child: ClipOval(
                        child:  pickedImage != null
                            ? Image.file(
                          pickedImage!,
                          width: 170,
                          height: 170,
                          fit: BoxFit.cover,
                        )
                            : Image.asset(
                          'assets/avatar.JPG',
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
                              color: Colors.deepPurpleAccent,
                            ),
                            color: Colors.deepPurpleAccent,
                          ),
                          child: IconButton(
                            onPressed: () async{
                              final data = await showModalBottomSheet(context: context,
                                  builder: (context) {return imagePickerOption();
                                  });
                              if(data != null){
                                loading = true;
                                setState(() {
                                });
                              }
                              await uploadPic(context);
                              photoajouter.addPhoto(photoURL.toString());
                            },

                            icon: const Icon(
                              Icons.edit,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        )),
                  ],
                ),
              ),
              SizedBox(
                height: 35,
              ),
              buildTextField("Full Name","torki meriem amira" , false),
              buildTextField("E-mail", "torkimeriemamira@gmail.com", false),
              buildTextField("Password", "********", true),
              buildTextField("Location", "Algeria", false),
              SizedBox(
                height: 35,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildTextField(
      String labelText, String placeholder, bool isPasswordTextField) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        obscureText: isPasswordTextField ? showPassword : false,
        decoration: InputDecoration(
            suffixIcon: isPasswordTextField
                ? IconButton(
              onPressed: () {
                setState(() {
                  showPassword = !showPassword;
                });
              },
              icon: Icon(
                Icons.remove_red_eye,
                color: Colors.deepPurpleAccent,
              ),
            )
                : null,
            contentPadding: EdgeInsets.only(bottom: 3),
            labelText: labelText,
            floatingLabelBehavior: FloatingLabelBehavior.always,
            hintText: placeholder,
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }



  Future uploadPic(BuildContext context) async {
    Reference ref = FirebaseStorage.instance.ref();
    TaskSnapshot addImg =
    await ref.child("image/"+DateTime.now().toString()).putFile(_image!);
    if (addImg.state == TaskState.success) {
      print("added to Firebase Storage");
    }
    var DUrl = addImg.ref.getDownloadURL();
    await DUrl.then((result)  {
      setState(() {
        if (result is String){
          photoURL=result;
        }
      });
    });}
}
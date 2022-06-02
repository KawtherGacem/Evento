// import 'dart:html';
import 'dart:io';
import 'package:evetoapp/eventPage.dart';
import 'package:evetoapp/models/users/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import 'controllers/loginController.dart';




class EditeProfile extends StatefulWidget {
  const EditeProfile({Key? key, required UserModel user})
      : _user = user,
        super(key: key);

  final UserModel _user;
  @override
  _EditeProfileState createState() => _EditeProfileState();
}
class _EditeProfileState extends State<EditeProfile> {
  late UserModel user;
  File? pickedImage;
  bool showPassword = false;
  bool loading = false;
  var _image;
  var photoURL;


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
        _image = tempImage;
      });

      Get.back();
    } catch (error) {
      debugPrint(error.toString());
    }
  }





  TextEditingController fullNameController = TextEditingController();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController oldPassword = TextEditingController();
  TextEditingController newPassword = TextEditingController();

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
          photoURL = result;
        }
      });
    });
  }

  @override
  void initState() {
    user = widget._user;

  }

  @override
  Widget build(BuildContext context) {
    fullNameController.text=user.fullName!;
    userNameController.text=user.userName!;
    emailController.text=user.email!;
    // fullName.text=user.fullName!;

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
            onPressed: () async {
              await uploadPic(context);
              updateUser(fullNameController.text,userNameController.text,emailController.text,photoURL);
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
                            : Image.network(
                          user.photoURL!,
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
              buildTextField("Nom Complet", false,fullNameController),
              buildTextField("Nom d'utilisateur", false,userNameController),
              buildTextField("E-mail", false,emailController),
            TextFormField(
              autofocus: false,
              controller: oldPassword,
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
                  oldPassword.text = value!;
                },
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  prefixIcon: Icon(Icons.vpn_key),
                  contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                  hintText: "Password",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                )),

              TextFormField(
              autofocus: false,
              controller: newPassword,
              obscureText: true,
              validator: (value) {
                // if (confirmPasswordEditingController.text !=
                //     passwordEditingController.text) {
                //   return "Password don't match";
                // }
                // return null;
              },
              onSaved: (value) {
                // confirmPasswordEditingController.text = value!;
              },
              textInputAction: TextInputAction.done,
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.vpn_key),
                contentPadding: EdgeInsets.fromLTRB(20, 15, 20, 15),
                hintText: "Confirm Password",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
        )),
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
      String labelText, bool isPasswordTextField,TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 35.0),
      child: TextField(
        controller: controller,
        obscureText: isPasswordTextField ? showPassword : false,
        keyboardType: TextInputType.name,
        onSubmitted: (value) {
          controller.text = value;
        },
        textInputAction: TextInputAction.next,
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
            hintStyle: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            )),
      ),
    );
  }





  Future<void> updateUser(String fullName,String userName, String email,String photoURL) async {
    User user1 = FirebaseAuth.instance.currentUser!;
    await user1.updateDisplayName(userName);
    await user1.updatePhotoURL(photoURL);
    await user1.updateEmail(email);


  }
}
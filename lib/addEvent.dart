import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:evetoapp/controllers/addEventController.dart';
import 'package:filter_list/filter_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:intl/intl.dart';

class addEvent extends StatefulWidget {
  const addEvent({Key? key}) : super(key: key);

  @override
  State<addEvent> createState() => _addEventState();
}

class SelectedListController extends GetxController{
  var selectedList = List<String>.empty(growable: true).obs;
}

class _addEventState extends State<addEvent> {
  static final TextEditingController titleController = TextEditingController();
  static final TextEditingController descriptionController = TextEditingController();
  static final TextEditingController timeController = TextEditingController();
  static final TextEditingController dateController = TextEditingController();
  final _auth = FirebaseAuth.instance;
  addEventController eventController= addEventController();



  @override
  void initState() {
    controller.selectedList=List<String>.empty(growable: true).obs;
    super.initState();
  }

  var controller = Get.put(SelectedListController());
  final titleField= TextFormField(
    autofocus: false,
    controller: titleController,
    keyboardType: TextInputType.text,
    // validator: ,
    cursorColor: const Color(0xFF513ADA),
    onSaved: (value){
      if (value != null) {
        titleController.text = value;
      }
    },
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white54,
        hintText: "Event title",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF513ADA)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        )
    ),
  );

  final descriptionField= TextField(

    autofocus: false,
    controller: descriptionController,
    keyboardType: TextInputType.multiline,
    minLines: 4,
    maxLines: null,
    // validator: ,
    cursorColor: const Color(0xFF513ADA),
    onSubmitted: (value){
      if (value != null) {
        descriptionController.text = value;
      }
    },
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white54,
        hintText: "Event description",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF513ADA)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        )
    ),
  );
  final dateField= DateTimeField(
    format: DateFormat("dd-MM-yyyy"),
    controller: dateController,
    onSaved: (value){
      if (value != null) {
        dateController.text = DateFormat("dd-MM-yyyy").format(value);
      }
    },
    onShowPicker: (context, currentValue) {
      return showDatePicker(
        context: context,
        firstDate: DateTime.now(),
        lastDate: DateTime(2100),
        initialDate: currentValue ?? DateTime.now(),

      );
    },
  );
  final timeField= DateTimeField(
    controller: timeController,
    format: DateFormat("HH:mm"),
    onSaved: (value){
      if (value != null) {
        timeController.text = value as String ;
      }
    },
    onShowPicker: (context, currentValue) async {
      final time = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
      );
      return DateTimeField.convert(time);
    },
  );
  File imageFile = File("gs://evento-app-2022.appspot.com/images/logo evento tali.png");
  var _image;
  var DownLoadUrl;

  @override
  Widget build(BuildContext context) {

    List<String> categoryList = ["computer science","biology","art","music",
      "medicine","electronics"];

   void openFilterDialog(BuildContext context) async {
     await FilterListDialog.display<String>(
       context,
       listData: categoryList,
       selectedListData: controller.selectedList,
       headlineText: "Choose event category",

       choiceChipLabel: (item) {
         /// Used to display text on chip
         return item;
       },
       validateSelectedItem: (list, val) => list!.contains(val),
       onItemSearch: (category, query) {
         return category.toLowerCase().contains(query.toLowerCase());
       },
       onApplyButtonClick: (list) {
         controller.selectedList.value = List<String>.from(list!);
         Get.back();
       },
     );
   }

    Future getImage() async {

      var image = await ImagePicker().pickImage(source: ImageSource.gallery);
      setState(() {
        _image = File(image!.path);
      });

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
            DownLoadUrl=result;
          }
        });
      });}
      // setState((){
      //   DownLoadUrl = DUrl ;
      //  });
      // String fileName = basename(_image.path);
      // FirebaseStorage storage = FirebaseStorage.instance;
      // Reference firebaseStorageRef = storage.ref()
      //     .child("images/");
      // UploadTask uploadTask = firebaseStorageRef.putFile(File(_image.path));
      // uploadTask.then((res) {
      //   return res.ref.getDownloadURL();
      // });


      return Scaffold(
        appBar: AppBar(
          title: Text("Add an event"),
          centerTitle: true,
        ),
        body: Container(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 40,
                ),
                titleField,
                Container(
                    child: descriptionField),

                timeField,
                dateField,
                Obx(()=> controller.selectedList.value.length==0 ? Text("no category selected")
                    :Wrap(
                        children:
                          controller.selectedList.map((String e) =>
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Chip(
                                label: Text(e),
                              ),
                            )).toList()

                )),

                 SizedBox(
                    width: 20,
                  ),
                    Material(
                      elevation: 5,
                      borderRadius: BorderRadius.circular(50),
                      color: const Color(0xFF513ADA),
                      child: MaterialButton(
                        minWidth: 20,
                        onPressed: (){
                          openFilterDialog(context);

                        },
                        child: Icon(Icons.add,color: Colors.white,),
                      ),
                    ),
                ElevatedButton(
                    onPressed: (){
                      getImage();
                      },
                    child: Text("Add photo")),
                _image == null
                    ? Text('No image selected.')
                    : Image.file(File(
                  _image.path),
                  height: 300,
                ),
                SizedBox(
                  height: 50,
                ),
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(30),
                  color: const Color(0xFF513ADA),
                  child: MaterialButton(
                    minWidth: MediaQuery.of(context).size.width,
                    onPressed: () async {
                        await uploadPic(context);
                        eventController.addNewEvent(titleController.text,descriptionController.text,controller.selectedList,_auth.currentUser,DownLoadUrl.toString(),dateController.text,timeController.text);
                        Fluttertoast.showToast(msg: "Event added");

                    },
                    child: Text("Add",textAlign: TextAlign.center,style: TextStyle(
                      fontSize:20 ,color: const Color(0xFFFFFFFF),fontWeight: FontWeight.bold,
                    )),
                  ),
                )

              ],
            ),
          ),
        )
    ),
      );


  }

  // Widget _imageSection(BuildContext context) {
  //   return (_image == null)
  //       ? Stack(
  //       children:[
  //         Icon(Icons.add_a_photo_outlined),
  //         Container(
  //           width:
  //           MediaQuery.of(context).size.width,
  //           height: 220,
  //           child: Card(
  //             elevation: 3.0,
  //             color: Colors.white,
  //             shadowColor: Colors.grey,
  //             child: Text("No image selected"),
  //           ),
  //         ),
  //       ]
  //       )
  //           : Stack(
  //            children:[
  //              Icon(Icons.add_a_photo_outlined),
  //              Container(
  //             width: MediaQuery.of(context).size.width,
  //             height:450,
  //             child: Column(
  //               children: [
  //                 Image.file(File(_image.path),
  //                   fit: BoxFit.cover,
  //                 ),
  //               ],
  //             ),
  //           ),
  //
  //
  //            ]);
  //         }
}

import 'package:evetoapp/controllers/addEventController.dart';
import 'package:filter_list/filter_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';

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


   return Container(
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

              Row(
                children: [
                  Column(
                  children: [
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
                  ],
                ),SizedBox(
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
                  )

                ]
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
                  onPressed: (){
                      eventController.addNewEvent(titleController.text,descriptionController.text,controller.selectedList,_auth.currentUser);
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
    );
  }
}

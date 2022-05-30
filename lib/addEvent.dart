import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:evetoapp/controllers/addEventController.dart';
import 'package:filter_list/filter_list.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:intl/intl.dart';

class addEvent extends StatefulWidget {
  const addEvent({Key? key}) : super(key: key);

  @override
  State<addEvent> createState() => _addEventState();
}

class SelectedListController extends GetxController {
  var selectedCategoryList = List<String>.empty(growable: true).obs;
  var selectedThemesList = List<String>.empty(growable: true).obs;
}

class _addEventState extends State<addEvent> {
  static final TextEditingController titleController = TextEditingController();
  static final TextEditingController descriptionController =
      TextEditingController();
  static final TextEditingController inscriptionUrlController =
      TextEditingController();

  late Timestamp startingDate;
  late Timestamp endingDate;

  final _auth = FirebaseAuth.instance;
  addEventController eventController = addEventController();

  Geoflutterfire geo = Geoflutterfire();
  late GeoFirePoint eventLocation;
  late GoogleMapController mapController;
  late LatLng center;
  final Set<Marker> markers = Set();

  @override
  void initState() {
    controller.selectedCategoryList = List<String>.empty(growable: true).obs;
    controller.selectedThemesList = List<String>.empty(growable: true).obs;

    super.initState();
  }

  var controller = Get.put(SelectedListController());

  final titleField = TextFormField(
    autofocus: false,
    controller: titleController,
    keyboardType: TextInputType.multiline,
    maxLines: null,
    minLines: 1,
    // validator: ,
    cursorColor: const Color(0xFF513ADA),
    onSaved: (value) {
      if (value != null) {
        titleController.text = value;
      }
    },
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
        )),
  );

  final descriptionField = TextField(
    autofocus: false,
    controller: descriptionController,
    keyboardType: TextInputType.multiline,
    minLines: 4,
    maxLines: null,
    // validator: ,
    cursorColor: const Color(0xFF604BE0),
    onSubmitted: (value) {
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
        )),
  );

  final inscriptionUrlField = TextField(
    autofocus: false,
    controller: inscriptionUrlController,
    keyboardType: TextInputType.multiline,
    minLines: 1,
    maxLines: null,
    cursorColor: const Color(0xFF513ADA),
    onSubmitted: (value) {
      if (value != null) {
        inscriptionUrlController.text = value;
      }
    },
    textInputAction: TextInputAction.next,
    decoration: InputDecoration(
        filled: true,
        fillColor: Colors.white54,
        hintText: "Lien d'inscription",
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: const BorderSide(color: Color(0xFF513ADA)),
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
        )),
  );

  var _image;
  var DownLoadUrl;

  @override
  void dispose() {
    _image = null;
    titleController.clear();
    descriptionController.clear();
    markers.clear();
    // controller.dispose();
    // mapController.dispose();
    super.dispose();
  }

  int currentStep = 0;

  @override
  Widget build(BuildContext context) {
    List<String> categoryList = [
      "Concert",
      "Salon professionnel",
      "Salon international",
      "Séminaire",
      "Congrès",
      "Conférence",
      "Spectacle",
      "Festival",
      "Team-building",
      "Événement scientifique",
      "Événement culturelle",
      "Événement sportif"
    ];

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

    void openCategoryFilterDialog(BuildContext context) async {
      await FilterListDialog.display<String>(
        context,
        listData: categoryList,
        selectedListData: controller.selectedCategoryList,
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
          controller.selectedCategoryList.value = List<String>.from(list!);
          Get.back();
        },
      );
    }

    void openThemeFilterDialog(BuildContext context) async {
      await FilterListDialog.display<String>(
        context,
        listData: themesList,
        selectedListData: controller.selectedThemesList,
        headlineText: "Choisir les themes qui convient a votre événement",
        choiceChipLabel: (item) {
          /// Used to display text on chip
          return item;
        },
        validateSelectedItem: (list, val) => list!.contains(val),
        onItemSearch: (theme, query) {
          return theme.toLowerCase().contains(query.toLowerCase());
        },
        onApplyButtonClick: (list) {
          controller.selectedThemesList.value = List<String>.from(list!);
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
          }
        });
      });
    }

    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.white10,
          centerTitle: true,
          title: SizedBox(
            width: 125,
            // margin: EdgeInsets.only(left: 10),
            child: Image.asset("assets/logotwil.png"),
          ),
          // title: Text("Create event",style: TextStyle(color:Color(0xFF513ADA),fontWeight: FontWeight.bold,fontSize: 25),),
        ),
        body: Theme(
          data: Theme.of(context).copyWith(
              colorScheme: ColorScheme.light(primary: Color(0xFF513ADA))),
          child: Stepper(
            type: StepperType.horizontal,
            currentStep: currentStep,
            onStepContinue: () async {
              if (currentStep == 2) {
                await uploadPic(context);
                if (endingDate.toDate().isBefore(startingDate.toDate())) {
                  Fluttertoast.showToast(
                      msg: "La date de fin est avant la date de debut");
                } else {
                  await eventController.addNewEvent(
                      titleController.text,
                      descriptionController.text,
                      controller.selectedCategoryList,
                      controller.selectedThemesList,
                      _auth.currentUser,
                      DownLoadUrl.toString(),
                      startingDate,
                      endingDate,
                      eventLocation,
                      inscriptionUrlController.text);
                  Fluttertoast.showToast(msg: "l'evenement a ete ajoute");
                }
              } else {
                setState(() => currentStep += 1);
              }
            },
            onStepCancel: () {
              if (currentStep != 0) {
                setState(() => currentStep -= 1);
              }
            },
            onStepTapped: (step) => setState(() => currentStep = step),
            controlsBuilder:
                (BuildContext context, ControlsDetails controlsDetails) {
              return Padding(
                padding: EdgeInsets.all(20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Material(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFF513ADA),
                      child: MaterialButton(
                        minWidth: 120,
                        onPressed: controlsDetails.onStepCancel,
                        child: Text("Annuler",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: const Color(0xFFFFFFFF),
                            )),
                      ),
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    Material(
                      borderRadius: BorderRadius.circular(30),
                      color: const Color(0xFF513ADA),
                      child: MaterialButton(
                        minWidth: 120,
                        onPressed: controlsDetails.onStepContinue,
                        child: Text(
                            controlsDetails.currentStep == 2
                                ? "Ajouter"
                                : "Continuer",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 20,
                              color: const Color(0xFFFFFFFF),
                            )),
                      ),
                    ),
                  ],
                ),
              );
            },
            steps: [
              Step(
                state: currentStep > 0 ? StepState.complete : StepState.indexed,
                isActive: currentStep >= 0,
                title: Text("Informations"),
                content: Container(
                    child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        titleField,
                        Container(child: descriptionField),
                        inscriptionUrlField,
                        DateTimeField(
                          format: DateFormat("yyyy-MM-dd HH:mm"),
                          onSaved: (value) {
                            if (value != null) {
                              setState(() {
                                startingDate = Timestamp.fromDate(value);
                              });
                            }
                          },
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              startingDate = Timestamp.fromDate(
                                  DateTimeField.combine(date, time));
                              return DateTimeField.combine(date, time);
                            } else {
                              return currentValue;
                            }
                          },
                        ),
                        DateTimeField(
                          format: DateFormat("yyyy-MM-dd HH:mm"),
                          onSaved: (value) {
                            if (value != null) {
                              setState(() {
                                endingDate = Timestamp.fromDate(value);
                              });
                            }
                          },
                          onShowPicker: (context, currentValue) async {
                            final date = await showDatePicker(
                                context: context,
                                firstDate: DateTime.now(),
                                initialDate: currentValue ?? DateTime.now(),
                                lastDate: DateTime(2100));
                            if (date != null) {
                              final time = await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.fromDateTime(
                                    currentValue ?? DateTime.now()),
                              );
                              endingDate = Timestamp.fromDate(
                                  DateTimeField.combine(date, time));
                              return DateTimeField.combine(date, time);
                            } else {
                              return currentValue;
                            }
                          },
                        ),
                        _image == null
                            ? Container(
                                height: 300,
                                color: Colors.grey,
                                child: Center(
                                  child: IconButton(
                                    onPressed: () {
                                      getImage();
                                    },
                                    icon: Icon(Icons.add_a_photo_outlined),
                                  ),
                                ),
                              )
                            : Stack(
                                children: [
                                  Image.file(
                                    File(_image.path),
                                    height: 300,
                                  ),
                                  Center(
                                    child: IconButton(
                                      onPressed: () {
                                        getImage();
                                      },
                                      icon: Icon(Icons.add_a_photo_outlined),
                                    ),
                                  )
                                ],
                              ),
                      ],
                    ),
                  ),
                )),
              ),
              Step(
                state: currentStep > 1 ? StepState.complete : StepState.indexed,
                isActive: currentStep >= 1,
                title: Text("Location"),
                content: SizedBox(
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25)),
                        padding: EdgeInsets.all(0),
                        margin: EdgeInsets.all(0),
                        height: 410,
                        width: double.infinity,
                        child: GoogleMap(
                          gestureRecognizers:
                              <Factory<OneSequenceGestureRecognizer>>[
                            new Factory<OneSequenceGestureRecognizer>(
                              () => new EagerGestureRecognizer(),
                            ),
                          ].toSet(),
                          mapToolbarEnabled: true,
                          initialCameraPosition: CameraPosition(
                            target: LatLng(35.7011269, -0.5838205),
                            zoom: 10,
                          ),
                          onMapCreated: _onMapCreated,
                          compassEnabled: true,
                          onTap: (object) {
                            setState(() {
                              center =
                                  LatLng(object.latitude, object.longitude);
                              setMarker(object);
                              eventLocation = geo.point(
                                  latitude: object.latitude,
                                  longitude: object.longitude);
                              // eventLocation = GeoPoint(object.latitude, object.longitude);
                            });
                          },
                          markers: markers,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Step(
                  state: controller.selectedCategoryList.isNotEmpty
                      ? StepState.complete
                      : StepState.indexed,
                  isActive: currentStep >= 2,
                  title: Text("Categories"),
                  content: Column(children: [
                    Row(
                      children: [
                        Text(
                          "Categories",
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          width: 210,
                        ),
                        IconButton(
                          iconSize: 35,
                          onPressed: () {
                            openCategoryFilterDialog(context);
                          },
                          icon:
                              Icon(Icons.add_circle, color: Color(0xFF513ADA)),
                        ),
                      ],
                    ),
                    Divider(
                      height: 2,
                    ),
                    Obx(() => controller.selectedCategoryList.value.length == 0
                        ? Container(
                            height: 100,
                            child: Text("Aucune Categorie n'été  selectionné "))
                        : SizedBox(
                            height: 100,
                            child: SingleChildScrollView(
                              child: Wrap(
                                  children: controller.selectedCategoryList
                                      .map((String e) => Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Chip(
                                              label: Text(e),
                                            ),
                                          ))
                                      .toList()),
                            ),
                          )),
                    Row(
                      children: [
                        Text(
                          "Themes",
                          style: TextStyle(fontSize: 17),
                        ),
                        SizedBox(
                          width: 230,
                        ),
                        IconButton(
                          iconSize: 35,
                          onPressed: () {
                            openThemeFilterDialog(context);
                          },
                          icon:
                              Icon(Icons.add_circle, color: Color(0xFF513ADA)),
                        ),
                      ],
                    ),
                    Divider(
                      height: 2,
                    ),
                    Obx(() => controller.selectedThemesList.value.length == 0
                        ? Container(
                            height: 100,
                            child: Text("Aucune Categorie n'été  selectionné "))
                        : SizedBox(
                            height: 100,
                            child: SingleChildScrollView(
                              child: Wrap(
                                  children: controller.selectedThemesList
                                      .map((String e) => Padding(
                                            padding: const EdgeInsets.all(8),
                                            child: Chip(
                                              label: Text(e),
                                            ),
                                          ))
                                      .toList()),
                            ),
                          )),
                  ])),
            ],
          ),
        ));
  }

  _onMapCreated(GoogleMapController controller) {
    setState(() {
      mapController = controller;
    });
  }

  setMarker(LatLng position) {
    setState(() {
      markers.clear();
      markers.add(Marker(
        //add first marker
        markerId: MarkerId(position.toString()),
        position: position, //position of marker
        infoWindow: InfoWindow(
          //popup info
          title: 'Event location',
        ),
        icon: BitmapDescriptor.defaultMarker, //Icon for Marker
      ));
    });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evetoapp/controllers/eventController.dart';
import 'package:evetoapp/profilescreen.dart';
import 'package:evetoapp/providers/eventProvider.dart';
import 'package:favorite_button/favorite_button.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:evetoapp/filterChip.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:like_button/like_button.dart';
import 'package:provider/provider.dart';
import 'contact.dart';
import 'controllers/loginController.dart';
import 'eventPage.dart';
import 'headerDrawer.dart';
import 'login.dart';
import 'package:intl/intl.dart';

import 'models/Event.dart';
import 'myOwnEvent.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? currentAddress;
  Position? currentLocation;

  // scrolling animation
  ScrollController controller = ScrollController();
  bool closeTopContainer = false;
  double topContainer = 0;

  bool searchIsClicked = false;

  TextEditingController searchController = TextEditingController();

  bool selected = false;

  List<String> selectedCategoriesList = [];

  bool isFilter = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
    controller.addListener(() {
      double value = controller.offset / 120;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

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

    final EventProvider = Provider.of<eventProvider>(context);
    final Size size = MediaQuery.of(context).size;

    void searchEvent(String query) {
      if (query.isEmpty) {
        EventProvider.loadEvents();
      } else {
        EventProvider.events = EventProvider.events
            .where((event) =>
                event.title!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    }

    ;
    void filterEvents(List<String> selectedCategories) {
      if (selectedCategories.isEmpty) {
        Fluttertoast.showToast(msg: "aucun filtre n'été selectionné");
        EventProvider.loadEvents();
      } else {
        EventProvider.events = EventProvider.events
            .where((event) => selectedCategories
                .every((element) => event.category.contains(element)))
            .toList();
        print(EventProvider.events);
      }
    }

    return Scaffold(
        backgroundColor: Color(0xc8f4f4f4),
        key: _scaffoldKey,
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [
              Column(
                children: [
                  HeaderDrawer(),
                ],
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  'Profile',
                  style: TextStyle(
                    color: Color(0xFF604BE0),
                    fontSize: 16,
                  ),
                ),
                leading: Icon(
                  Icons.person,
                  color: Color(0xFF604BE0),
                  size: 30,
                ),
                onTap: () {
                  Get.to(ProfileScreen(
                    uid: FirebaseAuth.instance.currentUser!.uid,
                  ));
                },
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  'Contact',
                  style: TextStyle(
                    color: Color(0xFF604BE0),
                    fontSize: 16,
                  ),
                ),
                leading: Icon(
                  Icons.contact_support_outlined,
                  color: Color(0xFF604BE0),
                  size: 35,
                ),
                onTap: () {
                  Get.to(Contact());
                },
              ),
              SizedBox(height: 20),
              ListTile(
                title: Text(
                  'Déconnecter',
                  style: TextStyle(
                    color: Color(0xFF604BE0),
                    fontSize: 16,
                  ),
                ),
                leading: Icon(
                  Icons.logout,
                  color: Color(0xFF604BE0),
                  size: 30,
                ),
                onTap: () async {
                  await LoginController.signOut(context: context);
                  Get.to(Login());
                },
              ),
            ],
          ),
        ),
        appBar: AppBar(
          leading: IconButton(
            icon: CircleAvatar(
              radius: 15,
              backgroundImage: Image.network(
                FirebaseAuth.instance.currentUser?.photoURL ?? "",
                fit: BoxFit.fitWidth,
              ).image,
            ),
            onPressed: () => _scaffoldKey.currentState?.openDrawer(),
          ),

          leadingWidth: 50,
          centerTitle: true,
          title: SizedBox(
            width: 125,
            // margin: EdgeInsets.only(left: 10),
            child: Image.asset("assets/logotwil.png"),
          ),
          elevation: 0,
          backgroundColor: Colors.white,
          // title: ,
          //   ,
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Color(0xFF513ADA),
                size: 35,
              ),
              onPressed: () {},
            ),
          ],
        ),
        body: RefreshIndicator(
          semanticsLabel: "rafraîchir",
          onRefresh: () async {
            return await EventProvider.loadEvents();
          },
          child: Column(mainAxisSize: MainAxisSize.min, children: [
            Container(
              height: 50,
              width: 390,
              padding: EdgeInsets.only(right: 15, top: 0, bottom: 0, left: 3),
              margin: EdgeInsets.only(top: 0, bottom: 0, right: 0, left: 0),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25))),
              child: SingleChildScrollView(
                child: Row(
                  children: [
                    Flexible(
                      child: SizedBox(
                        height: 45,
                        child: TextField(
                          onTap: () {
                            setState(() {
                              searchIsClicked = true;
                            });
                          },
                          onChanged: (value) {
                            searchEvent(value);
                          },
                          autofocus: false,
                          controller: searchController,
                          decoration: InputDecoration(
                            hintText: "Recherche par titre",
                              filled: true,
                              contentPadding: EdgeInsets.only(bottom: 4),
                              suffixIcon: IconButton(
                                onPressed: () {
                                  EventProvider.loadEvents();
                                  FocusScope.of(context).unfocus();
                                  searchIsClicked = false;
                                  searchController.clear;
                                  searchController.text = "";
                                },
                                icon: Icon(
                                  Icons.clear,
                                  color: searchIsClicked
                                      ? Colors.grey
                                      : Colors.transparent,
                                ),
                              ),
                              prefixIcon: Icon(
                                Icons.search_rounded,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                              )),
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 20,
                      child: isFilter
                          ? IconButton(
                              padding: EdgeInsets.only(right: 5),
                              onPressed: () {
                                EventProvider.loadEvents();
                                selectedCategoriesList.clear();
                                isFilter = false;
                              },
                              icon: Icon(
                                Icons.close,
                                color: Color(0xFF454545),
                                size: 30,
                              ))
                          : IconButton(
                              padding: EdgeInsets.only(right: 10, left: 3),
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (BuildContext dialogContext) {
                                      return StatefulBuilder(
                                          builder: (context, setState) {
                                        return AlertDialog(
                                          actions: [
                                            Material(
                                              elevation: 2,
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: const Color(0xFF513ADA),
                                              child: MaterialButton(
                                                minWidth: MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    3,
                                                height: 20,
                                                onPressed: () {
                                                  isFilter = true;
                                                  filterEvents(
                                                      selectedCategoriesList);
                                                  Navigator.of(context,
                                                          rootNavigator: true)
                                                      .pop();
                                                },
                                                child: Text("Appliquer",
                                                    textAlign: TextAlign.center,
                                                    style: TextStyle(
                                                      fontSize: 17,
                                                      color: const Color(
                                                          0xFFFFFFFF),
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    )),
                                              ),
                                            ),
                                          ],
                                          title: Text("Filtrer"),
                                          scrollable: true,
                                          content: Stack(
                                            clipBehavior: Clip.none,
                                            children: <Widget>[
                                              Positioned(
                                                right: -40.0,
                                                top: -40.0,
                                                child: InkResponse(
                                                  onTap: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                  child: CircleAvatar(
                                                    child: Icon(Icons.close),
                                                    backgroundColor: Colors.red,
                                                  ),
                                                ),
                                              ),
                                              Column(
                                                children: [
                                                  Container(
                                                    padding: EdgeInsets.only(
                                                        left: 18),
                                                    alignment:
                                                        Alignment.bottomLeft,
                                                    child: Text(
                                                      "Categories",
                                                      style: TextStyle(
                                                          fontSize: 17),
                                                    ),
                                                  ),
                                                  Divider(
                                                    color: Colors.grey,
                                                  ),
                                                  SizedBox(
                                                    height: 300,
                                                    child:
                                                        SingleChildScrollView(
                                                      child: FilterChips(
                                                        categories:
                                                            categoryList,
                                                        onSelectionChanged:
                                                            (selectedList) {
                                                          setState(() {
                                                            selectedCategoriesList =
                                                                selectedList;
                                                          });
                                                        },
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )
                                              // Container(
                                              //       child:Column(
                                              //         children: [
                                              //           Container(
                                              //             padding: EdgeInsets.only(left: 18),
                                              //             alignment:Alignment.bottomLeft,
                                              //             child: Text("Categories",style: TextStyle(fontSize: 17),),
                                              //           ),
                                              //           Divider(color: Colors.grey,
                                              //           ),
                                              //           SizedBox(
                                              //             height:300,
                                              //             child: SingleChildScrollView(
                                              //               physics: BouncingScrollPhysics(),
                                              //               scrollDirection: Axis.vertical,
                                              //               child: Wrap(
                                              //                   children:
                                              //                   categoryList.map((String e) =>
                                              //                       Padding(
                                              //                         padding: const EdgeInsets.all(8),
                                              //                         child: FilterChip(
                                              //                           selected: selected,
                                              //                           selectedColor: Color(0xFF513ADA),
                                              //                           pressElevation: 10,
                                              //                           label: Text(e),
                                              //                           onSelected: (isSelected) {
                                              //                             selectChip(e,isSelected);
                                              //                           },
                                              //                         ),
                                              //                       )).toList()
                                              //               ),
                                              //             ),
                                              //           )
                                              //         ],
                                              //       ),
                                              // )
                                            ],
                                          ),
                                        );
                                      });
                                    });
                              },
                              icon: Icon(
                                Icons.filter_list_alt,
                                color: Color(0xFF454545),
                                size: 30,
                              )),
                    ),
                  ],
                ),
              ),
            ),
            FutureBuilder(
                future: getUserLocation(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    if (currentLocation != null && currentAddress != null) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8, top: 5),
                        child: Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: Colors.grey,
                            ),
                            Text(
                              currentAddress!,
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return Padding(
                      padding: const EdgeInsets.only(left: 8.0, top: 8),
                      child: Row(
                        children: [
                          Icon(
                            Icons.location_on,
                            color: Colors.grey,
                            size: 15,
                          ),
                          Text("Locating your city"),
                        ],
                      ),
                    );
                  }
                  return Text("Locating your city....");
                }),
            if (!searchIsClicked && !isFilter)
              AnimatedOpacity(
                duration: const Duration(milliseconds: 10),
                opacity: closeTopContainer ? 0 : 1,
                child: AnimatedContainer(
                  alignment: Alignment.topCenter,
                  width: size.width,
                  height: closeTopContainer ? 0 : 170,
                  duration: Duration(milliseconds: 70),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding:
                            const EdgeInsets.only(top: 3, left: 15, bottom: 3),
                        child: Text('Recommendé pour vous',
                            textAlign: TextAlign.start,
                            style: TextStyle(
                              color: Colors.black,
                            )),
                      ),
                      Container(
                          decoration: BoxDecoration(
                            backgroundBlendMode: BlendMode.colorDodge,
                            color: Colors.transparent,
                          ),
                          clipBehavior: Clip.antiAlias,
                          height: 140,
                          // child: FutureBuilder(
                          //   future: getEvents(),
                          //   builder: (context, AsyncSnapshot snapshot) {
                          //     if (snapshot.hasData) {
                          //       return Flexible(
                          child: ListView.builder(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              physics: BouncingScrollPhysics(),
                              clipBehavior: Clip.antiAliasWithSaveLayer,
                              scrollDirection: Axis.horizontal,
                              itemCount: EventProvider.recommendedEvents.length,
                              itemBuilder: (context, index) {
                                return FittedBox(
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.topCenter,
                                  child: Card(
                                      surfaceTintColor: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(25)),
                                      margin: EdgeInsets.only(left: 15),
                                      elevation: 5,
                                      child: GestureDetector(
                                        child: Container(
                                            margin: const EdgeInsets.all(0),
                                            height: 130,
                                            width: 170,
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                  height: 130,
                                                  child: Stack(
                                                    // fit: StackFit.
                                                    children: [
                                                      ClipRRect(
                                                        borderRadius:
                                                            const BorderRadius
                                                                .only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  25.0),
                                                          topRight:
                                                              Radius.circular(
                                                                  25.0),
                                                          bottomRight:
                                                              Radius.circular(
                                                                  25.0),
                                                          bottomLeft:
                                                              Radius.circular(
                                                                  25.0),
                                                        ),
                                                        child: SizedBox(
                                                          height: 130,
                                                          width: 170,
                                                          child: Image(
                                                            image: Image.network(
                                                                    EventProvider
                                                                        .recommendedEvents[
                                                                            index]
                                                                        .photoUrl!)
                                                                .image,
                                                            fit: BoxFit.cover,
                                                            color: Colors
                                                                .black54
                                                                .withOpacity(
                                                                    0.1),
                                                            colorBlendMode:
                                                                BlendMode
                                                                    .colorBurn,
                                                            frameBuilder:
                                                                (BuildContext
                                                                        context,
                                                                    Widget
                                                                        child,
                                                                    int? frame,
                                                                    bool
                                                                        wasSynchronouslyLoaded) {
                                                              if (wasSynchronouslyLoaded ||
                                                                  frame !=
                                                                      null) {
                                                                return Container(
                                                                  child: child,
                                                                  foregroundDecoration:
                                                                      const BoxDecoration(
                                                                          gradient: LinearGradient(
                                                                              begin: Alignment.topCenter,
                                                                              end: Alignment.bottomCenter,
                                                                              colors: [
                                                                        Color(
                                                                            0x00000000),
                                                                        Color(
                                                                            0x00000000),
                                                                        Color(
                                                                            0x00000000),
                                                                        Color(
                                                                            0x00000000),
                                                                        Color(
                                                                            0x00000000),
                                                                      ])),
                                                                  // height: 130,
                                                                  width: double
                                                                      .infinity,
                                                                );
                                                              } else {
                                                                return Container(
                                                                  child: CircularProgressIndicator(
                                                                      color: Colors
                                                                          .grey,
                                                                      value:
                                                                          null,
                                                                      backgroundColor:
                                                                          Colors
                                                                              .white),
                                                                  alignment:
                                                                      Alignment(
                                                                          0, 0),
                                                                  constraints:
                                                                      BoxConstraints
                                                                          .expand(),
                                                                );
                                                              }
                                                            },
                                                            // loadingBuilder: (BuildContext context, Widget child,
                                                            // ImageChunkEvent? loadingProgress) {
                                                            // if (loadingProgress == null) {
                                                            // return child;
                                                            // }
                                                            // return Center(
                                                            // child: CircularProgressIndicator(
                                                            //       value: loadingProgress.expectedTotalBytes != null
                                                            //       ? loadingProgress.cumulativeBytesLoaded /
                                                            //       loadingProgress.expectedTotalBytes!
                                                            //           : null,),
                                                            //     );}),
                                                          ),
                                                        ),
                                                      ),
                                                      // Positioned(
                                                      //   bottom: 15,
                                                      //   left: 13,
                                                      //   right: 20,
                                                      //   child: Text(
                                                      //     EventProvider
                                                      //         .recommendedEvents[
                                                      //             index]
                                                      //         .title!,
                                                      //     style: TextStyle(
                                                      //         color:
                                                      //             Colors.white,
                                                      //         fontSize: 15,
                                                      //         fontWeight:
                                                      //             FontWeight
                                                      //                 .w800,
                                                      //         fontFamily:
                                                      //             "Lato"),
                                                      //   ),
                                                      // ),
                                                    ],
                                                  ),
                                                ),
                                                // Container(
                                                //   height: 30,
                                                //   margin: EdgeInsets.all(0),
                                                //   decoration: BoxDecoration(
                                                //       borderRadius:
                                                //           BorderRadius.circular(
                                                //               25)),
                                                //   child: Column(
                                                //     children: [
                                                //       Row(
                                                //         children: [
                                                //           // Icon(Icons.)
                                                //           Text("enf"),
                                                //         ],
                                                //       ),
                                                //     ],
                                                //   ),
                                                // ),
                                              ],
                                            )),
                                        onTap: () {
                                          Get.to(EventPage(
                                              event: EventProvider
                                                  .recommendedEvents[index]));
                                        },
                                      )),
                                );
                              })),
                    ],
                  ),
                ),
              ),
            if (!searchIsClicked && !isFilter)
              Padding(
                padding: EdgeInsets.only(bottom: 3, right: 335),
                child: Text('Tout',
                    textAlign: TextAlign.start,
                    style: TextStyle(
                      color: Colors.black,
                    )),
              ),
            Flexible(
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: ListView.builder(
                      controller: controller,
                      physics: BouncingScrollPhysics(),
                      padding: EdgeInsets.only(top: 0),
                      itemCount: EventProvider.events.length,
                      itemBuilder: (context, index) {
                        return Card(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15)),
                            margin: EdgeInsets.only(bottom: 20),
                            elevation: 2,
                            child: GestureDetector(
                              child: SizedBox(
                                  height: 260,
                                  child: Column(
                                    children: [
                                      Stack(
                                        // fit: StackFit.
                                        children: [
                                          ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(15.0),
                                              topRight: Radius.circular(15.0),
                                              // bottomRight: Radius
                                              //     .circular(25.0),
                                              // bottomLeft: Radius
                                              //     .circular(25.0),
                                            ),
                                            child: SizedBox(
                                              height: 200,
                                              width: 372,
                                              child: Image(
                                                image: Image.network(
                                                        EventProvider
                                                            .events[index]
                                                            .photoUrl!)
                                                    .image,
                                                fit: BoxFit.cover,
                                                color: Colors.black54
                                                    .withOpacity(0.1),
                                                colorBlendMode:
                                                    BlendMode.colorBurn,
                                                frameBuilder: (BuildContext
                                                        context,
                                                    Widget child,
                                                    int? frame,
                                                    bool
                                                        wasSynchronouslyLoaded) {
                                                  if (wasSynchronouslyLoaded ||
                                                      frame != null) {
                                                    return Container(
                                                      child: child,
                                                      foregroundDecoration:
                                                          const BoxDecoration(
                                                              gradient: LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                            Color(0x00000000),
                                                            Color(0x00000000),
                                                            Color(0x00000000),
                                                            Color(0x94000000),
                                                            Color(0xD5000000),
                                                          ])),
                                                    );
                                                  } else {
                                                    return Container(
                                                      child:
                                                          CircularProgressIndicator(
                                                              color:
                                                                  Colors.grey,
                                                              value: null,
                                                              backgroundColor:
                                                                  Colors.white),
                                                      alignment:
                                                          Alignment(0, 0),
                                                      constraints:
                                                          BoxConstraints
                                                              .expand(),
                                                    );
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            bottom: 15,
                                            left: 13,
                                            right: 20,
                                            child: Text(
                                              EventProvider
                                                  .events[index].title!,
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 17,
                                                  fontWeight: FontWeight.w800,
                                                  fontFamily: "Lato"),
                                            ),
                                          ),
                                          Positioned(
                                              right: 10,
                                              top: 10,
                                              child: CircleAvatar(
                                                backgroundColor:
                                                    Color(0x57000000),
                                                child: Padding(
                                                  padding:
                                                      EdgeInsets.only(left: 4),
                                                  child: LikeButton(
                                                    animationDuration: Duration(
                                                        milliseconds: 300),
                                                    isLiked: EventProvider
                                                        .events[index].likes
                                                        .contains(FirebaseAuth
                                                            .instance
                                                            .currentUser!
                                                            .uid),
                                                    onTap: (isLiked) async {
                                                      final success =
                                                          await addToFavorites(
                                                              EventProvider
                                                                  .events[index]
                                                                  .id,
                                                              isLiked);
                                                      EventProvider
                                                          .loadEvents();
                                                      return !isLiked;
                                                    },
                                                  ),
                                                ),
                                              ))
                                        ],
                                      ),
                                      Container(
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25)),
                                        height: 60,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          top: 5, left: 8.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons.date_range,
                                                        color:
                                                            Color(0x9B000000),
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .only(top: 3.0),
                                                        child: Text(
                                                          DateFormat(
                                                                  'MM/dd/yyyy')
                                                              .format(EventProvider
                                                                  .events[index]
                                                                  .startingDate!
                                                                  .toDate()),
                                                          style: TextStyle(
                                                              color: Color(
                                                                  0x9B000000),fontSize: 14),
                                                        ),
                                                      )
                                                    ],
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 8.0),
                                                  child: Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .location_on_outlined,
                                                        color:
                                                            Color(0x9B000000),
                                                      ),
                                                      SizedBox(
                                                        width: 3,
                                                      ),
                                                      FutureBuilder(
                                                          future: getLocation(
                                                              EventProvider
                                                                  .events[index]
                                                                  .eventLocation!),
                                                          initialData:
                                                              "Loading location..",
                                                          builder: (BuildContext
                                                                  context,
                                                              AsyncSnapshot<
                                                                      String>
                                                                  text) {
                                                            return Padding(
                                                              padding: const EdgeInsets.only(top: 3.0),
                                                              child: Text(
                                                                  text
                                                                      .requireData,
                                                                  style: TextStyle(
                                                                      color: Color(
                                                                          0x9B000000),fontSize: 13)),
                                                            );
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 25.0, right: 9),
                                              child: Row(
                                                children: [
                                                  Icon(
                                                    Icons.access_time,
                                                    color: Color(0x9B000000),
                                                  ),
                                                  SizedBox(
                                                    width: 3,
                                                  ),
                                                  Text(
                                                    DateFormat('Hm').format(
                                                        EventProvider
                                                            .events[index]
                                                            .startingDate!
                                                            .toDate()),
                                                      style: TextStyle(
                                                      color: Color(
                                                          0x9B000000),fontSize: 13),
                                                  ),
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      ),
                                    ],
                                  )),
                              onTap: () {
                                Get.to(EventPage(
                                    event: EventProvider.events[index]));
                              },
                            )
                            //   } else if (snapshot.hasError) {
                            //     return Text('${snapshot.error}');
                            //   }
                            //   // By default, show a loading spinner.
                            //   return Center(
                            //       heightFactor: 50,
                            //       widthFactor: 50,
                            //       child: CircularProgressIndicator(
                            //         semanticsLabel: "Loading events...",
                            //         strokeWidth: 2, color: Colors.black,));
                            // },
                            );

                        // child: ListView.builder(
                        //   itemCount: 10,
                        //   itemBuilder: (BuildContext ctx, int index) {
                        //     return Card(
                        //       shape: RoundedRectangleBorder(
                        //         borderRadius: BorderRadius.circular(20)
                        //       ),
                        //       child: Text("testing testing "),
                        //     );
                        //   },
                        // ),
                      })),
            ),
          ]),
        ));
  }

  // Future getEvents() async {
  //   var firestore = FirebaseFirestore.instance;
  //   QuerySnapshot qn = await firestore.collection("events").get();
  //
  //   return qn.docs;
  // }

  Future<dynamic> getUserLocation() async {
    currentLocation = await locateUser();
    try {
      // Geolocator geolocator = Geolocator();
      List<Placemark> p = await placemarkFromCoordinates(
          currentLocation!.latitude, currentLocation!.longitude);
      Placemark place = p[0];
      setState(() {
        currentAddress = "${place.administrativeArea}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
    // print(currentAddress);
    // print('center $_center');
    return currentAddress;
  }

  Future<Position> locateUser() async {
    LocationPermission permission;
    permission = await Geolocator.checkPermission();
    await Geolocator.requestPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.deniedForever) {
        return Future.error('Location Not Available');
      }
    }
    return Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
  }

  FirebaseFirestore firestoreInstance = FirebaseFirestore.instance;

  Future<bool> addToFavorites(String? id, bool isLiked) async {
    if (!isLiked) {
      await firestoreInstance.collection("events").doc(id).update({
        "likes": FieldValue.arrayUnion([FirebaseAuth.instance.currentUser!.uid])
      });
      await firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "favorites": FieldValue.arrayUnion([id])
      });
    } else {
      await firestoreInstance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .update({
        "favorites": FieldValue.arrayRemove([id])
      });
      await firestoreInstance.collection("events").doc(id).update({
        "likes":
            FieldValue.arrayRemove([FirebaseAuth.instance.currentUser!.uid])
      });
    }
    return true;
  }

  Future<String> getLocation(Map<String, dynamic> eventLocation) async {
    String loc;
    GeoPoint location = eventLocation["geopoint"];

    List<Placemark> placemarks =
        await placemarkFromCoordinates(location.latitude, location.longitude);

    Placemark place = placemarks[0];
    List<String> addres = place.street!.split(" ");
    if (addres.length > 4) {
      loc =
          ("${addres[0]} ${addres[1]} ${addres[3]} ${addres[4]},${place.locality}");
    } else {
      loc = ("${place.street},${place.locality}");
    }

    return loc;
  }
}

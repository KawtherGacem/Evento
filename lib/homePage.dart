import 'package:evetoapp/profilescreen.dart';
import 'package:evetoapp/providers/eventProvider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:latlng/latlng.dart';
import 'package:geocoding/geocoding.dart';
import 'package:provider/provider.dart';
import 'confidentialite.dart';
import 'contact.dart';
import 'controllers/loginController.dart';
import 'eventPage.dart';
import 'login.dart';
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

  bool searchIsClicked= false;

  TextEditingController searchController =TextEditingController();



  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserLocation();
    controller.addListener(() {

      double value = controller.offset/120;

      setState(() {
        topContainer = value;
        closeTopContainer = controller.offset > 50;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    final EventProvider = Provider.of<eventProvider>(context);
    final Size size = MediaQuery.of(context).size;
    List<Event>? events =EventProvider.events;
    void searchEvent(String query) {
          if (query.isEmpty){
              EventProvider.loadEvents();
          }else{
              EventProvider.events = EventProvider.events.where((event) => event.title!.toLowerCase().contains(query.toLowerCase())).toList();
          }
    };
   
    return Scaffold(
      backgroundColor: Color(0xffececf5),
        key: _scaffoldKey,
        drawer: Drawer(
              child: ListView(
                padding: EdgeInsets.all(0),
              children: [
              Column(
              children: [
              ProfileScreen(),

                ],
                ),
                SizedBox(height: 20),
                ListTile(
                title: Text('Mes evenements',
                style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 16,),
                ),
                leading: Icon(Icons.my_library_books_outlined,color: Colors.deepPurpleAccent,),
                onTap: (){
                Get.to(MyOwnEvent());
                },
          ),
                SizedBox(height: 20),
                ListTile(
                title: Text('Confidentialité et securité',
                style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 16,),
                ),
                leading: Icon(Icons.privacy_tip_outlined,color: Colors.deepPurpleAccent,),
                onTap: (){
                Get.to(Confidentialite());
                },
                      ),
                SizedBox(height: 20),
                ListTile(
                title: Text('Contact',
                style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 16,),
                ),
                leading: Icon(Icons.contact_support_outlined,color: Colors.deepPurpleAccent,),
                onTap: (){
                Get.to(Contact());
                },
                ),
                SizedBox(height: 20),
                ListTile(
                title: Text('Déconnecter',
                style: TextStyle(color: Colors.deepPurpleAccent, fontSize: 16,),
                ),
                leading: Icon(Icons.logout,color: Colors.deepPurpleAccent,),
                onTap: () async {
                  await LoginController.signOut(context: context);
                  Get.to(Login());
                },
                ),
                ],
                ),
              ),
        appBar:  AppBar(
                leading: IconButton(
                  icon:  CircleAvatar(
                      radius: 15,
                      backgroundImage:
                      // Image
                      //     .network(
                      //   _auth.currentUser?.photoURL ?? "", fit: BoxFit.fitWidth,)
                      //     .image,
                    Image.asset("assets/people.png").image,
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
              ), onPressed: () {},
            ),
          ],
        ),
        body:  RefreshIndicator(
          onRefresh: () async {
            // events= await EventProvider.loadEvents();
            return await EventProvider.loadEvents(); },
          child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  height: 50,
                  width: 390,
                  padding: EdgeInsets.only(right: 15,top: 0,bottom: 0,left: 3),
                  margin: EdgeInsets.only(top: 0,bottom: 0,right: 0,left: 0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25))
                  ),
                  child: SingleChildScrollView(
                    child: Row(
                      children: [
                        Flexible(
                          child: SizedBox(
                            height:45,
                            child:
                            TextField(
                              onTap: (){
                                setState(() {
                                  searchIsClicked=true;
                                });
                              },
                              onChanged: (value){
                                searchEvent(value);
                              },
                              autofocus: false,
                              controller: searchController,
                              decoration: InputDecoration(
                                filled: true,
                                contentPadding: EdgeInsets.only(bottom: 4),
                                  suffixIcon: IconButton(
                                    onPressed: (){
                                      EventProvider.loadEvents();
                                      FocusScope.of(context).unfocus();
                                      searchIsClicked=false;
                                      searchController.clear;
                                      searchController.text ="";
                                    },
                                    icon: Icon(Icons.clear,color: searchIsClicked ? Colors.grey : Colors.transparent,),
                                  ),
                                prefixIcon: Icon(Icons.search_rounded,),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(25),
                                )
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 20,
                          child: IconButton(
                            padding: EdgeInsets.only(right: 10,left: 3),
                              onPressed: (){},
                              icon: Icon(Icons.filter_list_alt,
                                color: Color(0xFF454545),
                              size: 30,)),
                        ),
                      ],
                    ),
                  ),
                ),
                FutureBuilder(
                    future: getUserLocation(),
                    builder: (BuildContext context,AsyncSnapshot snapshot){
                      if (snapshot.hasData){
                        if (currentLocation != null &&
                            currentAddress != null) {
                          return Padding(
                            padding: const EdgeInsets.only(left:8, top: 5),
                            child: Row(
                              children: [
                                Icon(Icons.location_on,color: Colors.grey,),
                                Text(currentAddress!,),
                              ],
                            ),
                          );
                        }
                      }
                      else {
                        return Padding(
                          padding: const EdgeInsets.only(left:8.0, top: 8),
                          child: Row(
                            children: [
                              Icon(Icons.location_on,color: Colors.grey,size: 15,),
                              Text("Locating your city"),
                            ],
                          ),
                        );
                      }
                      return Text("Locating your city....");
                }),
                  if (!searchIsClicked) AnimatedOpacity(
                       duration: const Duration(milliseconds: 300),
                       opacity: closeTopContainer?0:1,
                     child: AnimatedContainer(
                       alignment: Alignment.topCenter,
                        width: size.width,
                       height: closeTopContainer?0:200,
                       duration: Duration(milliseconds: 70),
                       child: Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           Padding(
                             padding: const EdgeInsets.only(top: 3, left: 15, bottom: 3),
                             child: Text('Recommended',
                                 textAlign: TextAlign.start,
                                 style: TextStyle(color: Colors.black,)
                             ),
                           ),
                           Container(
                             height: 160,
                                // child: FutureBuilder(
                                //   future: getEvents(),
                                //   builder: (context, AsyncSnapshot snapshot) {
                                //     if (snapshot.hasData) {
                                //       return Flexible(
                                    child: ListView.builder(
                                        physics: BouncingScrollPhysics(),
                                        clipBehavior: Clip.none,
                                      scrollDirection: Axis.horizontal,
                                        itemCount: EventProvider.recommendedEvents.length,
                                        itemBuilder: (context, index) {
                                          return
                                            FittedBox(
                                              fit: BoxFit.fitWidth,
                                              alignment: Alignment.topCenter,
                                              child: Card(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius: BorderRadius.circular(
                                                        15)
                                                ),
                                                margin: EdgeInsets.only(left: 15),
                                                elevation: 2,
                                                child: GestureDetector(
                                                  child: Container(
                                                    margin: const EdgeInsets.all(0),
                                                      height: 170,
                                                      width: 250,
                                                      child: Column(
                                                        children: [
                                                          SizedBox(
                                                            height: 130,
                                                            child: Stack(
                                                              // fit: StackFit.
                                                              children: [
                                                                ClipRRect(
                                                                  borderRadius: const BorderRadius
                                                                      .only(
                                                                    topLeft: Radius
                                                                        .circular(
                                                                        15.0),
                                                                    topRight: Radius
                                                                        .circular(
                                                                        15.0),
                                                                    // bottomRight: Radius
                                                                    //     .circular(25.0),
                                                                    // bottomLeft: Radius
                                                                    //     .circular(25.0),
                                                                  ),
                                                                  child: SizedBox(
                                                                    height: 130,
                                                                    width: 250,
                                                                    child: Image(
                                                                      image:
                                                                      // Image
                                                                      //     .network(
                                                                      //     EventProvider
                                                                      //         .recommendedEvents[index]
                                                                      //         .photoUrl!)
                                                                      //     .image,
                                                                      Image.asset("assets/people.png").image,
                                                                      fit: BoxFit.cover,
                                                                      color: Colors.black54
                                                                          .withOpacity(0.1),
                                                                      colorBlendMode: BlendMode
                                                                          .colorBurn,
                                                                      frameBuilder: (
                                                                          BuildContext context,
                                                                          Widget child,
                                                                          int? frame,
                                                                          bool wasSynchronouslyLoaded) {
                                                                        if (wasSynchronouslyLoaded ||
                                                                            frame != null) {
                                                                          return Container(
                                                                            child: child,
                                                                            foregroundDecoration: const BoxDecoration(
                                                                                gradient: LinearGradient(
                                                                                    begin: Alignment
                                                                                        .topCenter,
                                                                                    end: Alignment
                                                                                        .bottomCenter,
                                                                                    colors: [
                                                                                      Color(
                                                                                          0xBE000000),
                                                                                      Color(
                                                                                          0x00000000),
                                                                                      Color(
                                                                                          0x00000000),

                                                                                      Color(
                                                                                          0xA6000000),
                                                                                      Color(
                                                                                          0xD5000000),
                                                                                    ]
                                                                                )
                                                                            ),
                                                                            height: 140,
                                                                            width: double
                                                                                .infinity,
                                                                          );
                                                                        } else {
                                                                          return Container(
                                                                            child: CircularProgressIndicator(
                                                                                color: Colors
                                                                                    .grey,
                                                                                value: null,
                                                                                backgroundColor: Colors
                                                                                    .white),
                                                                            alignment: Alignment(
                                                                                0, 0),
                                                                            constraints: BoxConstraints
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

                                                                Positioned(
                                                                  bottom: 15,
                                                                  left: 13,
                                                                  right: 20,
                                                                  child: Text(EventProvider
                                                                      .recommendedEvents[index].title!,
                                                                    style: TextStyle(
                                                                        color: Colors.white,
                                                                        fontSize: 15,
                                                                        fontWeight: FontWeight
                                                                            .w800,
                                                                        fontFamily: "Lato"),),
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                          Container(
                                                            height: 30,
                                                            margin: EdgeInsets.all(0),
                                                            decoration: BoxDecoration(
                                                                borderRadius: BorderRadius
                                                                    .circular(25)),
                                                            child: Column(
                                                              children: [
                                                                Row(
                                                                  children: [
                                                                    // Icon(Icons.)
                                                                    Text("enf"
                                                                    ),
                                                                  ],
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      )),
                                                  onTap: () {
                                                    Get.to(EventPage(
                                                        event: EventProvider
                                                            .recommendedEvents[index]));
                                                  },

                                                )
                                          ),
                                            );

                                        })

                                     ),
                         ],
                       ),
                     ),
                   ),
                    // Divider(),
                 if (!searchIsClicked) Padding(
                  padding: EdgeInsets.only(top: 3,bottom: 3, right: 340),
                  child: Text('All',
                      textAlign: TextAlign.start,
                      style: TextStyle(color: Colors.black,)
                  ),
                ),
                Flexible(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 25),
                      child: ListView.builder(
                        controller: controller,
                          physics: BouncingScrollPhysics(),
                          padding: EdgeInsets.only(top: 0),
                          itemCount: EventProvider.events.length,
                          itemBuilder: (context, index) {
                            return Card(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        15)
                                ),
                                margin: EdgeInsets.only(bottom: 20),
                                elevation: 2,
                                child: GestureDetector(
                                  child: SizedBox(
                                      height: 220,
                                      child: Column(
                                        children: [
                                          Stack(
                                            // fit: StackFit.
                                            children: [
                                              ClipRRect(
                                                borderRadius: const BorderRadius
                                                    .only(
                                                  topLeft: Radius
                                                      .circular(
                                                      15.0),
                                                  topRight: Radius
                                                      .circular(
                                                      15.0),
                                                  // bottomRight: Radius
                                                  //     .circular(25.0),
                                                  // bottomLeft: Radius
                                                  //     .circular(25.0),
                                                ),
                                                child: SizedBox(
                                                  height: 160,
                                                  width: 372,
                                                  child: Image(
                                                    image:
                                                    // Image
                                                    //     .network(EventProvider.
                                                    //          events[index]
                                                    //         .photoUrl!)
                                                    //     .image,
                                                    Image.asset("assets/people.png").image,
                                                    fit: BoxFit.cover,
                                                    color: Colors.black54
                                                        .withOpacity(0.1),
                                                    colorBlendMode: BlendMode
                                                        .colorBurn,
                                                    frameBuilder: (
                                                        BuildContext context,
                                                        Widget child,
                                                        int? frame,
                                                        bool wasSynchronouslyLoaded) {
                                                      if (wasSynchronouslyLoaded ||
                                                          frame != null) {
                                                        return Container(
                                                          child: child,
                                                          foregroundDecoration: const BoxDecoration(
                                                              gradient: LinearGradient(
                                                                  begin: Alignment
                                                                      .topCenter,
                                                                  end: Alignment
                                                                      .bottomCenter,
                                                                  colors: [
                                                                    Color(
                                                                        0xCC000000),
                                                                    Color(
                                                                        0x00000000),
                                                                    Color(
                                                                        0x00000000),

                                                                    Color(
                                                                        0xA6000000),
                                                                    Color(
                                                                        0xD5000000),
                                                                  ]
                                                              )
                                                          ),
                                                        );
                                                      } else {
                                                        return Container(
                                                          child: CircularProgressIndicator(
                                                              color: Colors
                                                                  .grey,
                                                              value: null,
                                                              backgroundColor: Colors
                                                                  .white),
                                                          alignment: Alignment(
                                                              0, 0),
                                                          constraints: BoxConstraints
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
                                                child: Text(EventProvider.events![index].title!,
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 17,
                                                      fontWeight: FontWeight
                                                          .w800,
                                                      fontFamily: "Lato"),),
                                              ),
                                            ],
                                          ),
                                          Container(
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius
                                                    .circular(25)),
                                            height: 40,
                                            child: Row(
                                              children: [
                                              ],
                                            ),
                                          ),
                                        ],
                                      )),
                                  onTap: () {
                                    Get.to(EventPage(
                                        event: events![index]));
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
                          })
                  ),
                )]
          ),
        )


    );

    

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
      currentAddress =
      "${place.administrativeArea}, ${place.country}";
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
  return Geolocator
      .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
}


}
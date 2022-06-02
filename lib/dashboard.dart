import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:evetoapp/addEvent.dart';
import 'package:evetoapp/homePage.dart';
import 'package:evetoapp/profilescreen.dart';
import 'package:evetoapp/providers/eventProvider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'controllers/loginController.dart';
import 'eventPage.dart';
import 'favoritesPage.dart';
import 'login.dart';
import 'main.dart';
import 'models/Event.dart';


class Dashboard extends StatefulWidget {
  const Dashboard({Key? key, required User user})
      : _user = user,
        super(key: key);

  final User _user;

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  late User _user;
  int selectedIndex = 0;
  late Event event ;

  @override
  void initState() {
    _user = widget._user;
    GeoPoint eventLocation = GeoPoint(35.7011269, -0.5838205);

    Map<String,dynamic> map={
      "hash":"owdko",
      "geopoint":eventLocation
    };
    event= Event("id", "Ingehack", "The biggest event of the year, the long awaited INGEHACK is finally here.In an upgraded version, Ingehack is coming back this year in its third edition.Get ready because history is about to be made.️ details will be communicated soon.",
        "uid", "organizerPhoto", "Ingeniums", "https://www.google.com/url?sa=i&url=https%3A%2F%2Funsplash.com%2Fs%2Fphotos%2Fcorporate-event&psig=AOvVaw3UV5IKFmpD21FO6O0ZevyU&ust=1654127211029000&source=images&cd=vfe&ved=0CAwQjRxqFwoTCJjpkJn2ivgCFQAAAAAdAAAAABAD", ["Informatique","Competetion"],
        Timestamp.now(), Timestamp.now(), map, "https://docs.google.com/forms/d/e/1FAIpQLSdFPyVFQ65NaF1REfGWIARCP07oRr6NDEBkzG-ktnmgo9NIow/viewform?usp=sf_link", []);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final EventProvider = Provider.of<eventProvider>(context,listen: false);
    // EventProvider.loadEvents();
    // EventController eventController = EventController();
    // eventController.getEvents();
    List<Widget> listWidgets = [
      // ProfileScreen(uid: _user.uid),
      HomePage(),
      // EventPage(event: event,isRecommended: false),
      addEvent(),
      FavoutitesPage(),
    ];

    return Scaffold(
        body:listWidgets[selectedIndex],
        bottomNavigationBar: ConvexAppBar.badge(
        {},
        items: [
          TabItem(icon: Icons.home, title: 'Acceuil'),
          TabItem(icon: Icons.add, title: 'Ajouter'),
          TabItem(icon: Icons.favorite, title: 'Favoris'),
        ],
        onTap: onItemTapped,
        activeColor:Color(0xFF604BE0) ,
        color: Color(0xFF604BE0),
        backgroundColor: Color(0xFFFFFFFF),
      )
    );
  }

  void onItemTapped(int index) async{
    if (index==2){
    final EventProvider = Provider.of<eventProvider>(context,listen: false);
    EventProvider.loadEvents();
    }
    setState(() {
      selectedIndex = index;
    });
}
  Widget loggedInUser() {
    return SizedBox(
      height: 100,
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage: Image.network(_user.photoURL ?? "").image,
          ),
          Text(_user.displayName ?? ""),
          ActionChip(
            avatar: Icon(Icons.logout),
            label: Text("logout"),
            onPressed: () async {
              // setState(() {
              // _isSigningOut = true;
              // });
              await LoginController.signOut(context: context);
              // setState(() {
              // _isSigningOut = false;
              // });
             Get.offAll(Login());
            },
          ),
        ],
      ),
    );
  }




}

import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:evetoapp/addEvent.dart';
import 'package:evetoapp/homePage.dart';
import 'package:evetoapp/models/users/User.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import 'controllers/loginController.dart';
import 'login.dart';
import 'main.dart';


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
  bool _isSigningOut = false;

  int selectedIndex = 0;

  @override
  void initState() {
    _user = widget._user;

    super.initState();
  }
  List<Widget> listWidgets = [
    HomePage(),
    addEvent(),
    HomePage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:listWidgets[selectedIndex],
    //     appBar: AppBar(
    //       leadingWidth: 200,
    //       leading: Container(
    //         margin: EdgeInsets.only(left: 10),
    //         child: Image.asset("assets/logotwil.png"),
    //       ),
    //       elevation: 0,
    //       backgroundColor: Colors.white,
    //       // title: ,
    //       //   ,
    //       actions: <Widget>[
    //         IconButton(
    //           icon: Icon(
    //             Icons.notifications_active_outlined,
    //             color: Color(0xFF513ADA),
    //           ), onPressed: () {  },
    //         ),
    //         CircleAvatar(
    //           radius: 20,
    //           backgroundImage: Image.network(_user.photoURL ?? "").image,
    //
    //         ),
    //       ],
    //
    // ),
        bottomNavigationBar: ConvexAppBar.badge(
        {},
        items: [
          TabItem(icon: Icons.home, title: 'Acceuil'),
          TabItem(icon: Icons.add, title: 'Ajouter'),
          TabItem(icon: Icons.favorite, title: 'Fav'),
        ],
        onTap: onItemTapped,
        activeColor:Color(0xFF604BE0) ,
        color: Color(0xFF604BE0),
        backgroundColor: Color(0xFFFFFFFF),
      )
    );
  }

  void onItemTapped(int index) async{

    selectedIndex = index;
    setState(() { });
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

import 'package:flutter/material.dart';


class Confidentialite extends StatefulWidget {

  @override
  State<Confidentialite> createState() => _ConfidentialiteState();
}

class _ConfidentialiteState extends State<Confidentialite> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.all(50),
          child: Card(
            child: ListTile(
                title: Text('Mes événements')
            ),
          ),
        ));
  }
}
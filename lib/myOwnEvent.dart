import 'package:flutter/material.dart';


class MyOwnEvent extends StatefulWidget {

  @override
  State<MyOwnEvent> createState() => _MyOwnEventState();
}

class _MyOwnEventState extends State<MyOwnEvent> {
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
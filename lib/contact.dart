import 'package:flutter/material.dart';


class Contact extends StatefulWidget {

  @override
  State<Contact> createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
          margin: EdgeInsets.all(50),
          child: Card(
            child: ListTile(
                title: Text('Contact')
            ),
          ),
        ));
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key, required DocumentSnapshot event})
      : _event = event,

  super(key: key);
  final DocumentSnapshot _event;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late DocumentSnapshot<Map<String,dynamic>> event;

  @override
  void initState() {
    event =widget._event as DocumentSnapshot<Map<String, dynamic>>;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          margin: EdgeInsets.all(50),
          child: Card(
            child: ListTile(
              title: Text(event.data()!["title"]),
            ),
          ),
    ));
  }
}

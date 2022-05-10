import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'models/Event.dart';

class EventPage extends StatefulWidget {
  const EventPage({Key? key, required Event event})
      : _event = event,

        super(key: key);
  final Event _event;

  @override
  State<EventPage> createState() => _EventPageState();
}

class _EventPageState extends State<EventPage> {
  late Event event;

  @override
  void initState() {
    event =widget._event ;
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body:Container(
          margin: EdgeInsets.all(50),
          child: Card(
            child: ListTile(
                title: Text(event.title!,)
            ),
          ),
        ));
  }
}
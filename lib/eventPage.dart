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
        body:Stack(
          children: [
             SizedBox(
              height: 300,
              width: MediaQuery.of(context).size.width,
              child: Image(
                image: Image.network(event.photoUrl!).image,
                fit: BoxFit.cover,
                color: Colors.black54.withOpacity(0.1),
                colorBlendMode: BlendMode.colorBurn,
                frameBuilder: (BuildContext
                context, Widget child, int? frame, bool wasSynchronouslyLoaded) {
                  if (wasSynchronouslyLoaded || frame != null) {
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
                          color: Colors.grey,
                          value: null,
                          backgroundColor: Colors.white),
                      alignment: Alignment(0, 0),
                      constraints: BoxConstraints.expand(),
                    );
                  }
                },
              ),
            ),
            Container()
          ],

        ));
  }
}
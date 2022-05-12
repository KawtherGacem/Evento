import 'package:flutter/cupertino.dart';

import '../controllers/eventController.dart';
import '../models/Event.dart';

class eventProvider extends ChangeNotifier{
  EventController eventController = EventController();
  List<Event> events =[];
  List<Event> recommendedEvents =[];



  eventProvider.initialize(){
    loadEvents();
  }

  Future<void> loadEvents() async{
    events = await eventController.getEvents();
    recommendedEvents = await eventController.getRecommendedEvents();
    notifyListeners();
  }

}
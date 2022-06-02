import 'package:flutter/cupertino.dart';

import '../controllers/eventController.dart';
import '../models/Event.dart';

class eventProvider extends ChangeNotifier{
  EventController eventController = EventController();
  List<Event> events =[];
  List<Event> backUpEvents=[];
  List<Event> recommendedEvents =[];
  List<Event> favoriteEvents=[];


  eventProvider.initialize(){
    loadEvents();
  }

  Future<void> loadEvents() async{
    // events = await eventController.getEvents();
    // backUpEvents = events;
    // recommendedEvents = await eventController.getRecommendedEvents();
    favoriteEvents =await eventController.getFavorites();
    notifyListeners();
  }

  // searchEventByName(){
  //
  // }

}
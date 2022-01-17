import 'dart:core';

class Contact {
  String name = "Cook";
  List<Event> events = [];

  Contact(this.name);

  void addEvent(Event event) {
    // ignore: unnecessary_this
    this.events.add(event);
  }
}

class Event {
  DateTime event = DateTime.utc(0000, 00, 00);

  Event(DateTime event);
}

class Event {
  String eventName;
  DateTime eventDate;

  Event(this.eventName, this.eventDate);
}

class Events {
  List<Event> events;

  Events(this.events);

  void addEvent(Event ev) {
    print('martin');
  }
}

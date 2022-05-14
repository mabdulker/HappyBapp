class Event {
  String eventName;
  DateTime eventDate;

  Event(this.eventName, this.eventDate);
}

class Events {
  Map<String, Event> events;

  Events(this.events);

  void addEvent(Event ev) {
    print('martin');
  }
}

// Events getEvents(Map<String, dynamic> fbEvents) {
//   Events x;
//   fbEvents.forEach((key, value) {
//     x.addEvent(Event(key, value));
//     },
//   );
// }
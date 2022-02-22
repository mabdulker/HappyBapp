import 'package:flutter/material.dart';
//import 'package:cloud_firestore/cloud_firestore.dart';

class Contact {
  String name;
  Map events = Map<String, DateTime>();
  // final DocumentReference;
  // TO ADD: id, url

  Contact(this.name);

  void addEvent(String name, DateTime time) {
    // ignore: unnecessary_this
    this.events[name] = time;
  }
}

class Event {
  DateTime event = DateTime.utc(0000, 00, 00);

  Event(DateTime event);
}

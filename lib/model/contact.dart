import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter/model/events.dart';

late var contacts = FirebaseFirestore.instance.collection('user');

class Contact {
  String id;
  String name;
  Map<String, Event> events;
  //Events evts;
  // TODO: add picture url

  Contact(this.id, this.name, this.events);

  String getName() {
    return name;
  }

  Future<Map<String, dynamic>> getEvents() async {
    return events;
  }

  String getId() {
    return id;
  }

  DocumentReference getRef() {
    return contacts.doc(id);
  }
}

Future<Contact> getContact(id) async {
  var docSnapshot = await contacts.doc(id).get();
  late Map<String, dynamic> data;
  if (docSnapshot.exists) {
    data = docSnapshot.data()!;
    if (data['events'] != null) {
      return Contact(id, data['username'], data['events']);
    } else {
      return Contact(id, data['username'], {});
    }
  } else {
    throw ('Contact does not exist');
  }
}

void setDates(contact, contactName, contactEvents) {
  contact.then((value) => value
      .getRef()
      .set({
        'username': contactName,
        'events': contactEvents,
      })
      .then((value) => print('user updated'))
      .catchError((error) => print(error)));
}

void main(List<String> args) {
  print('hello');
}

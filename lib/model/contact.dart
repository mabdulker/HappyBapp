import 'package:cloud_firestore/cloud_firestore.dart';

late var contacts = FirebaseFirestore.instance.collection('user');

class Contact {
  String id;
  String username;
  List<dynamic> events;
  // TO ADD: picture url

  Contact(this.id, this.username, this.events);

  String getUsername() {
    return username;
  }

  Future<List<dynamic>> getEvents() async {
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
    if (data['Events'] != null) {
      return Contact(id, data['username'], data['Events']);
    } else {
      return Contact(id, data['username'], []);
    }
  } else {
    throw ('Contact does not exist');
  }
}

// Future<void> updateContact(id, username, [events]) async {
//   var docSnapshot = await contacts.doc(id).get();
//   late Map<String, dynamic> data;
//   if (docSnapshot.exists) {
//     data = docSnapshot.data()!;
//     if (data['events'] != null) {
//       return Contact(data['username'], data['events']);
//     } else {
//       return Contact(data['username']);
//     }
//   } else {
//     throw ('Contact does not exist');
//   }
// }

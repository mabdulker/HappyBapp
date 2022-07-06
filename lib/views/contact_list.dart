import 'package:flutter/material.dart';
import 'package:test_flutter/views/view_contact.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:test_flutter/views/edit_contact.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Contacts'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, MaterialPageRoute(builder: (_) {
            return const EditContact(docId: "");
          }));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            TextField(
              // TODO: Implement functionality for the search bar
              controller: searchController,
              decoration: InputDecoration(
                labelText: 'Search',
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Theme.of(context).primaryColor),
                ),
                prefixIcon:
                    Icon(Icons.search, color: Theme.of(context).primaryColor),
              ),
            ),
            const Expanded(child: ContactList()),
          ],
        ),
      ),
    );
  }
}

class ContactList extends StatefulWidget {
  const ContactList({Key? key}) : super(key: key);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  final Stream<QuerySnapshot> users =
      FirebaseFirestore.instance.collection('user').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: users,
      builder: (
        BuildContext context,
        AsyncSnapshot<QuerySnapshot> snapshot,
      ) {
        if (snapshot.hasError) {
          return const Text('Wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }

        final data = snapshot.requireData;

        return ListView.builder(
          itemCount: data.size,
          itemBuilder: (context, index) {
            return buildContact(data, index);
          },
        );
      },
    );
  }

  Widget buildContact(data, index) => Card(
        child: Row(
          children: <Widget>[
            Expanded(
              child: ListTile(
                title: Text('My name is ${data.docs[index]['username']}'),
                textColor: Colors.black,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return ViewContact(
                      docId: data.docs[index].id,
                    );
                  }));
                },
              ),
            )
          ],
        ),
      );
}

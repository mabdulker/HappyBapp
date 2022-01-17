import 'package:flutter/material.dart';
import 'package:test_flutter/model/contact.dart';
import 'package:test_flutter/views/add_contact.dart';

class Contacts extends StatefulWidget {
  const Contacts({Key? key}) : super(key: key);

  @override
  _ContactsState createState() => _ContactsState();
}

class _ContactsState extends State<Contacts> {
  List<Contact> contacts = [];

  void newContact(String text) {
    print(text);
    setState(() {
      contacts.add(Contact(text));
    });
  }

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
            return AddContacts(newContact);
          }));
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Stack(
        children: <Widget>[
          Expanded(child: ContactList(contacts)),
        ],
      ),
    );
  }
}

class ContactList extends StatefulWidget {
  final List<Contact> contacts;

  ContactList(this.contacts);

  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: widget.contacts.length,
      itemBuilder: (context, index) {
        var contact = widget.contacts[index];
        return Card(
          child: Row(
            children: <Widget>[
              Expanded(
                child: ListTile(
                  title: Text(contact.name),
                  textColor: Colors.black,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

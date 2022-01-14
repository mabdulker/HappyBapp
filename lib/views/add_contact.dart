import 'package:flutter/material.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({Key? key}) : super(key: key);

  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Add Contact'),
      ),
      body: Container(
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Name',
                prefixIcon: Icon(Icons.account_box_rounded, size: 30),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(
                hintText: 'Birthday',
                prefixIcon: Icon(Icons.account_box_rounded, size: 30),
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

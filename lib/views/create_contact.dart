import 'dart:io';

import 'package:flutter/material.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({Key? key}) : super(key: key);

  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  final double pHeight = 144;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple,
        title: const Text('Add Contact'),
      ),
      body: Column(
        children: [
          buildProfileImage(),
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
    );
  }

  buildProfileImage() => CircleAvatar(
        radius: pHeight / 2,
        backgroundColor: Colors.grey,
        backgroundImage: const NetworkImage(
            'https://api.time.com/wp-content/uploads/2017/12/terry-crews-person-of-year-2017-time-magazine-facebook-1.jpg?quality=85'),
      );
}

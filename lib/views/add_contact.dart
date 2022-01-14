import 'dart:io';

import 'package:flutter/material.dart';

class AddContacts extends StatefulWidget {
  const AddContacts({Key? key}) : super(key: key);

  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  final double pHeight = 120;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.deepPurple,
          title: const Text('Add Contact'),
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildTop(),
            buildBottom(),
          ],
        ));
  }

  Widget buildProfileImage() => CircleAvatar(
        radius: pHeight,
        backgroundColor: Colors.white12,
        backgroundImage: const NetworkImage(
            'https://api.time.com/wp-content/uploads/2017/12/terry-crews-person-of-year-2017-time-magazine-facebook-1.jpg?quality=85'),
      );

  Widget buildCoverImage() => Container(
        color: Colors.white12,
        child: Image.network(
          'https://emojipedia-us.s3.amazonaws.com/social/emoji/party-popper.png',
          width: double.infinity,
          height: 250,
          fit: BoxFit.cover,
        ),
      );

  Widget buildTop() => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          buildCoverImage(),
          Positioned(
            child: buildProfileImage(),
            top: 60,
          ),
        ],
      );

  Widget buildBottom() => Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Name',
              prefixIcon: Icon(Icons.account_box_rounded, size: 30),
              fillColor: Colors.white,
              filled: true,
            ),
          ),
        ],
      );
}

import 'dart:io';
import 'package:flutter/material.dart';

class AddContacts extends StatefulWidget {
  //const AddContacts({Key? key}) : super(key: key);
  final Function(String) callback;

  AddContacts(this.callback);

  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  final double pHeight = 120;
  final nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Contact'),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: this.save,
                icon: Icon(Icons.edit),
                tooltip: 'Save Changes',
              ),
            )
          ],
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            buildTop(),
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 12, right: 12),
              child: buildBottom(),
            ),
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
            controller: this.nameController,
            decoration: const InputDecoration(
              hintText: 'Name',
              prefixIcon: Icon(Icons.account_circle_outlined, size: 30),
              fillColor: Colors.white,
              filled: false,
            ),
          ),
        ],
      );

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
  }

  void save() {
    widget.callback(nameController.text);
    nameController.clear();
  }
}

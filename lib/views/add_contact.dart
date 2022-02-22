import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import 'package:intl/intl.dart';

//import 'package:cupertino_date_textbox/cupertino_date_textbox';

class AddContacts extends StatefulWidget {
  @override
  _AddContactsState createState() => _AddContactsState();
}

class _AddContactsState extends State<AddContacts> {
  final double pHeight = 120;
  var name = '';
  Map<String, DateTime> event = Map();
  DateTime _selectedDateTime = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat.yMd().format(_selectedDateTime);
    CollectionReference users = FirebaseFirestore.instance.collection('user');

    return Scaffold(
        appBar: AppBar(
          title: const Text('Add Contact'),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {
                  users
                      .add({'username': name, 'birthday': _selectedDateTime})
                      .then((value) => print('user added'))
                      .catchError((error) => print('error'));
                },
                icon: Icon(Icons.edit),
                tooltip: 'Save Changes',
              ),
            ),
          ],
        ),
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(top: 50, left: 12, right: 12),
              child: buildBottom(),
            ),
          ],
        ));
  }

  // Assemble Bottom page
  Widget buildBottom() => Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(
              hintText: 'Name',
              prefixIcon: Icon(Icons.account_circle_outlined, size: 30),
              fillColor: Colors.white,
              filled: false,
            ),
            onChanged: (value) {
              name = value;
            },
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 100, 20, 50),
            child: Column(children: <Widget>[
              const SizedBox(height: 15.0),
              bdatePicker()
            ]),
          ),
        ],
      );

  // Date Picker
  Widget eventPicker() => Row(
        children: [
          ElevatedButton(
            child: Text("Select Date"),
            onPressed: () async {
              var datePicked = await DatePicker.showSimpleDatePicker(
                context,
                initialDate: DateTime(1994),
                firstDate: DateTime(1960),
                lastDate: DateTime(2012),
                dateFormat: "dd-MMMM-yyyy",
                locale: DateTimePickerLocale.en_us,
                looping: true,
              );
            },
          ),
          //DateTimeField
        ],
      );

  Widget bdatePicker() => Material(
        color: Colors.transparent,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const Text('Birthday',
                style: TextStyle(
                  color: CupertinoColors.systemBlue,
                  fontSize: 15.0,
                )),
            const Padding(
              padding: EdgeInsets.only(bottom: 5.0),
            ),
            CupertinoDateTextBox(
                initialValue: _selectedDateTime,
                onDateChange: onBirthdayChange,
                hintText: DateFormat.yMd().format(_selectedDateTime)),
          ],
        ),
      );
  void onBirthdayChange(DateTime birthday) {
    setState(() {
      _selectedDateTime = birthday;
    });
  }
}

import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import 'package:intl/intl.dart';

//import 'package:cupertino_date_textbox/cupertino_date_textbox';

class EditContact extends StatefulWidget {
  final String docId;

  const EditContact({
    Key? key,
    this.docId = '',
  }) : super(key: key);

  @override
  _EditContactState createState() => _EditContactState();
}

class _EditContactState extends State<EditContact> {
  @override
  void initState() {
    super.initState();
    getUser().then((value) {
      print('Async done');
      print(_name);
      print(_selectedDateTime);
    });
  }

  final double pHeight = 120;
  Map<String, DateTime> event = Map();
  DateTime _selectedDateTime = DateTime.utc(2002);
  String _name = '';

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormat.yMd().format(_selectedDateTime);
    var users = FirebaseFirestore.instance.collection('user').doc(widget.docId);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Edit Contact'),
          backgroundColor: Colors.deepPurple,
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: IconButton(
                onPressed: () {
                  users
                      .update(
                          {'username': _name, 'birthday': _selectedDateTime})
                      .then((value) => print('user updated'))
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
            key: Key(_name),
            initialValue: _name,
            decoration: const InputDecoration(
              hintText: 'Name',
              prefixIcon: Icon(Icons.account_circle_outlined, size: 30),
              fillColor: Colors.white,
              filled: false,
            ),
            onChanged: (value) {
              _name = value;
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
                hintText: DateFormat.yMd().format(DateTime.now())),
          ],
        ),
      );
  void onBirthdayChange(DateTime birthday) {
    setState(() {
      _selectedDateTime = birthday;
    });
  }

  Future<void> getUser() async {
    var collection = FirebaseFirestore.instance.collection('user');
    var docSnapshot = await collection.doc(widget.docId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      // You can then retrieve the value from the Map like this:
      setState(() {
        _name = data['username'];
        _selectedDateTime =
            DateTime.parse(data['birthday'].toDate().toString());
      });
    }
  }
}


/*
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
*/
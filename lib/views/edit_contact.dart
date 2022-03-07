import 'dart:ffi';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';
import 'package:flutter/cupertino.dart';
import 'package:cupertino_date_textbox/cupertino_date_textbox.dart';
import 'package:intl/intl.dart';

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
      print(date);
    });
  }

  final double pHeight = 120;
  Map<String, DateTime> event = Map();
  DateTime date = DateTime.now();
  String _name = '';
  bool editMode = false;
  var users = FirebaseFirestore.instance.collection('user');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
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
          Padding(
            padding: EdgeInsets.zero,
            child: TextFormField(
              // Edit Mode
              autocorrect: false,
              readOnly: !editMode,
              enabled: editMode,
              // Text Field
              key: Key(_name),
              initialValue: _name,
              decoration: const InputDecoration(
                //icon: Icon(Icons.account_circle_outlined, size: 30),
                hintText: 'Name',
                prefixIcon: Icon(
                  Icons.account_circle_outlined,
                  size: 30,
                  color: Colors.blueGrey,
                ),
                fillColor: Colors.white,
                filled: false,
              ),
              onChanged: (value) {
                _name = value;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 100, 0, 50),
            child: Column(children: <Widget>[
              //const SizedBox(height: 15.0),
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
            _DatePickerItem(
              children: <Widget>[
                const Text('Birthday'),
                CupertinoButton(
                  // Display a CupertinoDatePicker in date picker mode.
                  onPressed: !editMode
                      ? null
                      : () => _showDialog(
                            CupertinoDatePicker(
                              initialDateTime: date,
                              mode: CupertinoDatePickerMode.date,
                              use24hFormat: true,
                              // This is called when the user changes the date.
                              onDateTimeChanged: (DateTime newDate) {
                                setState(() => date = newDate);
                              },
                            ),
                          ),
                  // In this example, the date value is formatted manually. You can use intl package
                  // to format the value based on user's locale settings.
                  child: Text(
                    '${date.day}-${date.month}-${date.year}',
                    style: const TextStyle(
                      fontSize: 22.0,
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      );
  void onBirthdayChange(DateTime birthday) {
    setState(() {
      date = birthday;
    });
  }

  PreferredSizeWidget buildAppBar() => AppBar(
        title: Text('${editMode ? 'Edit' : 'View'} Contact'),
        backgroundColor: Colors.deepPurple,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Container(
              child: editBtn(),
            ),
          ),
        ],
      );

  Widget editBtn() => GestureDetector(
        onTap: () {
          if (editMode) {
            users
                .doc(widget.docId)
                .update({'username': _name, 'birthday': date})
                .then((value) => print('user updated'))
                .catchError((error) => print('error'));
          }
          setState(() {
            editMode = !editMode;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 10,
          width: 80,
          child: Center(
            child: Text(
              editMode ? 'Save' : 'Edit',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.deepPurple[500],
            borderRadius: BorderRadius.circular(50),
            boxShadow: editMode
                ? [
                    BoxShadow(
                      color: Colors.deepPurple[600]!,
                      offset: const Offset(4, 4),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.deepPurple[400]!,
                      offset: Offset(-4, -4),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        ),
      );

  Future<void> getUser() async {
    var collection = FirebaseFirestore.instance.collection('user');
    var docSnapshot = await collection.doc(widget.docId).get();
    if (docSnapshot.exists) {
      Map<String, dynamic> data = docSnapshot.data()!;
      // You can then retrieve the value from the Map like this:
      setState(() {
        _name = data['username'];
        date = DateTime.parse(data['birthday'].toDate().toString());
      });
    }
  }

  // This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoDatePicker.
  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 216,
              padding: const EdgeInsets.only(top: 6.0),
              // The Bottom margin is provided to align the popup above the system navigation bar.
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              // Provide a background color for the popup.
              color: CupertinoColors.systemBackground.resolveFrom(context),
              // Use a SafeArea widget to avoid system overlaps.
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }
}

// This class simply decorates a row of widgets.
class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        border: Border(
          top: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
          bottom: BorderSide(
            color: CupertinoColors.inactiveGray,
            width: 0.0,
          ),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: children,
        ),
      ),
    );
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
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:test_flutter/model/contact.dart';
import 'package:flutter/foundation.dart';

// TODO: ability to add and delete new tiles
// TODO: submit updates of dates and names to firebase
// TODO: changes in ListView are transferred to database
// TODO: list tile has ability to be deleted
// TODO: Profile picture
// TODO: Search Implementation

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
  late Future<Contact> user;
  late Future<Map<String, dynamic>> _events;
  bool _editMode = false;
  String _name = '';
  Map<String, DateTime> dates = <String, DateTime>{};

  @override
  void initState() {
    super.initState();
    setState(() {
      user = getContact(widget.docId);
    });
    user.then((value) {
      setState(() {
        _name = value.getUsername();
        _events = value.getEvents();
      });
      print(_name);
      print('Done');
    });
  }

  // ? Gets rid of red screen of deat in transitions between screens
  Future<Map<String, dynamic>> waitEvents() async {
    return await _events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: buildAppBar(),
        body: Column(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 50), child: nameField()),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 100, 0, 50),
              child: getEventList(),
            ),
          ],
        ));
  }

  Widget nameField() => TextFormField(
        autocorrect: false,
        readOnly: !_editMode,
        enabled: _editMode,
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
      );

  Widget getEventList() => FutureBuilder<Map<String, dynamic>>(
      future: waitEvents(),
      builder: (context, ev) {
        return ListView.builder(
          shrinkWrap: true,
          itemCount: ev.data?.length ?? 0,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                buildPicker(
                    ev.data?.keys.toList()[index] ?? 'error',
                    DateTime.fromMillisecondsSinceEpoch(
                        ev.data?.values.toList()[index].seconds * 1000))
              ],
            );
          },
        );
      });

  Widget buildPicker(eventName, eventDate) {
    String name = eventName;
    dates.putIfAbsent(eventName, () => eventDate);
    // TODO: figure out the case where the name is changed
    return _DatePickerItem(
      children: <Widget>[
        Row(
          children: [
            SizedBox(
              height: 20,
              width: 160,
              child: TextFormField(
                // Edit Mode
                autocorrect: false,
                readOnly: !_editMode,
                enabled: _editMode,
                // Initial Value
                initialValue: eventName,
                // When user changes value name
                onChanged: (value) {
                  dates.removeWhere((key, value) => key == name);
                  dates.putIfAbsent(value, () => eventDate);
                  name = value;
                },
                // Styling
                style: const TextStyle(fontSize: 20),
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  enabledBorder: InputBorder.none,
                  focusedBorder: InputBorder.none,
                  contentPadding: EdgeInsets.all(10),
                ),
              ),
            ),
          ],
        ),
        const VerticalDivider(
          thickness: 1,
          color: CupertinoColors.inactiveGray,
        ),
        const Icon(
          Icons.double_arrow_rounded,
          color: Colors.deepPurple,
        ),
        CupertinoButton(
          // Display a CupertinoDatePicker in date picker mode.
          onPressed: !_editMode
              ? null
              : () => _showDialog(
                    CupertinoDatePicker(
                      initialDateTime: dates[eventName],
                      mode: CupertinoDatePickerMode.date,
                      use24hFormat: true,
                      // This is called when the user changes the date.
                      onDateTimeChanged: (DateTime newDate) {
                        setState(() => dates[eventName] = newDate);
                      },
                    ),
                  ),
          // In this example, the date value is formatted manually. You can use intl package
          // to format the value based on user's locale settings.
          child: Text(
            '${dates[eventName]!.day}-${dates[eventName]!.month}-${dates[eventName]!.year}',
            style: const TextStyle(
              fontSize: 22.0,
              color: Colors.black,
            ),
          ),
        ),
      ],
    );
  }

  PreferredSizeWidget buildAppBar() => AppBar(
        //title: Text('${editMode ? 'Edit' : 'View'} Contact'),
        backgroundColor: Colors.deepPurple,
        automaticallyImplyLeading: !_editMode,
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
          if (_editMode) {
            user.then((value) => value
                .getRef()
                .set({
                  'username': _name,
                  'events': dates,
                })
                .then((value) => print('user updated'))
                .catchError((error) => print(error)));
          }
          setState(() {
            _editMode = !_editMode;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 10,
          width: 80,
          child: Center(
            child: Text(
              _editMode ? 'Done' : 'Edit',
              style: const TextStyle(fontSize: 20),
            ),
          ),
          decoration: BoxDecoration(
            color: Colors.deepPurple[500],
            borderRadius: BorderRadius.circular(50),
            boxShadow: _editMode
                ? [
                    BoxShadow(
                      color: Colors.deepPurple[600]!,
                      offset: const Offset(4, 4),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                    BoxShadow(
                      color: Colors.deepPurple[400]!,
                      offset: const Offset(-4, -4),
                      blurRadius: 15,
                      spreadRadius: 1,
                    ),
                  ]
                : null,
          ),
        ),
      );

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
        child: IntrinsicHeight(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: children,
          ),
        ),
      ),
    );
  }
}

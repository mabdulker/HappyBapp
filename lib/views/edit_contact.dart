import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:test_flutter/model/contact.dart';

// TODO: Profile picture
// TODO: Create view contact page and separate it from edit contact
// TODO: Styling
// TODO: loading screen before going onto edit page

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
  late Future<Contact> contact;
  late Future<Map<String, dynamic>> _events;
  bool _editMode = false;
  String _name = '';
  Map<String, DateTime> dates = <String, DateTime>{};

  @override
  void initState() {
    super.initState();
    setState(() {
      contact = getContact(widget.docId);
    });
    contact.then((value) {
      setState(() {
        _name = value.getName();
        _events = value.getEvents();
      });
      print(_name);
      print('Init Done');
    });
  }

  // ? Gets rid of red screen of death in transitions between screens
  Future<Map<String, dynamic>> waitEvents() async {
    return await _events;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
                padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                child: profilePicture()),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 50, 0, 30),
              child: contactNameFieldtest(),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(10, 20, 20, 20),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  children: [
                    header('Events'),
                    const Spacer(),
                    addBtn(),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(0, 20, 0, 50),
              child: getEventList(),
            ),
          ],
        ),
      ),
    );
  }

  // * App bar
  PreferredSizeWidget buildAppBar() => AppBar(
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

  // * Profile picture generator
  Widget profilePicture() => ProfilePicture(
        name: _name,
        radius: 90,
        fontsize: 60,
        img: null,
      );

  // * Field for user to enter contact name
  Widget contactNameFieldtest() {
    TextEditingController gg = TextEditingController(text: _name);
    return Container(
      padding: const EdgeInsets.all(8),
      child: CupertinoTextField(
        autocorrect: false,
        readOnly: !_editMode,
        enabled: _editMode,
        // Text Field
        key: Key(_name),
        controller: gg,
        placeholder: 'Name',
        decoration: BoxDecoration(
          color: const Color.fromARGB(18, 98, 97, 97),
          borderRadius: BorderRadius.circular(10),
        ),
        onChanged: (value) {
          _name = value;
        },
      ),
    );
  }

  // * Field for user to enter contact name
  Widget contactNameField() => TextFormField(
        autocorrect: false,
        readOnly: !_editMode,
        enabled: _editMode,
        // Text Field
        key: Key(_name),
        initialValue: _name,
        decoration: const InputDecoration(
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

  // * Header style text widget generator
  Widget header(String title) => Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 45,
        ),
      );

  // ? Event List: Creates a list of editable tiles
  // * Gets the list of events from firestore
  Widget getEventList() {
    final Stream<DocumentSnapshot> events = FirebaseFirestore.instance
        .collection('user')
        .doc(widget.docId)
        .snapshots();
    return StreamBuilder<DocumentSnapshot>(
      stream: events,
      builder: (
        BuildContext context,
        AsyncSnapshot<DocumentSnapshot> snapshot,
      ) {
        if (snapshot.hasError) {
          return const Text('Wrong');
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text('loading');
        }

        final data = snapshot.data!['events'];
        final keys = data.keys.toList()..sort();

        return ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: data.length,
          itemBuilder: (context, index) {
            return Column(
              children: <Widget>[
                buildEventTile(
                  keys[index] ?? 'error',
                  DateTime.fromMillisecondsSinceEpoch(
                      data[keys[index]].seconds * 1000),
                ),
              ],
            );
          },
          separatorBuilder: (BuildContext context, int index) =>
              const Divider(),
        );
      },
    );
  }

  // * List view tile builder
  // * Creates an event tile which is used by the ListView builder
  Widget buildEventTile(eventName, eventDate) {
    dates.putIfAbsent(eventName, () => eventDate);
    return Dismissible(
      movementDuration: const Duration(milliseconds: 300),
      direction: DismissDirection.endToStart,
      key: Key(eventName),
      onDismissed: (direction) {
        dates.remove(eventName);
        deleteEvent(contact, eventName);
      },
      background: Container(
        color: Colors.red,
        child: const Icon(
          Icons.delete,
          color: Colors.white,
        ),
      ),
      child: _DatePickerItem(
        children: <Widget>[
          Expanded(flex: 5, child: eventNameField(eventName, eventDate)),
          const Icon(
            Icons.double_arrow_rounded,
            color: Colors.deepPurple,
          ),
          Expanded(flex: 5, child: datePicker(eventName)),
        ],
      ),
    );
  }

  // * TextField for editing eventName field of tile
  Widget eventNameField(eventName, eventDate) {
    String name = eventName;
    return TextFormField(
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
    );
  }

  // * Creates a cupertino style picker with ability to edit
  Widget datePicker(eventName) => CupertinoButton(
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
          style: TextStyle(
            fontSize: 22.0,
            color: !_editMode ? Colors.black : Colors.blue,
          ),
        ),
      );

  // * Implements funcitonality and visual for the edit button
  Widget editBtn() => GestureDetector(
        onTap: () {
          if (_editMode) {
            setDates(contact, _name, dates);
          }
          setState(() {
            _editMode = !_editMode;
          });
        },
        // Neumorphism implementation
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

  // * Circle button used to add events to event list
  Widget addBtn() => FloatingActionButton(
        onPressed: () {
          openDialog();
        },
        elevation: 0,
        backgroundColor: Colors.green,
        child: const Icon(Icons.add_box, color: Colors.white),
      );

  // * Used to validate user input into text field
  bool validate(String input) {
    if (input.length > 1) {
      return true;
    }
    return false;
  }

  // ? for tomorrow - think about separating the picker from build picker, implement add button
  // * Opens a cupertino style dialog which prompts user to input data in order to add event
  Future openDialog() => showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        DateTime eventDate = DateTime.now();
        String eventName = '';
        return StatefulBuilder(builder: (context, setState) {
          return CupertinoAlertDialog(
            content: Column(
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 20, 0, 0),
                  child: CupertinoTextField(
                    onChanged: (value) {
                      eventName = value;
                    },
                    autocorrect: false,
                    autofocus: true,
                    placeholder: 'Event Name',
                  ),
                ),
                Container(
                  padding: const EdgeInsets.fromLTRB(0, 10, 0, 0),
                  child: Row(
                    children: [
                      const Text(
                        'Date: ',
                        style: TextStyle(fontSize: 20),
                      ),
                      const Spacer(),
                      CupertinoButton(
                        // Display a CupertinoDatePicker in date picker mode.
                        onPressed: () => _showDialog(
                          CupertinoDatePicker(
                            initialDateTime: eventDate,
                            mode: CupertinoDatePickerMode.date,
                            use24hFormat: true,
                            // This is called when the user changes the date.
                            onDateTimeChanged: (DateTime newDate) {
                              setState(() => eventDate = newDate);
                            },
                          ),
                        ),
                        // In this example, the date value is formatted manually. You can use intl package
                        // to format the value based on user's locale settings.
                        child: Text(
                          '${eventDate.day}-${eventDate.month}-${eventDate.year}',
                          style: const TextStyle(
                            fontSize: 20.0,
                            color: Colors.blue,
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              ],
            ),
            actions: [
              CupertinoDialogAction(
                onPressed: () => Navigator.pop(context),
                isDefaultAction: true,
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.red),
                ),
              ),
              CupertinoDialogAction(
                onPressed: () {
                  if (validate(eventName)) {
                    addEvent(contact, eventName, eventDate);
                    Navigator.pop(context);
                  } else {
                    print('wrong input');
                    // TODO: Add some feedback to provide user with reson for invalid input
                  }
                },
                isDefaultAction: true,
                child: const Text('Add Event'),
              ),
            ],
          );
        });
      });

  // * This shows a CupertinoModalPopup with a reasonable fixed height which hosts CupertinoDatePicker (styling for CDP)

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
      ),
    );
  }
}

// * This class decorates the event tile

class _DatePickerItem extends StatelessWidget {
  const _DatePickerItem({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(
          color: CupertinoColors.inactiveGray,
          width: 0.0,
        ),
        //borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
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

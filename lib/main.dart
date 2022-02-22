import 'package:flutter/material.dart';
import 'package:test_flutter/model/contact.dart';
import 'package:test_flutter/views/add_contact.dart';
import 'package:test_flutter/views/contact_list.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "FlutterApp",
      theme: ThemeData.light(),
      home: Contacts(),
    );
  }
}


/*
import 'package:flutter/material.dart';
import 'package:flutter_holo_date_picker/flutter_holo_date_picker.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'example',
      theme: ThemeData(primarySwatch: Colors.blue),
//      home: DateTesting(),
      home: Scaffold(
        appBar: AppBar(
          title: Text('Holo Datepicker Example'),
        ),
        body: MyHomePage(),
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePage extends StatelessWidget {
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ElevatedButton(
            child: Text("open picker dialog"),
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

              final snackBar =
                  SnackBar(content: Text("Date Picked $datePicked"));
              ScaffoldMessenger.of(context).showSnackBar(snackBar);
            },
          ),
        ],
      ),
    );
  }
}

class WidgetPage extends StatefulWidget {
  @override
  _WidgetPageState createState() => _WidgetPageState();
}

class _WidgetPageState extends State<WidgetPage> {
  DateTime? _selectedDate;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: DatePickerWidget(
              looping: false, // default is not looping
              firstDate: DateTime.now(), //DateTime(1960),
              //  lastDate: DateTime(2002, 1, 1),
//              initialDate: DateTime.now(),// DateTime(1994),
              dateFormat: "MM-dd(E)",
              //   "dd-MMMM-yyyy",
              //     locale: DatePicker.localeFromString('he'),
              onChange: (DateTime newDate, _) {
                _selectedDate = newDate;
                print(_selectedDate);
              },
              pickerTheme: DateTimePickerTheme(
                itemTextStyle: TextStyle(color: Colors.black, fontSize: 19),
                dividerColor: Colors.blue,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
*/


// Garbage


/*Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}*/

      /*(
        primaryColor: Colors.deepPurpleAccent,
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(secondary: Colors.deepPurpleAccent),
      ),*/

// class RandomWords extends StatefulWidget {
//   const RandomWords({Key? key}) : super(key: key);

//   @override
//   _RandomWordsState createState() => _RandomWordsState();
// }

// class _RandomWordsState extends State<RandomWords> {
//   final _suggestions = <WordPair>[];
//   final _biggerFont = const TextStyle(fontSize: 18.0);

//   Widget _buildSuggestions() {
//     return ListView.builder(
//         padding: const EdgeInsets.all(16.0),
//         itemBuilder: /*1*/ (context, i) {
//           if (i.isOdd) return const Divider(); /*2*/

//           final index = i ~/ 2; /*3*/
//           if (index >= _suggestions.length) {
//             _suggestions.addAll(generateWordPairs().take(10)); /*4*/
//           }
//           return _buildRow(_suggestions[index]);
//         });
//   }

//   Widget _buildRow(WordPair pair) {
//     return ListTile(
//       title: Text(
//         pair.asPascalCase,
//         style: _biggerFont,
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.black54,
//         title: const Text('Contact List'),
//       ),
//       body: _buildSuggestions(),
//     );
//   }
// }

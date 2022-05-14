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
      home: const Contacts(),
    );
  }
}

import 'package:betting_app/src/views/ui/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

DatabaseReference favRef = FirebaseDatabase.instance.ref().child("favourites");

var headers = {
  'x-rapidapi-key': '9498254f5bmsh1f0efaa226ae83cp19c922jsn27cb65e9dffe',
  'x-rapidapi-host': 'api-football-v1.p.rapidapi.com',
};

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http ;
import 'package:messenger/screens/home_screen.dart';
import 'classes /messages.dart';
import 'package:google_fonts/google_fonts.dart';



void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(

      title: 'Messenger Bubble',
      theme: ThemeData(


        brightness: Brightness.dark,
        primaryColor: Colors.lightBlue[800],
        hintColor: Colors.cyan[600],

        colorScheme: ColorScheme.dark(
          primary: Colors.lightBlueAccent,
          secondary: Colors.blueGrey,
        ),

        textTheme: TextTheme(
          displayLarge: TextStyle(fontSize: 57.0, fontWeight: FontWeight.bold),
          headlineMedium: TextStyle(fontSize: 34.0, fontStyle: FontStyle.italic),
          bodyMedium: TextStyle(fontSize: 14.0),
        ),
      ),


      home: HomePage(),
    );
  }
}


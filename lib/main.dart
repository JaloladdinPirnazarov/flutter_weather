import 'package:flutter/material.dart';
import 'package:weather/UI/get_started.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather',
      home: GetStarted(),
      debugShowCheckedModeBanner: false,
    );
  }
}


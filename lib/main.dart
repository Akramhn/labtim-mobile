import 'package:flutter/material.dart';
import 'package:labtim_mobile/screen/homePage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(primaryColor: Colors.greenAccent),
      debugShowCheckedModeBanner: false,
      home: const HomePage(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:mapakaon2/pages/mainPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @ override
  Widget build(BuildContext context){
    return MaterialApp(
      home: mainPage(), // This might change in the future
      debugShowCheckedModeBanner: false,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pharmacy_app/screens/home/base_frame.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
        debugShowCheckedModeBanner: false, home: BaseFrame(passedIndex: 0));
  }
}

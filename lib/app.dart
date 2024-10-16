import 'package:flutter/material.dart';
import 'package:pharmacy_app/screens/auth/login_screen.dart';
import 'package:pharmacy_app/screens/home/base_frame.dart';
import 'package:pharmacy_app/screens/home/category_screen.dart';

import 'screens/detail/chi_tiet_hoa_đơn.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: OrderDetailScreen(),
    );
  }
}

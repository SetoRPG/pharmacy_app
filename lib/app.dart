import 'package:flutter/material.dart';
import 'package:pharmacy_app/screens/auth/login_screen.dart';
import 'package:pharmacy_app/screens/detail/chi_tiet_sp.dart';
import 'package:pharmacy_app/screens/detail/chon_san_pham.dart';
import 'package:pharmacy_app/screens/detail/thong_tin_ca_nhan.dart';
import 'package:pharmacy_app/screens/detail/xem_chi_tiet_sp.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProductSelectionPage(),
    );
  }
}

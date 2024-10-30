// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';

class AddressSelectionScreen extends StatefulWidget {
  const AddressSelectionScreen({super.key});

  @override
  _AddressSelectionScreenState createState() => _AddressSelectionScreenState();
}

class _AddressSelectionScreenState extends State<AddressSelectionScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Thêm địa chỉ mới'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Họ và tên'),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(hintText: 'Nhập họ và tên'),
            ),
            const SizedBox(height: 16),
            const Text('Số điện thoại'),
            TextField(
              controller: _phoneController,
              decoration: const InputDecoration(hintText: 'Nhập số điện thoại'),
            ),
            const SizedBox(height: 16),
            const Text('Địa chỉ'),
            TextField(
              controller: _addressController,
              decoration: const InputDecoration(hintText: 'Nhập địa chỉ'),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Trả về thông tin địa chỉ khi người dùng nhấn lưu
                Navigator.pop(context,
                    '${_nameController.text}, ${_phoneController.text}, ${_addressController.text}');
              },
              child: const Text('Lưu địa chỉ'),
            ),
          ],
        ),
      ),
    );
  }
}

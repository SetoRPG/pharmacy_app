import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, String>> orders = [
      {"id": "123", "status": "Đang xử lý", "total": "500.000đ"},
      {"id": "124", "status": "Đã giao", "total": "300.000đ"},
      {"id": "125", "status": "Đã hủy", "total": "200.000đ"},
      {"id": "126", "status": "Đang xử lý", "total": "400.000đ"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Đơn hàng của tôi'),
        centerTitle: true,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF20B6E8), Color(0xFF16B2A5)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16.0),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 10),
            child: ListTile(
              title: Text('Mã đơn hàng: ${order['id']}'),
              subtitle: Text('Trạng thái: ${order['status']}'),
              trailing: Text(order['total'] ?? ''),
              onTap: () {
                // Handle tap to show more details
              },
            ),
          );
        },
      ),
      backgroundColor: Colors.white,
    );
  }
}

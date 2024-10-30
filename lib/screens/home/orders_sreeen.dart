// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/order_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_appbar.dart';
import 'package:pharmacy_app/screens/detail/chi_tiet_hoa_%C4%91%C6%A1n.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final OrderController _orderController = OrderController();
  List<Map<String, dynamic>> _orders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await _orderController.getOrdersForCurrentUser();
      setState(() {
        _orders = orders;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Optionally show an error message here
    }
  }

  Future<void> _confirmDeleteOrder(String orderId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Delete'),
        content: const Text('Are you sure you want to delete this order?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (shouldDelete == true) {
      await _orderController.deleteOrder(orderId);
      _loadOrders(); // Refresh the orders after deletion
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'ĐƠN ĐÃ ĐẶT',
        logo: Icons.receipt,
        showBackButton: false,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                final isProcessing = order['status'] == 'Đang xử lý';
                return Card(
                  color: Colors.white,
                  surfaceTintColor: Colors.white,
                  shadowColor: Colors.black,
                  elevation: 4,
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        title: Text('Mã đơn hàng: ${order['orderId']}'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Ngày tạo: ${order['dateCreated']}'),
                            Text('Tổng tiền: ${order['total']}'),
                            Text('Trạng thái: ${order['status']}'),
                          ],
                        ),
                        trailing: isProcessing
                            ? IconButton(
                                icon:
                                    const Icon(Icons.delete, color: Colors.red),
                                onPressed: () =>
                                    _confirmDeleteOrder(order['orderId']),
                              )
                            : null,
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  OrderDetailScreen(order: order),
                            ),
                          );
                        },
                      ),
                      _buildStatusBar(order['status']),
                    ],
                  ),
                );
              },
            ),
    );
  }

  Widget _buildStatusBar(String status) {
    return SizedBox(
      height: 20,
      child: Row(
        children: [
          Expanded(
            child: Container(
              color: status == 'Đang xử lý' ? Colors.green : Colors.grey,
              alignment: Alignment.center,
              child: Text(
                status == 'Đang xử lý' ? 'Đang xử lý' : '',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: status == 'Đã giao' ? Colors.green : Colors.grey,
              alignment: Alignment.center,
              child: Text(
                status == 'Đã giao' ? 'Đã giao' : '',
                style: const TextStyle(color: Colors.white, fontSize: 10),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

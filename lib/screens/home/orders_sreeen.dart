// ignore_for_file: library_private_types_in_public_api

import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/controllers/order_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_appbar.dart';
import 'package:pharmacy_app/screens/detail/chi_tiet_hoa_%C4%91%C6%A1n.dart';
// Import the intl package

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  _OrdersScreenState createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen>
    with SingleTickerProviderStateMixin {
  final OrderController _orderController = OrderController();
  final formatter = NumberFormat.decimalPattern();
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> _filteredOrders = [];
  bool _isLoading = true;
  late TabController _tabController;

  StreamSubscription<QuerySnapshot>? _ordersSubscription;

  // Define the order statuses
  final List<String> _statusTabs = [
    'Đang Chờ Xử Lý', // PENDING
    'Đã Xác Nhận', // CONFIRMED
    'Đang Giao', // SHIPPED
    'Đã Giao Hàng', // COMPLETED
    'Đã Hủy', // CANCELLED
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _initializeOrderListener();
  }

  void _initializeOrderListener() async {
    final customerId = await _getCurrentUserId();
    if (customerId.isNotEmpty) {
      _ordersSubscription = FirebaseFirestore.instance
          .collection('orders')
          .where('customer', isEqualTo: customerId)
          .snapshots()
          .listen((_) => _loadOrders());
    }
  }

  Future<void> _loadOrders() async {
    setState(() {
      _isLoading = true; // Show loading indicator while fetching
    });
    try {
      final orders = await _orderController.getOrdersForCurrentUser();
      setState(() {
        _orders = orders;
        _filteredOrders = orders
            .where(
                (order) => order['status'] == _statusTabs[_tabController.index])
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Failed to load orders: $e'),
      ));
    }
  }

  // Extracts the current user ID using `getOrdersForCurrentUser`
  Future<String> _getCurrentUserId() async {
    try {
      final orders = await _orderController.getOrdersForCurrentUser();
      if (orders.isNotEmpty) {
        return orders.first['customer'];
      }
      return '';
    } catch (e) {
      return ''; // Return an empty string if there's an error
    }
  }

  void _filterOrdersByStatus(String status) {
    setState(() {
      _filteredOrders =
          _orders.where((order) => order['status'] == status).toList();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _ordersSubscription?.cancel(); // Cancel Firestore listener
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'ĐƠN ĐÃ ĐẶT',
        logo: Icons.receipt,
        showBackButton: false,
      ),
      body: Column(
        children: [
          // TabBar at the top with no extra padding
          Material(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              labelColor: const Color(0xFF16B2A5),
              indicatorColor:
                  const Color(0xFF16B2A5), // Optional: indicator color
              tabs: _statusTabs.map((status) => Tab(text: status)).toList(),
              onTap: (index) {
                _filterOrdersByStatus(_statusTabs[index]);
              },
            ),
          ),
          // Body of the screen
          Expanded(
            child: _isLoading
                ? const Center(
                    child: CircularProgressIndicator(
                    color: Color(0xFF16B2A5),
                  ))
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];

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
                                  Text('Ngày tạo: ${order['orderDate']}'),
                                  Text(
                                      'Tổng tiền: ${formatter.format(double.parse(order['total']))} đ'),
                                  Text('Trạng thái: ${order['status']}'),
                                ],
                              ),
                              trailing: order['status'] == 'Đang Chờ Xử Lý'
                                  ? IconButton(
                                      icon: const Icon(Icons.close,
                                          color: Colors.red),
                                      onPressed: () =>
                                          _cancelOrder(order['orderId']),
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
          ),
        ],
      ),
    );
  }

  Future<void> _cancelOrder(String orderId) async {
    final shouldCancel = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận hủy đơn hàng'),
        content: const Text('Bạn có chắc chắn muốn hủy đơn hàng này không?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text(
              'Không',
              style: TextStyle(color: Color.fromRGBO(117, 117, 117, 1)),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text(
              'Hủy',
              style: TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );

    if (shouldCancel == true) {
      try {
        await _orderController.updateOrderStatus(orderId, 'CANCELLED');
        _loadOrders(); // Refresh the orders list after cancellation
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Đơn hàng đã được hủy thành công.'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Hủy đơn hàng thất bại: $e'),
        ));
      }
    }
  }

  // Method to build the status bar for each order
  Widget _buildStatusBar(String status) {
    // Define the status stages
    List<String> progressStages = [
      'Đang Chờ Xử Lý', // PENDING
      'Đã Xác Nhận', // CONFIRMED
      'Đang Giao', // SHIPPED
      'Đã Giao Hàng', // COMPLETED
    ];

    // Define the color to apply based on the status
    Color getStatusColor(String stage, String currentStatus) {
      if (currentStatus == 'Đã Hủy') {
        return Colors.red; // Entire bar turns red for CANCELLED
      }
      return progressStages.indexOf(stage) <=
              progressStages.indexOf(currentStatus)
          ? const Color(0xFF20B6E8) // Green for completed stages
          : Colors.grey.shade300; // Grey for uncompleted stages
    }

    return SizedBox(
      height: 20,
      child: status == 'Đã Hủy'
          ? Container(
              color: Colors.red, // Full red bar for CANCELLED
            )
          : Row(
              children: progressStages.map((stage) {
                return Expanded(
                  child: Container(
                    color: getStatusColor(stage, status),
                    alignment: Alignment.center,
                  ),
                );
              }).toList(),
            ),
    );
  }
}

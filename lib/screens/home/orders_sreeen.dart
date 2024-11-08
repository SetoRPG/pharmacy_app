// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
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
  List<Map<String, dynamic>> _orders = [];
  List<Map<String, dynamic>> _filteredOrders = [];
  bool _isLoading = true;
  late TabController _tabController;

  // Define the order statuses
  final List<String> _statusTabs = [
    'Đang Chờ Xử Lý', // PENDING
    'Đã Xác Nhận', // CONFIRMED
    'Đã Giao Hàng', // SHIPPED
    'Đã Kết Toán', // COMPLETED
    'Đã Hủy', // CANCELLED
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _statusTabs.length, vsync: this);
    _loadOrders();
  }

  Future<void> _loadOrders() async {
    try {
      final orders = await _orderController.getOrdersForCurrentUser();
      setState(() {
        _orders = orders;
        _filteredOrders = orders
            .where((order) => order['status'] == _statusTabs[0])
            .toList(); // Initially show only 'Đang Chờ Xử Lý' orders
        _isLoading = false;
      });
      // Debug print
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      // Optionally show an error message here
    }
  }

  // Filter orders based on the selected status
  void _filterOrdersByStatus(String status) {
    setState(() {
      _filteredOrders =
          _orders.where((order) => order['status'] == status).toList();
    });
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
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: _filteredOrders.length,
                    itemBuilder: (context, index) {
                      final order = _filteredOrders[index];
                      final isProcessing = order['orderStatus'] == 'Đang xử lý';

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
                                  Text('Tổng tiền: ${order['total']}đ'),
                                  Text('Trạng thái: ${order['status']}'),
                                ],
                              ),
                              trailing: isProcessing
                                  ? IconButton(
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
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
          ),
        ],
      ),
    );
  }

  // Method to confirm deletion
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

  // Method to build the status bar for each order
  Widget _buildStatusBar(String status) {
    // Define the status stages
    List<String> progressStages = [
      'Đang Chờ Xử Lý', // PENDING
      'Đã Xác Nhận', // CONFIRMED
      'Đã Giao Hàng', // SHIPPED
      'Đã Hủy', // CANCELLED
      'Đã Kết Toán', // COMPLETED
    ];

    // Define the color to apply (green for completed stages, grey for uncompleted ones)
    Color getStatusColor(String stage, String currentStatus) {
      return progressStages.indexOf(stage) <=
              progressStages.indexOf(currentStatus)
          ? const Color(0xFF20B6E8) // Green for completed stages
          : Colors.grey.shade300; // Grey for uncompleted stages
    }

    return SizedBox(
      height: 20,
      child: Row(
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

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/controllers/order_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/screens/detail/chi_tiet_hoa_%C4%91%C6%A1n.dart';
import 'package:pharmacy_app/screens/detail/instant_purchase.dart';

class PurchaseHistoryScreen extends StatefulWidget {
  const PurchaseHistoryScreen({super.key});

  @override
  _PurchaseHistoryScreenState createState() => _PurchaseHistoryScreenState();
}

class _PurchaseHistoryScreenState extends State<PurchaseHistoryScreen> {
  final OrderController _orderController = OrderController();
  final formatter = NumberFormat.decimalPattern();
  List<Map<String, dynamic>> _completedOrders = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCompletedOrders();
  }

  Future<void> _loadCompletedOrders() async {
    try {
      final orders = await _orderController.getOrdersForCurrentUser();
      setState(() {
        _completedOrders = orders
            .where((order) =>
                order['status'] == 'Đã Giao Hàng') // Filter completed orders
            .toList();
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lỗi khi tải lịch sử mua hàng: $e'),
      ));
    }
  }

  void _rePurchase(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          items: order['items'], // Pass the order items
          totalPrice: double.tryParse(order['total'] ?? '0') ??
              0.0, // Pass the total price
        ),
      ),
    );
  }

  void _viewOrder(Map<String, dynamic> order) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => OrderDetailScreen(
          order: order,
          showRebuyButton: true,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        title: const CustomText(text: 'LỊCH SỬ MUA HÀNG', size: 20),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF20B6E8), Color(0xFF16B2A5)],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF16B2A5)),
            )
          : _completedOrders.isEmpty
              ? const Center(
                  child: Text(
                    'Không có lịch sử mua hàng.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _completedOrders.length,
                  itemBuilder: (context, index) {
                    final order = _completedOrders[index];
                    return _buildHistoryCard(order);
                  },
                ),
    );
  }

  String removeDecimal(String number) {
    try {
      // Convert the string to a double and format it as an integer
      double value = double.parse(number);
      return value.toStringAsFixed(0);
    } catch (e) {
      // Return the original number or an error message if parsing fails
      return number;
    }
  }

  Widget _buildHistoryCard(Map<String, dynamic> order) {
    return Card(
      color: Colors.white,
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Mã đơn hàng: ${order['orderId']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text('Ngày hoàn tất: ${order['orderDate']}'),
            Text(
                'Tổng tiền: ${formatter.format(double.parse(order['total']))} đ'),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _rePurchase(order),
                  icon: const Icon(
                    Icons.shopping_cart,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'Mua Lại',
                    style: TextStyle(color: Colors.white),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF16B2A5),
                  ),
                ),
                OutlinedButton.icon(
                  onPressed: () => _viewOrder(order),
                  icon: const Icon(Icons.visibility),
                  label: const Text('Xem Đơn'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: const Color(0xFF16B2A5),
                    side: const BorderSide(color: Color(0xFF16B2A5)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

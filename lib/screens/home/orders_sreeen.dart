import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/order_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/screens/home/search_results.dart';

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
      // Handle error, e.g., show a snackbar or dialog
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8,
        shadowColor: Colors.black,
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF20B6E8),
                Color(0xFF16B2A5),
              ],
            ),
          ),
        ),
        title: const Center(
            child: Row(
          children: [
            Icon(
              Icons.receipt,
              color: Colors.white,
              shadows: [
                Shadow(
                  offset: Offset(
                      2.0, 2.0), // Position of the shadow (right and down)
                  blurRadius: 3.0, // Blur radius of the shadow
                  color: Color.fromARGB(255, 0, 0, 0), // Shadow color (black)
                ),
                Shadow(
                  offset: Offset(
                      -2.0, -2.0), // Position of a second shadow (left and up)
                  blurRadius: 3.0,
                  color: Color.fromARGB(
                      100, 255, 255, 255), // A lighter shadow for the 3D effect
                ),
              ],
            ),
            SizedBox(
              width: 10,
            ),
            CustomText(text: 'ĐƠN HÀNG CỦA BẠN', size: 20),
          ],
        )),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.search,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const SearchResultPage(),
                ),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: _orders.length,
              itemBuilder: (context, index) {
                final order = _orders[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 10),
                  child: ListTile(
                    title: Text('Mã đơn hàng: ${order['orderId']}'),
                    subtitle: Text('Trạng thái: ${order['status']}'),
                    trailing: Text(
                        '${order['total']}'), // Already includes currency symbol
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

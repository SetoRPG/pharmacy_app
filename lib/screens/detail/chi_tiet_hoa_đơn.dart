// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:pharmacy_app/controllers/auth_controller.dart';
import 'package:pharmacy_app/controllers/order_controller.dart';

import 'package:pharmacy_app/core/widgets/custom_appbar.dart';

AuthController _authController = AuthController();
OrderController _orderController = OrderController();

class OrderDetailScreen extends StatelessWidget {
  final Map<String, dynamic> order;
  const OrderDetailScreen({super.key, required this.order});

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> items =
        List<Map<String, dynamic>>.from(order['items']);
    DateTime dateCreated = order['orderDate'] is Timestamp
        ? (order['orderDate'] as Timestamp).toDate()
        : order['orderDate'] as DateTime;

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'XEM HÓA ĐƠN',
        logo: Icons.info,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Thông tin người nhận',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              FutureBuilder<String?>(
                future: _authController.getUsernameByEmail(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Text('Đang tải...');
                  } else if (snapshot.hasError) {
                    return const Text('Không thể tải tên khách hàng');
                  } else if (snapshot.hasData && snapshot.data != null) {
                    return Text('KH: ${snapshot.data}');
                  } else {
                    return const Text('Không có thông tin khách hàng');
                  }
                },
              ),
              const SizedBox(height: 8),
              Text(
                  'Địa chỉ: ${order['location']}'), // If address is part of the order data
              Divider(color: Colors.grey.withOpacity(0.2)),
              Text(
                'Sản phẩm đã mua',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 8),
              ...items.map((item) {
                return FutureBuilder<String>(
                  future:
                      _orderController.getMedicinePicture(item['productId']),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      // Show a loading spinner or placeholder while waiting for the image URL
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      // Handle error if the future fails
                      return Text('Error: ${snapshot.error}');
                    } else if (snapshot.hasData) {
                      // Once the future completes, pass the image URL to your buildProductItem method
                      return buildProductItem(
                        item['productName'],
                        snapshot.data!, // Image URL obtained from the Future
                        item['quantity'],
                        (item['price'] as num).toInt(),
                      );
                    } else {
                      // If no data is available
                      return buildProductItem(
                        item['productName'],
                        '', // Image URL obtained from the Future
                        item['quantity'],
                        (item['price'] as num).toInt(),
                      );
                    }
                  },
                );
              }),
              Divider(color: Colors.grey.withOpacity(0.2)),
              Text(
                'Chi tiết thanh toán',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              buildPaymentDetailRow(
                  'Tiền hàng', '${removeDecimal(order['total'])} đ'),
              buildPaymentDetailRow('Phí vận chuyển', '0 đ'),
              buildPaymentDetailRow(
                  'Tổng thanh toán', '${removeDecimal(order['total'])} đ',
                  isBold: true, isRed: true),
              const SizedBox(height: 16),
              Text(
                'Mã đơn hàng: ${order['orderId']}',
                style: GoogleFonts.lato(fontSize: 16),
              ),
              Text(
                'Thời gian đặt hàng: ${dateCreated.toString()}',
                style: GoogleFonts.lato(fontSize: 16),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
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

  Widget buildProductItem(
      String name, String imageUrl, int quantity, int price) {
    return ListTile(
      leading: Image.network(
        imageUrl,
        width: 50,
        height: 50,
        errorBuilder: (context, error, stackTrace) {
          return const Icon(Icons.image_not_supported);
        },
      ),
      title: Text(name,
          style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.bold)),
      subtitle: Text('x $quantity', style: GoogleFonts.lato(fontSize: 14)),
      trailing:
          Text('${price * quantity} đ', style: GoogleFonts.lato(fontSize: 16)),
    );
  }

  Widget buildPaymentDetailRow(String label, String value,
      {bool isBold = false, bool isRed = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label,
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
          Text(value,
              style: GoogleFonts.roboto(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
                  color: isRed ? Colors.red : Colors.black)),
        ],
      ),
    );
  }
}

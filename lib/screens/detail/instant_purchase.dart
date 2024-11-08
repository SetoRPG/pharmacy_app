// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/order_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_appbar.dart';
import 'package:pharmacy_app/screens/home/base_frame.dart';

class PaymentPage extends StatefulWidget {
  final List<Map<String, dynamic>> items;
  final double totalPrice;

  const PaymentPage({
    super.key,
    required this.items,
    required this.totalPrice,
  });

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final OrderController _orderController =
      OrderController(); // Initialize OrderController
  final Map<String, String?> _imageCache = {};
  double discount = 0; // Giảm giá mặc định là 0
  double totalPrice = 0; // Tổng giá ban đầu
  String selectedPromoCode = ''; // Mã khuyến mãi đã chọn
  String note = ''; // Ghi chú của người dùng
  String location = '';
  String selectedPaymentMethod = 'COD'; // Phương thức thanh toán đã chọn

  @override
  void initState() {
    super.initState();
    totalPrice = widget.totalPrice;
  }

  // Hàm áp dụng mã khuyến mãi
  void applyPromoCode(String code, double discountPercentage) {
    setState(() {
      selectedPromoCode = code;
      discount = discountPercentage * widget.totalPrice; // Tính giảm giá
      totalPrice =
          widget.totalPrice - discount; // Cập nhật tổng tiền sau giảm giá
    });
  }

  // Danh sách mã khuyến mãi
  final List<Map<String, dynamic>> promoCodes = [
    {
      'code': 'DISCOUNT10',
      'description': 'Giảm 10%',
      'discountPercentage': 0.1
    },
    {
      'code': 'DISCOUNT20',
      'description': 'Giảm 20%',
      'discountPercentage': 0.2
    },
    {
      'code': 'DISCOUNT50',
      'description': 'Giảm 50%',
      'discountPercentage': 0.5
    },
  ];

  // Danh sách các phương thức thanh toán
  final List<String> paymentMethods = [
    'COD',
    'Momo',
    'ZaloPay',
    'Visa',
    'Mastercard',
  ];

  // Hiển thị danh sách mã khuyến mãi
  void showPromoCodeBottomSheet() {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Chọn mã khuyến mãi',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              ListView.builder(
                shrinkWrap: true, // Để danh sách không chiếm hết chiều cao
                itemCount: promoCodes.length,
                itemBuilder: (BuildContext context, int index) {
                  final promo = promoCodes[index];
                  return ListTile(
                    title: Text(promo['description']),
                    subtitle: Text(promo['code']),
                    onTap: () {
                      applyPromoCode(
                          promo['code'], promo['discountPercentage']);
                      Navigator.pop(context); // Đóng bottom sheet
                    },
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: const CustomAppBar(title: 'THANH TOÁN', logo: Icons.attach_money),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Text(
                  'Địa chỉ : ',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        location = value;
                      });
                    },
                    cursorColor: const Color.fromARGB(255, 53, 255, 245),
                    decoration: const InputDecoration(
                      hintText: 'Nhập địa chỉ giao hàng ở đây',
                      border: OutlineInputBorder(),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 53, 255, 245),
                        ),
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 16,
            ),
            Expanded(
              child: Expanded(
                child: Scrollbar(
                  thumbVisibility: true,
                  child: ListView.builder(
                    itemCount: widget.items.length,
                    itemBuilder: (context, index) {
                      var item = widget.items[index];
                      String? imageUrl = _imageCache[item['medId']];

                      return ListTile(
                        leading: imageUrl != null
                            ? Image.network(imageUrl, fit: BoxFit.cover)
                            : FutureBuilder<String>(
                                future: _orderController
                                    .getMedicinePicture(item['medId']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    return const CircularProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    return const Icon(Icons.error);
                                  } else {
                                    _imageCache[item['medId']] =
                                        snapshot.data; // Cache the result
                                    return Image.network(snapshot.data!,
                                        fit: BoxFit.cover);
                                  }
                                },
                              ),
                        title: Text(
                          item['medName'] ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text('Số lượng: ${item['quantity']}'),
                        trailing: Text(
                          '${(item['medPrice']).toStringAsFixed(0)} ₫',
                          style: const TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Text(
                  'Ghi chú :',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: TextField(
                    onChanged: (value) {
                      setState(() {
                        note = value;
                      });
                    },
                    cursorColor: const Color.fromARGB(255, 53, 255, 245),
                    decoration: const InputDecoration(
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                          color: Color.fromARGB(255, 53, 255, 245),
                        ),
                      ),
                      hintText: 'Nhập ghi chú ở đây',
                      border: OutlineInputBorder(),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    ),
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // Phương thức thanh toán
            const Text(
              'Phương thức thanh toán',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            DropdownButton<String>(
              value: selectedPaymentMethod,
              onChanged: (String? newValue) {
                setState(() {
                  selectedPaymentMethod = newValue!;
                });
              },
              items:
                  paymentMethods.map<DropdownMenuItem<String>>((String method) {
                return DropdownMenuItem<String>(
                  value: method,
                  child: Text(method),
                );
              }).toList(),
              isExpanded: true,
              underline: Container(
                height: 2,
                color: Colors.blue,
              ),
            ),
            const SizedBox(height: 16),

            // Chi tiết thanh toán
            const Text(
              'Chi tiết thanh toán',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
            ),
            const SizedBox(height: 8),
            _buildPaymentDetailRow('Tổng tiền sản phẩm', widget.totalPrice),
            _buildPaymentDetailRow('Giảm giá', -discount),
            const Divider(),
            _buildPaymentDetailRow('Tổng thanh toán', totalPrice, isBold: true),

            const SizedBox(height: 16),

            // Mã khuyến mãi (di chuyển xuống dưới)
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Mã khuyến mãi'),
                TextButton(
                  onPressed:
                      showPromoCodeBottomSheet, // Mở danh sách mã khuyến mãi
                  child: Text(
                    selectedPromoCode.isEmpty ? 'Chọn mã' : selectedPromoCode,
                    style: const TextStyle(color: Colors.blue),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Nút Đặt hàng
            Center(
              child: ElevatedButton(
                onPressed: () async {
                  try {
                    // Call the createOrder function from the controller
                    await _orderController.createOrderWithMultipleItems(
                      items: widget.items,
                      note: note, // Optional note
                      location: location,
                    );

                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const BaseFrame(
                                  passedIndex: 2,
                                )));

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Đặt hàng thành công!')),
                    );
                  } catch (e) {
                    // Show error message if something goes wrong
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đặt hàng thất bại: $e')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 13),
                  backgroundColor: const Color(0xFF20B6E8), //
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('ĐẶT HÀNG'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Hàm tiện ích để tạo hàng chi tiết thanh toán
  Widget _buildPaymentDetailRow(String label, double amount,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
                fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
          ),
          Text(
            '${amount.toStringAsFixed(0)} ₫',
            style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isBold ? Colors.red : Colors.black,
            ),
          ),
        ],
      ),
    );
  }
}

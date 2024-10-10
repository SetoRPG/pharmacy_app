import 'package:flutter/material.dart';

class PaymentPage extends StatefulWidget {
  const PaymentPage({super.key});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  double productPrice = 171600; // Giá sản phẩm gốc
  double discount = 0; // Giảm giá mặc định là 0
  double totalPrice = 171600; // Tổng giá ban đầu là giá sản phẩm
  String selectedPromoCode = ''; // Mã khuyến mãi đã chọn
  String note = ''; // Ghi chú của người dùng
  String selectedPaymentMethod = 'COD'; // Phương thức thanh toán đã chọn

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

  // Hàm áp dụng mã khuyến mãi
  void applyPromoCode(String code, double discountPercentage) {
    setState(() {
      selectedPromoCode = code;
      discount = discountPercentage * productPrice; // Tính giảm giá
      totalPrice = productPrice - discount; // Tính tổng tiền sau giảm giá
    });
  }

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
      appBar: AppBar(
        title: const Text('Thanh toán'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Thông tin sản phẩm
            ListTile(
              leading: Image.asset(
                'assets/img2.jpg',
                height: 60,
                width: 60,
              ),
              title: const Text(
                'Combo Sữa Rửa Mặt SIMPLE Refreshing Facial Wash 100% Soap Free',
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: const Text('Phân loại: Bộ'),
              trailing: const Text(
                '171.600 ₫',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 16),

            // Phần ghi chú (thay cho mã khuyến mãi)
            const Text(
              'Ghi chú',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            TextField(
              onChanged: (value) {
                setState(() {
                  note = value;
                });
              },
              decoration: const InputDecoration(
                hintText: 'Nhập ghi chú ở đây',
                border: OutlineInputBorder(),
              ),
              maxLines: 2,
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
            _buildPaymentDetailRow('Tổng tiền sản phẩm', productPrice),
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
                onPressed: () {
                  // Đặt hàng logic
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 50),
                ),
                child: const Text('Đặt hàng'),
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

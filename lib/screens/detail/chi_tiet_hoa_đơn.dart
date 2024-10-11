import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: const Color.fromARGB(255, 14, 14, 14)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Text(
                'Chi tiết đơn hàng',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(width: 48),
          ],
        ),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(2.0),
          child: Container(
            color: const Color.fromARGB(255, 214, 212, 212).withOpacity(0.3),
            height: 6.0,
            width: double.infinity,
          ),
        ),
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
              SizedBox(height: 8),
              RichText(
                text: TextSpan(
                  text: 'KH: ',
                  style: GoogleFonts.lato(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    TextSpan(
                      text: '0774008406',
                      style: GoogleFonts.lato(
                        fontWeight: FontWeight.normal,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 8),
              Container(
                color: Colors.grey.withOpacity(0.2),
                height: 1.0,
                width: double.infinity,
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Địa chỉ người nhận:',
                    style: GoogleFonts.roboto(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text.rich(
                    TextSpan(
                      children: <TextSpan>[
                        TextSpan(
                          text: '437 Lê Văn Thọ, Phường 9, Quận Gò Vấp, Tp.HCM',
                          style: GoogleFonts.openSans(
                            fontWeight: FontWeight.normal,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 8),
              Container(
                margin: const EdgeInsets.symmetric(vertical: 8.0),
                color: const Color.fromARGB(255, 214, 212, 212).withOpacity(0.3),
                height: 6.0,
                width: double.infinity,
              ),
              Text(
                'Sản phẩm đã mua',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Container(
                color: Colors.grey.withOpacity(0.2),
                height: 1.0,
                width: double.infinity,
              ),
              Column(
                children: [
                  buildProductItem(
                    'Viên nén Prednison 5mg kháng viêm, điều trị viêm thấp khớp, chống dị ứng',
                    'https://link_to_prednison_image',
                    'Viên',
                    400,
                    5,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.2)),
                  buildProductItem(
                    'Viên uống Kolmar Condition Let\'s C Premium Bổ sung vitamin C',
                    'https://link_to_vitamin_c_image',
                    'Viên',
                    3700,
                    5,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.2)),
                  buildProductItem(
                    'Cao dán Salonpas 6.5cmx4.2cm giảm đau vai, đau lưng, đau cơ, đau khớp',
                    'https://link_to_salonpas_image',
                    'Gói',
                    13000,
                    1,
                  ),
                  Divider(color: Colors.grey.withOpacity(0.2)),
                  buildProductItem(
                    'Thuốc cắt liều VVPQC',
                    'https://link_to_generic_image',
                    'Lieu',
                    20000,
                    5,
                  ),
                ],
              ),
              SizedBox(height: 8),
              Text(
                'Chi tiết thanh toán',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              buildPaymentDetailRow('Tiền hàng (16 sản phẩm)', '133.500 đ'),
              buildPaymentDetailRow('Phí vận chuyển', '0 đ'),
              SizedBox(height: 10),
              buildPaymentDetailRow('Tổng thanh toán', '133.500 đ', isBold: true, isRed: true),
              SizedBox(height: 16),
              Text(
                'Mã đơn hàng',
                style: GoogleFonts.openSans(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text('SGPMC691-SGPMC69102-55619', style: GoogleFonts.lato(fontSize: 16)),
              SizedBox(height: 4),
              Text('Thời gian đặt hàng: 22:39 21/08/2023', style: GoogleFonts.lato(fontSize: 16)),
              SizedBox(height: 16),
              Text(
                'Lưu ý',
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 8),
              Text(
                '• "Ting ting" - Tin nhắn xác nhận sẽ được gửi đến bạn khi đơn hàng được xử lý thành công.',
                style: GoogleFonts.lato(fontSize: 14),
              ),
              Text(
                '• Đơn hàng sẽ được cập nhật vào "Lịch sử đơn hàng" chậm nhất 30 phút kể từ lúc đặt hàng.',
                style: GoogleFonts.lato(fontSize: 14),
              ),
              Text(
                '• Đối với đơn hàng nhận tại nhà thuốc Pharmacy: Bạn hãy kiểm tra đơn hàng với dược sĩ trước khi nhận hàng và thanh toán (nếu có).',
                style: GoogleFonts.lato(fontSize: 14),
              ),
              Text(
                '• Đối với đơn hàng nhận tại địa chỉ của bạn: Tài xế sẽ gọi cho bạn trước khi giao hàng, hãy chú ý điện thoại.',
                style: GoogleFonts.lato(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildProductItem(String name, String imageUrl, String type, int price, int quantity) {
    return Card(
      child: ListTile(
        leading: Image.network(
          imageUrl,
          width: 50,
          height: 50,
          errorBuilder: (context, error, stackTrace) {
            return Icon(Icons.image_not_supported);
          },
        ),
        title: Text(
          name,
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            fontSize: 16,
          ),
        ),
        subtitle: Text(
          'Phân loại: $type',
          style: GoogleFonts.lato(
            fontWeight: FontWeight.normal,
            fontSize: 14,
          ),
        ),
        trailing: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '$price đ',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            Text(
              'x $quantity',
              style: GoogleFonts.lato(
                fontWeight: FontWeight.normal,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildPaymentDetailRow(String label, String value, {bool isBold = false, bool isRed = false, bool isYellow = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: GoogleFonts.roboto(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
              color: isRed ? Colors.red : (isYellow ? Colors.orange : Colors.black),
            ),
          ),
        ],
      ),
    );
  }
}

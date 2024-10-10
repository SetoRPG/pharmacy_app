import 'package:flutter/material.dart';

class XemChiTietSp extends StatelessWidget {
  const XemChiTietSp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'Chi tiết sản phẩm',
          style: TextStyle(color: Colors.black),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: const [
          // Thành phần
          Text(
            'Thành phần',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Công thức cải tiến có chứa hoạt chất AIRLICIUM đã được kiểm nghiệm lâm sàng về hiệu quả hấp thụ bã nhờn, giúp da luôn khô ráo, thoáng mịn, phù hợp cho làn da hỗn hợp và da dầu mụn.\nCông Nghệ Netlock lâu trôi trong nước.',
          ),
          SizedBox(height: 16),

          // Công dụng
          Text(
            'Công dụng',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '• Chứa 8 màng lọc, trong đó có Màng lọc phổ rộng độc quyền MEXORYL 400 giúp bảo vệ da khỏi tia UVA dài (đặc biệt bước sóng 380-400nm) – nguyên nhân chính gây thâm nám.\n'
            '• Ngăn ngừa và giảm thâm nám.\n'
            '• Giảm quá trình tiết bã nhờn.\n'
            '• Kháng nước, kháng cát, mồ hôi kết cấu mỏng nhẹ thấm nhanh.\n'
            '• Không bóng nhờn, không để lại vết trắng trên da.\n'
            '• Da được bảo vệ toàn diện và kiểm dầu suốt 12h.',
          ),
          SizedBox(height: 16),

          // Đối tượng sử dụng
          Text(
            'Đối tượng sử dụng',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '• Phù hợp với da thường, da dầu có mụn viêm, dễ bị nám, tăng sắc tố thích dạng sữa lỏng mỏng nhẹ.\n'
            '• Từ 16 tuổi trở lên.',
          ),
          SizedBox(height: 16),

          // Cách sử dụng
          Text(
            'Cách sử dụng',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '• Thoa toàn mặt vào buổi sáng lấy 3-5 hạt bắp thoa ngang từ trong ra ngoài và từ trên xuống dưới.\n'
            '• Chú ý: đợi kem dưỡng thấm hoàn toàn rồi thoa kem chống nắng lên.',
          ),
          SizedBox(height: 16),

          // Thông tin sản xuất
          Text(
            'Thông tin sản xuất',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 8),
          Text(
            '• Bảo quản: bảo quản nhiệt độ thường\n'
            '• Thương hiệu: LA ROCHE POSAY\n'
            '• Sản xuất tại: Pháp\n'
            '• Tên Nhà sản xuất: CAP - Etablissement de La Roche Posay\n'
            '• Số Giấy công bố: 203276/23/CBMP-QLD\n'
            '• Số Giấy xác nhận quảng cáo: 724/2024/XNQC-YTHCM\n'
            '• Công ty chịu trách nhiệm về SP: Công Ty TNHH L\'oreal Việt Nam\n'
            '• Công ty phân phối: Công Ty TNHH DKSH Việt Nam',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
        title: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.9),
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Tìm thuốc...',
              border: InputBorder.none,
              icon: Icon(Icons.search, color: Colors.grey[600]),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            // Welcome message
            const Text(
              'Chào mừng đến với INGOUDE',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 40),

            // Featured Medicine
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.blue[100]!, Colors.blue[200]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                    offset: const Offset(2.0, 4.0),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Giới thiệu thuốc',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Paracetamol - Thuốc giảm đau và hạ sốt.',
                    style: TextStyle(fontSize: 16, color: Colors.black54),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      // Navigate to detailed view or add to cart
                    },
                    child: const Text('Xem chi tiết'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // Categories Section
            const Text(
              'Danh mục',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                _categoryCard('Giảm đau', Icons.healing),
                _categoryCard('Ho & Cảm lạnh', Icons.local_hospital),
                _categoryCard('Vitamins', Icons.local_florist),
                _categoryCard('Băng cứu thương', Icons.healing),
              ],
            ),
            const SizedBox(height: 40),

            // Promotions Section
            const Text(
              'Khuyến mãi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(16.0),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green[100]!, Colors.green[200]!],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(8.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    blurRadius: 8.0,
                    spreadRadius: 2.0,
                    offset: const Offset(2.0, 4.0),
                  ),
                ],
              ),
              child: const Text(
                'Giảm 20% giá toàn bộ mặt hàng Vitamin trong tuần!',
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
            ),
            const SizedBox(height: 40),

            // About Us Section
            const Text(
              'Về chúng tôi',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'Cung cấp đa dạng các loại thuốc, thực phẩm bổ sung, và sản phẩm về sức khỏe với nhiều ưu đãi và giao tận nhà',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _categoryCard(String title, IconData icon) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            blurRadius: 8.0,
            spreadRadius: 2.0,
            offset: const Offset(2.0, 4.0),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.blue[400], size: 40),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 14, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

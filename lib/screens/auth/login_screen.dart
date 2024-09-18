import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        elevation: 0,
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(Icons.account_circle, color: Colors.white),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {},
          ),
        ],
      ),
      body: Column(
        children: [
          // Search bar and promotional banner
          Container(
            padding: EdgeInsets.all(16),
            color: Colors.blue,
            child: Column(
              children: [
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Tên thuốc, triệu chứng, vitamin và th...',
                    fillColor: Colors.white,
                    filled: true,
                    prefixIcon: Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Image.network(
                  'https://example.com/banner_image.png', // Placeholder for the banner image
                  height: 100,
                ),
              ],
            ),
          ),
          // Icon Grid Section
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: GridView.count(
              shrinkWrap: true,
              crossAxisCount: 4,
              children: [
                IconGridItem(
                  icon: Icons.medical_services,
                  label: 'Tư vấn thuốc',
                ),
                IconGridItem(
                  icon: Icons.local_pharmacy,
                  label: 'Đặt thuốc theo đơn',
                ),
                IconGridItem(
                  icon: Icons.support_agent,
                  label: 'Liên hệ dược sĩ',
                ),
                IconGridItem(
                  icon: Icons.shopping_basket,
                  label: 'Chi tiêu sức khỏe',
                ),
                IconGridItem(
                  icon: Icons.medical_services_outlined,
                  label: 'Hồ sơ sức khoẻ',
                ),
                IconGridItem(
                  icon: Icons.family_restroom,
                  label: 'Hồ sơ gia đình',
                ),
                IconGridItem(
                  icon: Icons.store,
                  label: 'Hệ thống nhà thuốc',
                ),
                IconGridItem(
                  icon: Icons.business_center,
                  label: 'Doanh nghiệp',
                ),
              ],
            ),
          ),
          // Bottom Banner
          Container(
            color: Colors.green[100],
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  'Thu xịt hen cũ đổi xịt hen mới',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 10),
                Row(
                  children: [
                    Image.network(
                      'https://example.com/product_image.png', // Placeholder for product image
                      height: 50,
                    ),
                    Spacer(),
                    Text(
                      'Trợ giá tân tình đến 10.000 VND/cái',
                      style: TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard),
            label: 'Danh mục',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.support_agent),
            label: 'Tư vấn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Đơn hàng',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}

class IconGridItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const IconGridItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(icon, size: 40),
        SizedBox(height: 8),
        Text(
          label,
          style: TextStyle(fontSize: 12),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
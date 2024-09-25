import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isSearching = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 8, // Adds shadow to the AppBar
        shadowColor: Colors.black, // Customize shadow color

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

        title: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: _isSearching
              ? MediaQuery.of(context).size.width *
                  1 // Full width when searching
              : MediaQuery.of(context).size.width *
                  1, // Small width when not searching
          padding: const EdgeInsets.symmetric(horizontal: 12.0),
          decoration: BoxDecoration(
            color: _isSearching
                ? Colors.white
                : Colors.transparent, // White background for the search field
            borderRadius:
                BorderRadius.circular(30.0), // Rounded edges for search field
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              if (_isSearching)
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Tìm thuốc...',
                      border: InputBorder.none,
                      icon: Icon(
                        Icons.search,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                )
              else
                const Center(
                    child: Row(
                  children: [
                    Icon(
                      Icons.home,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          offset: Offset(2.0,
                              2.0), // Position of the shadow (right and down)
                          blurRadius: 3.0, // Blur radius of the shadow
                          color: Color.fromARGB(
                              255, 0, 0, 0), // Shadow color (black)
                        ),
                        Shadow(
                          offset: Offset(-2.0,
                              -2.0), // Position of a second shadow (left and up)
                          blurRadius: 3.0,
                          color: Color.fromARGB(100, 255, 255,
                              255), // A lighter shadow for the 3D effect
                        ),
                      ],
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    CustomText(text: 'TRANG CHỦ', size: 20),
                  ],
                )),
            ],
          ),
        ),

        actions: [
          IconButton(
            icon: Icon(
              _isSearching
                  ? Icons.close
                  : Icons.search, // Change icon based on search state
              color: Colors.white,
            ),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching; // Toggle search bar visibility
              });
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.only(left: 10.0, right: 10),
        child: ListView(
          children: [
            const SizedBox(height: 40),
            _buildIntroductionSection(),
            const SizedBox(height: 40),
            _buildCategoriesSection(),
            const SizedBox(height: 40),
            _buildPromotionsSection(),
            const SizedBox(height: 40),
            _buildAboutUsSection(),
            const SizedBox(height: 40),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  // Section 1: Giới thiệu thuốc (Medicine introduction)
  Widget _buildIntroductionSection() {
    return Container(
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
    );
  }

  // Section 2: Danh mục (Categories section)
  Widget _buildCategoriesSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
      ],
    );
  }

  // Section 3: Khuyến mãi (Promotions section)
  Widget _buildPromotionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
            child: Column(
              children: [
                const Text(
                  'Giảm 20% giá toàn bộ mặt hàng Vitamin trong tuần!',
                  style: TextStyle(fontSize: 16, color: Colors.black54),
                ),
                const SizedBox(
                  height: 10,
                ),
                Image.asset('assets/sales_banner.jpg')
              ],
            )),
      ],
    );
  }

  // Section 4: Về chúng tôi (About Us section)
  Widget _buildAboutUsSection() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Về chúng tôi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Cung cấp đa dạng các loại thuốc, thực phẩm bổ sung, '
          'và sản phẩm về sức khỏe với nhiều ưu đãi và giao tận nhà',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  // Reusable method for category cards
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

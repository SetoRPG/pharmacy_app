// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_appbar.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/screens/detail/basket_screen.dart';
import 'package:pharmacy_app/screens/detail/medicine_detail.dart';
import 'package:pharmacy_app/screens/home/search_results.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async'; // For Timer

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MedicineController _medicineController = MedicineController();
  List<Map<String, dynamic>> _medicines = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    final medicines = await _medicineController.getMedicines();
    setState(() {
      _medicines = medicines;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'TRANG CHỦ',
        logo: Icons.home,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: ListView(
                children: [
                  const SizedBox(height: 40),
                  // Thêm padding cho Categories
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10), // Padding cho Categories
                    child: _buildCategoriesSection(),
                  ),
                  const SizedBox(height: 40),
                  // Không thêm padding cho PromotionsSection
                  _buildPromotionsSection(), // Promotions section không có padding
                  const SizedBox(height: 40),
                  // Thêm padding cho Introduction
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10), // Padding cho Introduction
                    child: _buildIntroductionSection(),
                  ),
                  const SizedBox(height: 40),
                  // Thêm padding cho About Us
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 10, right: 10), // Padding cho About Us
                    child: _buildAboutUsSection(),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
      backgroundColor: Colors.white,
    );
  }

  /// Section 1: Giới thiệu thuốc (Medicine introduction)
  Widget _buildIntroductionSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thuốc bán chạy',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Cuộn theo chiều ngang
          child: Row(
            children: _medicines.map((medicine) {
              return Container(
                width: 160, // Chiều rộng cố định cho từng sản phẩm
                margin: const EdgeInsets.only(
                    right: 10), // Khoảng cách giữa các sản phẩm
                child: _medicineCard(medicine), // Xây dựng từng card sản phẩm
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  /// Medicine Card Widget
  Widget _medicineCard(Map<String, dynamic> medicine) {
    return GestureDetector(
      onTap: () {
        // Navigate to ChiTietSanPham page and pass the medicine ID
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChiTietSp(
                medicineId: medicine[
                    'id']), // Replace 'medId' with the actual field name for your medicine ID
          ),
        );
      },
      child: Card(
        elevation: 3,
        margin: const EdgeInsets.symmetric(
            horizontal: 8), // Add margin between cards
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Displaying image at the top of the card
              Center(
                child: Image.network(
                  _getImageUrl(medicine['medPrimaryImage']),
                  width: 130,
                  height: 130,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error,
                        size: 100); // Error icon if image fails to load
                  },
                ),
              ),
              const SizedBox(height: 10),

              // Medicine name
              Text(
                medicine['medName'],
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis, // Truncate if too long
              ),
              const SizedBox(height: 6),

              // Price
              Text(
                '${medicine['medPrice']} đ',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              ElevatedButton(
                onPressed: () {
                  // Thêm chức năng cho nút ở đây
                },
                child: const Text('Chọn sản phẩm',
                    style: TextStyle(fontSize: 14)), // Nút nhãn
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Màu chữ
                  backgroundColor: Colors.blue, // Màu nền nút
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4), // Tạo kích thước nút hợp lý
                  shape: RoundedRectangleBorder(
                    // Làm góc bo tròn cho nút
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

// Helper function to convert gs:// URLs to HTTPS
  String _getImageUrl(String gsUrl) {
    const storageBaseUrl =
        "https://storage.googleapis.com/pharmadirect-a8570.appspot.com/";
    if (gsUrl.startsWith("gs://pharmadirect-a8570.appspot.com/")) {
      return gsUrl.replaceFirst(
          "gs://pharmadirect-a8570.appspot.com/", storageBaseUrl);
    }
    return gsUrl;
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
    // Tạo PageController
    final PageController _pageController = PageController();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: const Text(
            'Khuyến mãi',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            const Text(
              'Giảm 20% giá toàn bộ mặt hàng Vitamin trong tuần!',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
            const SizedBox(height: 10),

            // PageView để cuộn qua các trang chứa hình ảnh
            SizedBox(
              height: 160, // Chiều cao của PageView
              child: PageView(
                controller: _pageController,
                scrollDirection: Axis.horizontal, // Cuộn ngang
                children: [
                  _buildImagePage('assets/sales_banner.jpg'),
                  _buildImagePage('assets/logo.jpg'),
                  _buildImagePage('assets/sales_banner.jpg'),
                  _buildImagePage('assets/logo.jpg'),
                  _buildImagePage('assets/sales_banner.jpg'),
                ],
              ),
            ),
            const SizedBox(
                height: 10), // Khoảng cách giữa PageView và Indicator

            // Thêm SmoothPageIndicator
            SmoothPageIndicator(
              controller: _pageController,
              count: 5, // Số lượng trang
              effect: ExpandingDotsEffect(
                // Kiểu hiệu ứng
                dotHeight: 5,
                dotWidth: 5,
                activeDotColor: Colors.blue, // Màu dot khi được chọn
                dotColor: Colors.grey, // Màu dot chưa được chọn
              ),
            ),
          ],
        ),
      ],
    );
  }

// Hàm để tạo trang cho từng ảnh trong PageView
  Widget _buildImagePage(String assetPath) {
    return ClipRRect(
      child: Image.asset(
        assetPath,
        fit: BoxFit.cover, // Ảnh vừa với khung hình
        width: double.infinity,
        height: 150,
      ),
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

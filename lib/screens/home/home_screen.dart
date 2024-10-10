// ignore_for_file: unused_element

import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/screens/detail/chi_tiet_sp.dart';
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

        title: const Center(
            child: Row(
          children: [
            Icon(
              Icons.home,
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
            CustomText(text: 'TRANG CHỦ', size: 20),
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
          : Padding(
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

  /// Section 1: Giới thiệu thuốc (Medicine introduction)
  Widget _buildIntroductionSection() {
    PageController pageController = PageController();
    Timer? autoScrollTimer;

    // Start the auto-scrolling behavior
    void startAutoScroll() {
      autoScrollTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
        if (pageController.hasClients) {
          int nextPage = (pageController.page?.toInt() ?? 0) + 1;
          if (nextPage >= _medicines.length) {
            nextPage = 0; // Loop back to the first page
          }
          pageController.animateToPage(
            nextPage,
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeInOut,
          );
        }
      });
    }

    // Cancel auto-scroll timer when not needed
    void cancelAutoScroll() {
      autoScrollTimer?.cancel();
    }

    @override
    void initState() {
      super.initState();
      startAutoScroll(); // Start auto-scrolling when the widget is created
    }

    @override
    void dispose() {
      cancelAutoScroll(); // Cancel timer when widget is disposed
      pageController.dispose();
      super.dispose();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Thuốc bán chạy',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 10,
        ),
        SizedBox(
          height: 300, // Adjust the height for better swiping experience
          child: Stack(
            children: [
              // Swipeable Image Carousel
              PageView.builder(
                controller: pageController,
                itemCount: _medicines.length,
                itemBuilder: (context, index) {
                  final medicine = _medicines[index];
                  return _medicineCard(medicine); // Each card
                },
              ),
              // SmoothPageIndicator
              Positioned(
                bottom: 10,
                left: 0,
                right: 0,
                child: Center(
                  child: SmoothPageIndicator(
                    controller: pageController,
                    count: _medicines.length,
                    effect: const ExpandingDotsEffect(
                      dotColor: Colors.grey,
                      activeDotColor: Colors.blueAccent,
                      dotHeight: 8,
                      dotWidth: 8,
                      expansionFactor: 2,
                    ),
                  ),
                ),
              ),
            ],
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

              // Active ingredients
              Text(
                'Thành phần hoạt chất: ${medicine['medActiveIngredients']}',
                style: const TextStyle(fontSize: 14, color: Colors.black54),
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis, // Limit to 2 lines and truncate
              ),
              const SizedBox(height: 6),

              // Price
              Text(
                'Giá: ${medicine['medPrice']} VND',
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 6),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Khuyến mãi',
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Column(
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
        ),
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

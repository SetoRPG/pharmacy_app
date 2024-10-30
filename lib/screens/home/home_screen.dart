// ignore_for_file: unused_element, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';
import 'package:pharmacy_app/controllers/order_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_appbar.dart';
import 'package:pharmacy_app/screens/detail/instant_purchase.dart';
import 'package:pharmacy_app/screens/detail/medicine_detail.dart';
import 'package:pharmacy_app/screens/home/base_frame.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'dart:async'; // For Timer

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final MedicineController _medicineController = MedicineController();
  final OrderController _orderController = OrderController();
  List<Map<String, dynamic>> _medicines = [];
  final ScrollController _scrollController = ScrollController();
  final PageController _pageController = PageController();
  bool _isLoading = true;
  Timer? _timer;
  Timer? _scrollTimer;
  bool _isUserInteracting = false;

  final List<String> imagePaths = [
    'assets/sales_banner.jpg',
    'assets/logo.jpg',
    'assets/sales_banner.jpg',
    'assets/logo.jpg',
    'assets/sales_banner.jpg',
  ];

  List<Widget> _imagePages = [];

  @override
  void dispose() {
    _timer?.cancel();
    _scrollTimer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _loadMedicines();
    _imagePages = List.generate(
        imagePaths.length, (index) => _buildImagePage(imagePaths[index]));
    startTimer();
    startAutoScroll();
  }

  void startTimer() {
    _timer = Timer.periodic(
      const Duration(seconds: 3),
      (timer) {
        if (_pageController.hasClients) {
          if (_pageController.page == imagePaths.length - 1) {
            _pageController.animateToPage(0,
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          } else {
            _pageController.nextPage(
                duration: const Duration(milliseconds: 500),
                curve: Curves.easeInOut);
          }
        }
      },
    );
  }

  void startAutoScroll() {
    _scrollTimer?.cancel();
    _scrollTimer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      if (_scrollController.hasClients && !_isUserInteracting) {
        // Scroll by a small amount each time
        _scrollController.jumpTo(_scrollController.offset + 1);

        // If the end of the list is reached, go back to the beginning
        if (_scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent) {
          _scrollController.jumpTo(0);
        }
      }
    });
  }

  void _stopAutoScroll() {
    _scrollTimer?.cancel();
  }

  void _onUserInteractionStart() {
    setState(() {
      _isUserInteracting = true;
    });
    _stopAutoScroll();
  }

  void _onUserInteractionEnd() {
    setState(() {
      _isUserInteracting = false;
    });
    Future.delayed(const Duration(seconds: 3),
        startAutoScroll); // Restart auto-scrolling after a delay
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
      appBar: const CustomAppBar(
        title: 'TRANG CHỦ',
        logo: Icons.home,
        showBackButton: false,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(0xFF16B2A5),
            ))
          : Padding(
              padding: const EdgeInsets.only(left: 0, right: 0),
              child: ListView(
                children: [
                  const SizedBox(height: 40),
                  _buildPromotionsSection(),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: _buildIntroductionSection(),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
                    child: _buildCategoriesSection(),
                  ),
                  const SizedBox(height: 50),
                  Padding(
                    padding: const EdgeInsets.only(left: 10, right: 10),
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
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10.0),
          child: Text(
            '⚡ THUỐC BÁN CHẠY ⚡',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFFFD700),
            ),
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 370,
          child: /*GestureDetector(
            onPanDown: (_) => _onUserInteractionStart(),
            onPanCancel: _onUserInteractionEnd,
            onPanEnd: (_) => _onUserInteractionEnd(),
            child:*/
              ListView.builder(
            //controller: _scrollController,
            scrollDirection: Axis.horizontal,
            itemCount: _medicines.length,
            itemBuilder: (context, index) {
              return Container(
                width: 200,
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: _medicineCard(_medicines[index]),
              );
            },
          ),
          /*),*/
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
      child: Container(
        width: 100,
        padding: const EdgeInsets.all(8.0),
        margin: const EdgeInsets.only(top: 8, bottom: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3),
              blurRadius: 8.0,
              spreadRadius: 1.0,
              offset: const Offset(0, 0),
            ),
          ],
        ),
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
                    return const Center(
                        child: CircularProgressIndicator(
                            color: Color(0xFF16B2A5)));
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis, // Truncate if too long
              ),
              const SizedBox(height: 6),

              // Price
              Text(
                '${medicine['medPrice']} ₫',
                style: const TextStyle(
                    fontSize: 24,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                '${medicine['medPackagingForm']}',
                style: const TextStyle(fontSize: 14, color: Colors.black87),
              ),
              const SizedBox(height: 6),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    _showProductBottomSheet(context, medicine);
                  }, // Nút nhãn
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white, // Màu chữ
                    backgroundColor: const Color(0xFF20B6E8), // Màu nền nút
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4), // Tạo kích thước nút hợp lý
                    shape: RoundedRectangleBorder(
                      // Làm góc bo tròn cho nút
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text('MUA NGAY', style: TextStyle(fontSize: 14)),
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
    Set<String> uniqueCategories =
        _medicines.map((med) => med['medCategory'] as String).toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'DANH MỤC',
            style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16B2A5)),
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10,
          runSpacing: 10,
          children: uniqueCategories.map((category) {
            IconData icon = Icons.category;
            return _categoryCard(category, icon);
          }).toList(),
        ),
      ],
    );
  }

  // Section 3: Khuyến mãi (Promotions section)
  Widget _buildPromotionsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(left: 10, right: 10),
          child: Text(
            '🔥 KHUYẾN MÃI 🔥',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFFEB5757), // A bright, attention-grabbing color
            ),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
              child: Text(
                '✨ GIẢM NGAY 20% ✨\nToàn bộ mặt hàng Vitamin trong tuần này!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                  height: 1.5,
                ),
                textAlign: TextAlign.center, // Center the text for emphasis
              ),
            ),
            const SizedBox(height: 10),

            // PageView để cuộn qua các trang chứa hình ảnh
            SizedBox(
              height: 200, // Chiều cao của PageView
              child: PageView.builder(
                controller: _pageController,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return _imagePages[index];
                },
              ),
            ),
            const SizedBox(
                height: 10), // Khoảng cách giữa PageView và Indicator

            // Page Indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: 5,
              effect: const ExpandingDotsEffect(
                dotHeight: 5,
                dotWidth: 5,
                activeDotColor: Color(0xFF20B6E8),
                dotColor: Colors.grey,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 10),
          child: Text(
            'Về chúng tôi',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Color(0xFF16B2A5)),
          ),
        ),
        SizedBox(
          height: 100,
          child: Lottie.asset('assets/healing_hand.json'),
        ),
        const Text(
          'Cung cấp đa dạng các loại thuốc, thực phẩm bổ sung, '
          'và sản phẩm về sức khỏe với nhiều ưu đãi và giao tận nhà',
          style: TextStyle(fontSize: 16, color: Colors.black54),
        ),
      ],
    );
  }

  // Reusable method for category cards
  Widget _categoryCard(String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => BaseFrame(
                      passedIndex: 1,
                      selectedCategory: title,
                    )));
      },
      child: Container(
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
            Icon(icon, color: const Color(0xFF20B6E8), size: 40),
            const SizedBox(height: 8),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                  fontSize: 14,
                  color: Colors.black87,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  void _showProductBottomSheet(
      BuildContext context, Map<String, dynamic> product) {
    int quantity = 1;
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Image.network(
                        _getImageUrl(product['medPrimaryImage']),
                        height: 60,
                        width: 60,
                        fit: BoxFit.cover,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              product['medName'] ?? 'Unknown Product',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              product['medIndications'] ?? 'No Indications',
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              "${product['medPrice']} ₫",
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Phân loại sản phẩm",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => BaseFrame(
                                    passedIndex: 1,
                                    selectedCategory: product['medCategory'],
                                  )));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF16B2A5),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: Text(
                      product['medCategory'] ?? 'Unknown Product',
                      style: const TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "Số lượng",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      IconButton(
                        onPressed: () {
                          if (quantity > 1) {
                            setState(() {
                              quantity--;
                            });
                          }
                        },
                        icon: const Icon(Icons.remove),
                      ),
                      Text('$quantity'), // Display current quantity
                      IconButton(
                        onPressed: () {
                          setState(() {
                            quantity++;
                          });
                        },
                        icon: const Icon(Icons.add),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                        onPressed: () async {
                          await _orderController.addToCart(
                              product['medSku'].replaceAll(RegExp(r'\s+'), ''),
                              quantity);
                          Navigator.pop(
                              context); // Close the bottom sheet after adding to cart
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Product added to cart')),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          foregroundColor: Colors.black,
                          backgroundColor: Colors.grey[300],
                        ),
                        child: const Text('Thêm vào giỏ hàng'),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PaymentPage(
                                productName: product['medName'],
                                productPrice:
                                    (product['medPrice'] as num).toDouble(),
                                buyingQuantity: quantity,
                                img: (_getImageUrl(product['medPrimaryImage'])),
                              ),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF20B6E8),
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Mua ngay'),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

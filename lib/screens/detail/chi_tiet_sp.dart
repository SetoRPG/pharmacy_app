import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';
import 'package:pharmacy_app/screens/detail/mua_ngay.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ChiTietSp extends StatefulWidget {
  final String medicineId;

  const ChiTietSp({super.key, required this.medicineId});

  @override
  _ChiTietSpState createState() => _ChiTietSpState();
}

class _ChiTietSpState extends State<ChiTietSp> {
  final MedicineController _medicineController = MedicineController();
  Map<String, dynamic>? medicineDetails;
  final PageController _pageController = PageController(); // Page controller

  @override
  void initState() {
    super.initState();
    _fetchMedicineDetails();
  }

  Future<void> _fetchMedicineDetails() async {
    final details =
        await _medicineController.getMedicineById(widget.medicineId);
    setState(() {
      medicineDetails = details;
    });
  }

  // Converts 'gs://' format to 'https://storage.googleapis.com/' format
  String _getImageUrl(String gsUrl) {
    const storageBaseUrl =
        "https://storage.googleapis.com/pharmadirect-a8570.appspot.com/";
    if (gsUrl.startsWith("gs://pharmadirect-a8570.appspot.com/")) {
      return gsUrl.replaceFirst(
          "gs://pharmadirect-a8570.appspot.com/", storageBaseUrl);
    }
    return gsUrl; // If it's already in correct format
  }

  // Helper function to get the count of images
  int _getImageCount() {
    int count = 1; // Primary image is always present
    if (medicineDetails!['medAdditionalImage1'] != null) count++;
    if (medicineDetails!['medAdditionalImage2'] != null) count++;
    if (medicineDetails!['medAdditionalImage3'] != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart, color: Colors.black),
            onPressed: () {
              _showProductBottomSheet(context);
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: medicineDetails == null
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Image Carousel with swipeable feature
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        height: 300,
                        child: Stack(
                          children: [
                            // Swipeable Image Carousel
                            PageView(
                              controller: _pageController, // Attach controller
                              children: [
                                Image.network(
                                  _getImageUrl(
                                      medicineDetails!['medPrimaryImage']),
                                  fit: BoxFit.cover,
                                ),
                                if (medicineDetails!['medAdditionalImage2'] !=
                                    null)
                                  Image.network(
                                    _getImageUrl(medicineDetails![
                                        'medAdditionalImage2']),
                                    fit: BoxFit.cover,
                                  ),
                                if (medicineDetails!['medAdditionalImage3'] !=
                                    null)
                                  Image.network(
                                    _getImageUrl(medicineDetails![
                                        'medAdditionalImage3']),
                                    fit: BoxFit.cover,
                                  ),
                                if (medicineDetails!['medAdditionalImage4'] !=
                                    null)
                                  Image.network(
                                    _getImageUrl(medicineDetails![
                                        'medAdditionalImage4']),
                                    fit: BoxFit.cover,
                                  ),
                              ],
                            ),
                            // Indicator below the PageView
                            Positioned(
                              bottom: 10,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: SmoothPageIndicator(
                                  controller:
                                      _pageController, // Attach controller
                                  count: _getImageCount(),
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
                    ),
                    // Product Title
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Text(
                        medicineDetails!['medName'] ?? 'Unknown Medicine',
                        style: const TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Brand and Price Details
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Thương hiệu: ${medicineDetails!['medManufacturer'] ?? 'Unknown'}',
                            style: const TextStyle(
                                fontSize: 16, color: Colors.blueAccent),
                          ),
                        ],
                      ),
                    ),
                    // Price and Discount
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16.0, vertical: 8.0),
                      child: Row(
                        children: [
                          Text(
                            '${medicineDetails!['medPrice'] ?? '0'} đ',
                            style: const TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.red,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Product Description Section
                    Divider(thickness: 1, color: Colors.grey[300]),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Trường hợp chỉ định',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            medicineDetails!['medIndications'] ??
                                'No description available',
                            style: const TextStyle(fontSize: 16),
                          ),
                          const SizedBox(height: 16),

                          // Button to show dialog with group information
                          Center(
                            child: TextButton(
                              onPressed: () {
                                _showDetailsDialog();
                              },
                              child: const Text('Xem thêm chi tiết'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  // Method to show the dialog
  void _showDetailsDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Thông tin chung',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medicineDetails!['medSupplementaryInfo'] ?? 'Not available',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Thành phần hoạt chất',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medicineDetails!['medActiveIngredients'] ?? 'Not available',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Tác dụng phụ',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medicineDetails!['medSideEffects'] ?? 'Not available',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Lưu ý khi sử dụng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medicineDetails!['medContraindications'] ?? 'Not available',
                    style: const TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  // Button to close the dialog
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Đóng'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showProductBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(20),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Image.asset(
                    'assets/img2.jpg',
                    height: 60,
                    width: 60,
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Nước Tẩy Trang L'OREAL Micellar Water",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "3-in-1 Refreshing Even For Sensitive Skin",
                          style: TextStyle(fontSize: 12),
                        ),
                        Text(
                          "153.430 ₫",
                          style: TextStyle(
                            color: Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "229.000 ₫",
                          style: TextStyle(
                            decoration: TextDecoration.lineThrough,
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
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text('Chai'),
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
                    onPressed: () {},
                    icon: const Icon(Icons.remove),
                  ),
                  const Text('1'),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.add),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context); // Add to cart logic
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.black,
                      backgroundColor: Colors.grey[300],
                    ),
                    child: const Text('Thêm vào giỏ'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // Chuyển đến trang thanh toán khi nhấn "Mua ngay"
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const PaymentPage(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
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
  }
}

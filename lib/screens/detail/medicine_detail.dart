// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';
import 'package:pharmacy_app/controllers/order_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_appbar.dart';
import 'package:pharmacy_app/screens/detail/instant_purchase.dart';
import 'package:pharmacy_app/screens/home/base_frame.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ChiTietSp extends StatefulWidget {
  final String medicineId;

  const ChiTietSp({super.key, required this.medicineId});

  @override
  _ChiTietSpState createState() => _ChiTietSpState();
}

class _ChiTietSpState extends State<ChiTietSp> {
  final MedicineController _medicineController = MedicineController();
  final OrderController _orderController = OrderController();
  Map<String, dynamic>? medicineDetails;
  final PageController _pageController = PageController();

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

  String _getImageUrl(String gsUrl) {
    const storageBaseUrl =
        "https://storage.googleapis.com/pharmadirect-a8570.appspot.com/";
    if (gsUrl.startsWith("gs://pharmadirect-a8570.appspot.com/")) {
      return gsUrl.replaceFirst(
          "gs://pharmadirect-a8570.appspot.com/", storageBaseUrl);
    }
    return gsUrl;
  }

  int _getImageCount() {
    int count = 1; // Primary image is always present
    if (medicineDetails!['medAdditionalImage1'] != null) count++;
    if (medicineDetails!['medAdditionalImage2'] != null) count++;
    if (medicineDetails!['medAdditionalImage3'] != null) count++;
    if (medicineDetails!['medAdditionalImage4'] != null) count++;
    return count;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'XEM THUỐC',
        logo: Icons.info,
      ),
      body: medicineDetails == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 80),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 300,
                            child: Stack(
                              children: [
                                PageView(
                                  controller: _pageController,
                                  children: [
                                    Image.network(
                                      _getImageUrl(
                                          medicineDetails!['medPrimaryImage']),
                                      fit: BoxFit.cover,
                                    ),
                                    if (medicineDetails![
                                            'medAdditionalImage1'] !=
                                        null)
                                      Image.network(
                                        _getImageUrl(medicineDetails![
                                            'medAdditionalImage1']),
                                        fit: BoxFit.cover,
                                      ),
                                    if (medicineDetails![
                                            'medAdditionalImage2'] !=
                                        null)
                                      Image.network(
                                        _getImageUrl(medicineDetails![
                                            'medAdditionalImage2']),
                                        fit: BoxFit.cover,
                                      ),
                                    if (medicineDetails![
                                            'medAdditionalImage3'] !=
                                        null)
                                      Image.network(
                                        _getImageUrl(medicineDetails![
                                            'medAdditionalImage3']),
                                        fit: BoxFit.cover,
                                      ),
                                    if (medicineDetails![
                                            'medAdditionalImage4'] !=
                                        null)
                                      Image.network(
                                        _getImageUrl(medicineDetails![
                                            'medAdditionalImage4']),
                                        fit: BoxFit.cover,
                                      ),
                                  ],
                                ),
                                Positioned(
                                  bottom: 10,
                                  left: 0,
                                  right: 0,
                                  child: Center(
                                    child: SmoothPageIndicator(
                                      controller: _pageController,
                                      count: _getImageCount(),
                                      effect: const ExpandingDotsEffect(
                                        dotColor: Colors.grey,
                                        activeDotColor: Color(0xFF20B6E8),
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
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Sản phẩm của ${medicineDetails!['medManufacturer'] ?? 'Unknown'}',
                                style: const TextStyle(
                                    fontSize: 13, color: Color(0xFF16B2A5)),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            children: [
                              Text(
                                '${medicineDetails!['medPrice'] ?? '0'} ₫',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.red,
                                ),
                              ),
                            ],
                          ),
                        ),
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
                              Center(
                                child: TextButton(
                                  onPressed: () {
                                    _showDetailsDialog();
                                  },
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.list,
                                          color: Color(0xFF757575)),
                                      SizedBox(
                                        width: 5,
                                      ),
                                      Text(
                                        'Xem thêm',
                                        style: TextStyle(
                                          color: Color(0xFF757575),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: ElevatedButton(
                      onPressed: () {
                        _showProductBottomSheet(context, medicineDetails!);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 13),
                        backgroundColor: const Color(0xFF20B6E8), //
                        foregroundColor: Colors.white,
                      ),
                      child: const Text(
                        'MUA THUỐC',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ],
            ),
    );
  }

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
                  Center(
                    child: TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: const Text('Đóng',
                          style: TextStyle(color: Colors.red)),
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

  // Updated: _showProductBottomSheet method to accept product details
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
                                content: Text('Thêm sản phẩm thành công')),
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
                                items: [
                                  {
                                    'medId': product['medSku'],
                                    'medName': product['medName'],
                                    'medPrice': product['medPrice'],
                                    'quantity': quantity,
                                  }
                                ],
                                totalPrice: product['medPrice'] * quantity,
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

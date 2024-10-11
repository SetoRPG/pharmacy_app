import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';
import 'package:pharmacy_app/controllers/order_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_appbar.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/screens/detail/medicine_detail.dart';
import 'package:pharmacy_app/screens/detail/instant_purchase.dart';
import 'package:pharmacy_app/screens/home/search_results.dart';

class CategoryScreen extends StatefulWidget {
  const CategoryScreen({super.key});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final MedicineController _medicineController = MedicineController();
  final OrderController _orderController = OrderController();
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
      appBar: CustomAppBar(title: 'DANH MỤC', logo: Icons.category),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.only(left: 10, right: 10),
              child: ListView(
                children: _buildCategoriesWithProducts(),
              ),
            ),
      backgroundColor: Colors.white,
    );
  }

  List<Widget> _buildCategoriesWithProducts() {
    Map<String, List<Map<String, dynamic>>> categorizedMedicines = {};

    for (var med in _medicines) {
      if (categorizedMedicines.containsKey(med['medCategory'])) {
        categorizedMedicines[med['medCategory']]!.add(med);
      } else {
        categorizedMedicines[med['medCategory']] = [med];
      }
    }

    List<Widget> categoryWidgets = [];
    categorizedMedicines.forEach((category, medicines) {
      categoryWidgets.add(_buildCategorySection(category, medicines));
      categoryWidgets.add(const SizedBox(height: 20));
    });

    return categoryWidgets;
  }

  Widget _buildCategorySection(
      String categoryName, List<Map<String, dynamic>> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: Text(
            categoryName,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children:
              products.map((product) => _buildProductItem(product)).toList(),
        ),
      ],
    );
  }

  Widget _buildProductItem(Map<String, dynamic> product) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading: Image.network(
          _getImageUrl(product['medPrimaryImage']),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(product['medName'] ?? 'Unknown Product Name'),
        subtitle:
            Text(product['medPackagingForm'] ?? 'No Indications Provided'),
        // Making the entire ListTile clickable by adding onTap
        onTap: () {
          String? medId = product['id']; // Use the document ID

          if (medId != null && medId.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChiTietSp(medicineId: medId),
              ),
            );
          } else {
            // Handle missing ID case
            print('Medicine ID is missing or invalid');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Unable to view details. Invalid product ID.'),
              ),
            );
          }
        },
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {
            _showProductBottomSheet(context, product);
          },
        ),
      ),
    );
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
                    // Add logic for selecting product variant
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                  child: Text(product['medCategory'] ?? 'Unknown Product'),
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
                            print(quantity);
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
                        backgroundColor: const Color(0xFF002D82),
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Mua ngay'),
                    ),
                  ],
                ),
              ],
            ),
          );
        });
      },
    );
  }
}

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
  final String initialCategory;

  const CategoryScreen({super.key, this.initialCategory = "All"});

  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  final MedicineController _medicineController = MedicineController();
  final OrderController _orderController = OrderController();
  List<Map<String, dynamic>> _medicines = [];
  List<String> _categories = ["All"];
  String _selectedCategory = "All";
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMedicines();
  }

  Future<void> _loadMedicines() async {
    final medicines = await _medicineController.getMedicines();
    final categories = _extractCategories(medicines);

    setState(() {
      _medicines = medicines;
      _categories = ["All", ...categories];
      _selectedCategory = _categories.contains(widget.initialCategory)
          ? widget.initialCategory
          : "All";
      _isLoading = false;
    });
  }

  List<String> _extractCategories(List<Map<String, dynamic>> medicines) {
    return medicines
        .map((med) => med['medCategory'] as String?)
        .where((category) => category != null)
        .toSet()
        .cast<String>()
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(title: 'DANH MỤC', logo: Icons.category),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
              color: Color(0xFF16B2A5),
            ))
          : Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              child: Column(
                children: [
                  // Dropdown button for selecting category
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Chọn danh mục:',
                        style: TextStyle(fontSize: 15),
                      ),
                      SizedBox(width: 10),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        decoration: BoxDecoration(
                            border: Border.all(),
                            borderRadius: BorderRadius.circular(10)),
                        child: DropdownButton<String>(
                          borderRadius: BorderRadius.circular(10),
                          icon: Icon(Icons.keyboard_arrow_down),
                          underline: Container(),
                          value: _selectedCategory,
                          items: _categories
                              .map((category) => DropdownMenuItem<String>(
                                    value: category,
                                    child: Text(category),
                                  ))
                              .toList(),
                          onChanged: (newValue) {
                            setState(() {
                              _selectedCategory = newValue!;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: ListView(
                      children: _buildCategoriesWithProducts(),
                    ),
                  ),
                ],
              ),
            ),
      backgroundColor: Colors.white,
    );
  }

  List<Widget> _buildCategoriesWithProducts() {
    Map<String, List<Map<String, dynamic>>> categorizedMedicines = {};

    for (var med in _medicines) {
      String category = med['medCategory'] ?? "Uncategorized";
      if (_selectedCategory != "All" && category != _selectedCategory) {
        continue;
      }
      if (categorizedMedicines.containsKey(category)) {
        categorizedMedicines[category]!.add(med);
      } else {
        categorizedMedicines[category] = [med];
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
              color: Color(0xFF16B2A5),
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
      surfaceTintColor: Colors.white,
      color: Colors.white,
      shadowColor: Colors.black,
      elevation: 4,
      child: ListTile(
        leading: Image.network(
          _getImageUrl(product['medPrimaryImage']),
          width: 50,
          height: 50,
          fit: BoxFit.cover,
        ),
        title: Text(product['medName'] ?? 'Unknown Product Name'),
        subtitle: Text(
          product['medPrice'].toString() + ' ₫' ?? 'No Price Provided',
          style: const TextStyle(
              fontSize: 18, color: Colors.red, fontWeight: FontWeight.bold),
        ),
        onTap: () {
          String? medId = product['id'];
          if (medId != null && medId.isNotEmpty) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChiTietSp(medicineId: medId),
              ),
            );
          } else {
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

  String _getImageUrl(String gsUrl) {
    const storageBaseUrl =
        "https://storage.googleapis.com/pharmadirect-a8570.appspot.com/";
    if (gsUrl.startsWith("gs://pharmadirect-a8570.appspot.com/")) {
      return gsUrl.replaceFirst(
          "gs://pharmadirect-a8570.appspot.com/", storageBaseUrl);
    }
    return gsUrl;
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
          },
        );
      },
    );
  }
}

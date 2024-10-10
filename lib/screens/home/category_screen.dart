import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';
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
              Icons.category,
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
            CustomText(text: 'DANH MỤC SẢN PHẨM', size: 20),
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
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.add_shopping_cart),
              onPressed: () {
                _showProductBottomSheet(context, product);
              },
            ),
            IconButton(
              icon: const Icon(Icons.list_alt),
              onPressed: () {
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
                      content:
                          Text('Unable to view details. Invalid product ID.'),
                    ),
                  );
                }
              },
            ),
          ],
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
                        await _addToCart(
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

  // Function to add/update product in user's Firestore basket
  Future<void> _addToCart(String medId, int quantity) async {
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      print('No user is currently logged in.');
      return;
    }

    try {
      // Query Firestore for the user with the matching email
      QuerySnapshot userSnapshot = await _firestore
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
        print('User document does not exist.');
        return;
      }

      // Get the first (and only) document returned
      DocumentSnapshot userDoc = userSnapshot.docs.first;
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;

      // Retrieve the basket field if it exists, or initialize an empty list
      List<dynamic> basket = userData['basket'] ?? [];

      // Check if the product is already in the basket
      int index = basket.indexWhere((item) => item['medId'] == medId);
      if (index >= 0) {
        // If the product is already in the basket, update the quantity
        basket[index]['quantity'] += quantity;
      } else {
        // If the product is not in the basket, add it to the basket
        basket.add({'medId': medId, 'quantity': quantity});
      }

      // Update the user's basket in Firestore
      await userDoc.reference.update({'basket': basket});
      print("Added to cart successfully.");
    } catch (e) {
      print("Error adding to cart: $e");
    }
  }
}

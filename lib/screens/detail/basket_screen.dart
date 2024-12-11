// ignore_for_file: library_private_types_in_public_api, avoid_types_as_parameter_names

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';
import 'package:pharmacy_app/controllers/order_controller.dart';
import 'package:pharmacy_app/core/widgets/custom_appbar.dart';
import 'package:pharmacy_app/screens/detail/instant_purchase.dart';
import 'package:pharmacy_app/screens/detail/medicine_detail.dart';

class BasketPage extends StatefulWidget {
  const BasketPage({super.key});

  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final OrderController _orderController = OrderController();
  final MedicineController _medicineController = MedicineController();
  final List<Map<String, dynamic>> _basketItems = [];
  final List<String> _selectedItems = [];
  final Map<String, String?> _imageCache = {};
  final formatter = NumberFormat.decimalPattern();
  bool _isLoading = true;
  double _totalPrice = 0.0;

  @override
  void initState() {
    super.initState();
    _loadBasketItems();
  }

  Future<void> _loadBasketItems() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      try {
        QuerySnapshot userSnapshot = await FirebaseFirestore.instance
            .collection('users')
            .where('email', isEqualTo: user.email)
            .get();

        if (userSnapshot.docs.isNotEmpty) {
          DocumentSnapshot userDoc = userSnapshot.docs.first;
          List<dynamic> basket = userDoc['basket'] ?? [];

          for (var item in basket) {
            Map<String, dynamic>? medicine =
                await _medicineController.getMedicineById(item['medId']);
            if (medicine != null) {
              _basketItems.add({
                'medicine': medicine,
                'quantity': item['quantity'],
              });
            }
          }

          _calculateTotalPrice();
        } else {}
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _calculateTotalPrice() {
    _totalPrice = _basketItems.fold(0.0, (sum, item) {
      // Convert price to double
      double price = (item['medicine']['medPrice'] is int)
          ? (item['medicine']['medPrice'] as int).toDouble()
          : item['medicine']['medPrice']?.toDouble() ?? 0.0;

      int quantity = item['quantity'] ?? 0;
      return sum + (price * quantity);
    });
  }

  // Update the _updateQuantity method
  void _updateQuantity(String medId, int newQuantity) async {
    if (newQuantity <= 0) {
      // Remove medicine from the basket if quantity is 0
      await _removeFromBasket(medId);
    } else {
      // Update the local quantity in the basket
      setState(() {
        var item = _basketItems
            .firstWhere((item) => item['medicine']['medSku'].trim() == medId);
        item['quantity'] = newQuantity; // Update quantity
      });
      // Update the total price after quantity change
      _calculateTotalPrice(); // Call this after updating the quantity

      // Update the basket in Firestore
      await _updateBasketInFirestore();
    }
  }

// Method to remove medicine from the basket
  Future<void> _removeFromBasket(String medId) async {
    // Find the item in the local basket
    var itemIndex = _basketItems
        .indexWhere((item) => item['medicine']['medSku'].trim() == medId);
    if (itemIndex != -1) {
      // Remove the item from the local list
      setState(() {
        _basketItems.removeAt(itemIndex);
      });

      // Recalculate total price after removing an item
      _calculateTotalPrice();
    }

    // Update the user's basket in Firestore
    await _updateBasketInFirestore();
  }

// Method to update the entire basket in Firestore
  Future<void> _updateBasketInFirestore() async {
    final userEmail = FirebaseAuth
        .instance.currentUser?.email; // Get the current user's email
    if (userEmail != null) {
      // Query the user's document in Firestore to update the basket
      QuerySnapshot userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .where('email', isEqualTo: userEmail)
          .get();

      if (userSnapshot.docs.isNotEmpty) {
        String userId = userSnapshot.docs.first.id; // Get the user document ID
        await FirebaseFirestore.instance
            .collection('users')
            .doc(userId)
            .update({
          'basket': _basketItems
              .map((item) => {
                    'medId': item['medicine']['medSku'].trim(),
                    'quantity': item['quantity']
                  })
              .toList(),
        });
      }
    }
  }

  // Call this when the user presses "XÁC NHẬN MUA"
  void _confirmPurchase() async {
    if (_basketItems.isEmpty) {
      // Show snackbar if the basket is empty
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Giỏ hàng của bạn đang trống!'),
          duration: Duration(seconds: 2),
        ),
      );
      return; // Exit the function
    }

    List<Map<String, dynamic>> orderItems = _basketItems.map((item) {
      if (item['medicine']['medPrice'] != null) {}

      return {
        'medId': item['medicine']['medSku'],
        'medName': item['medicine']['medName'],
        'medPrice': item['medicine']['medPrice'],
        'quantity': item['quantity'],
      };
    }).toList();

    // Navigate to PaymentPage with basket items
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          items: orderItems,
          totalPrice: _totalPrice,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'GIỎ HÀNG',
        logo: Icons.shopping_cart,
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF16B2A5)))
          : _basketItems.isEmpty
              ? const Center(child: Text('Bạn chưa thêm gì vào giỏ hàng!'))
              : Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8.0, vertical: 20),
                  child: ListView.builder(
                    itemCount: _basketItems.length,
                    itemBuilder: (context, index) {
                      var item = _basketItems[index];
                      var medicine = item['medicine'];
                      int quantity = item['quantity'];

                      String medId = (medicine['medSku']
                              ?.toString()
                              .replaceAll(RegExp(r'\s+'), '') ??
                          '');

                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      ChiTietSp(medicineId: medId)));
                        },
                        onLongPress: () {
                          setState(() {
                            _selectedItems.add(medId);
                          });
                        },
                        child: Card(
                          color: Colors.white,
                          surfaceTintColor: Colors.white,
                          shadowColor: Colors.black,
                          elevation: 4,
                          margin: const EdgeInsets.symmetric(
                              vertical: 8.0, horizontal: 16.0),
                          child: Padding(
                            padding: const EdgeInsets.all(10.0),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                // Checkbox at the beginning
                                Checkbox(
                                  activeColor: const Color(0xFF16B2A5),
                                  checkColor: Colors.white,
                                  value: _selectedItems.contains(medId),
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value == true) {
                                        _selectedItems.add(medId);
                                      } else {
                                        _selectedItems.remove(medId);
                                      }
                                    });
                                  },
                                ),
                                const SizedBox(width: 8),
                                // Column containing medicine details and controls
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Medicine details with image
                                      Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        children: [
                                          FutureBuilder<String>(
                                            future: _getCachedImage(medId),
                                            builder: (context, snapshot) {
                                              if (snapshot.hasError) {
                                                return const SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child: Icon(
                                                    Icons.image_not_supported,
                                                  ),
                                                );
                                              } else if (snapshot.hasData) {
                                                return ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  child: Image.network(
                                                    snapshot.data!,
                                                    width: 50,
                                                    height: 50,
                                                    fit: BoxFit.cover,
                                                  ),
                                                );
                                              } else {
                                                return const SizedBox(
                                                  width: 50,
                                                  height: 50,
                                                  child:
                                                      CircularProgressIndicator(
                                                          color: Color(
                                                              0xFF16B2A5)),
                                                );
                                              }
                                            },
                                          ),
                                          const SizedBox(width: 12),
                                          Expanded(
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  medicine['medName'],
                                                  style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 16,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  '${formatter.format(medicine['medPrice'])} ₫',
                                                  style: const TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.red,
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      // Quantity controls
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          const Text(
                                            'Số lượng:',
                                            style: TextStyle(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w500),
                                          ),
                                          Row(
                                            children: [
                                              IconButton(
                                                icon: const Icon(Icons.remove),
                                                onPressed: () {
                                                  if (quantity > 1) {
                                                    _updateQuantity(
                                                        medId, quantity - 1);
                                                  }
                                                },
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 8.0),
                                                child: Text(
                                                  quantity.toString(),
                                                  style: const TextStyle(
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                icon: const Icon(Icons.add),
                                                onPressed: () {
                                                  if (quantity <
                                                      medicine[
                                                          'medStockQuantity']) {
                                                    _updateQuantity(
                                                        medId, quantity + 1);
                                                  } else {
                                                    ScaffoldMessenger.of(
                                                            context)
                                                        .showSnackBar(
                                                      const SnackBar(
                                                        content: Text(
                                                            'Vượt quá số lượng tồn kho'),
                                                      ),
                                                    );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _selectedItems.isNotEmpty
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // "Xóa sản phẩm" button
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red),
                            onPressed: () async {
                              bool confirmDelete = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: const Text('Xác nhận xóa'),
                                        content: const Text(
                                            'Bạn có chắc chắn muốn xóa các mục đã chọn không?'),
                                        actions: [
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context)
                                                    .pop(false),
                                            child: const Text(
                                              'Hủy',
                                              style: TextStyle(
                                                  color: Color.fromRGBO(
                                                      117, 117, 117, 1)),
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () =>
                                                Navigator.of(context).pop(true),
                                            child: const Text(
                                              'Xóa',
                                              style:
                                                  TextStyle(color: Colors.red),
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ) ??
                                  false;
                              if (confirmDelete) {
                                setState(() {
                                  for (var medId in _selectedItems) {
                                    _removeFromBasket(medId);
                                  }
                                  _selectedItems.clear();
                                });
                              }
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Xóa sản phẩm',
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(width: 5),
                                Icon(Icons.delete, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8), // Spacer between buttons

                        // "Mua sản phẩm" button
                        Expanded(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF20B6E8),
                            ),
                            onPressed: () {
                              _purchaseSelectedItems();
                            },
                            child: const Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text('Mua sản phẩm',
                                    style: TextStyle(color: Colors.white)),
                                SizedBox(width: 5),
                                Icon(Icons.shopping_cart, color: Colors.white),
                              ],
                            ),
                          ),
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('Tổng giá:'),
                            const SizedBox(width: 5),
                            Text(
                              '${formatter.format(_totalPrice)} ₫',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            foregroundColor: Colors.white,
                            backgroundColor: const Color(0xFF20B6E8),
                          ),
                          onPressed: () {
                            _confirmPurchase();
                          },
                          child: const Text('XÁC NHẬN MUA'),
                        ),
                      ],
                    ),
            ],
          ),
        ),
      ),
    );
  }

  void _purchaseSelectedItems() {
    if (_selectedItems.isEmpty) return;

    // Collect selected items for purchase
    List<Map<String, dynamic>> selectedOrderItems = _basketItems
        .where((item) => _selectedItems.contains(item['medicine']['medSku']))
        .map((item) {
      return {
        'medId': item['medicine']['medSku'],
        'medName': item['medicine']['medName'],
        'medPrice': item['medicine']['medPrice'],
        'quantity': item['quantity'],
      };
    }).toList();

    double selectedTotalPrice = selectedOrderItems.fold(0.0, (sum, item) {
      double price = (item['medPrice'] is int)
          ? (item['medPrice'] as int).toDouble()
          : item['medPrice']?.toDouble() ?? 0.0;
      int quantity = item['quantity'] ?? 0;
      return sum + (price * quantity);
    });

    // Navigate to the PaymentPage with selected items
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          items: selectedOrderItems,
          totalPrice: selectedTotalPrice,
        ),
      ),
    );
  }

  Future<String> _getCachedImage(String medId) async {
    if (_imageCache.containsKey(medId)) {
      return _imageCache[medId]!;
    }

    String imageUrl = await _orderController.getMedicinePicture(medId);
    setState(() {
      _imageCache[medId] = imageUrl;
    });
    return imageUrl;
  }
}

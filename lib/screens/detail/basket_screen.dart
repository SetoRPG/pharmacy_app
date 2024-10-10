import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';
import 'package:pharmacy_app/controllers/order_controller.dart';

class BasketPage extends StatefulWidget {
  @override
  _BasketPageState createState() => _BasketPageState();
}

class _BasketPageState extends State<BasketPage> {
  final MedicineController _medicineController = MedicineController();
  List<Map<String, dynamic>> _basketItems = [];
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
        } else {
          print('User document not found.');
        }
      } catch (e) {
        print("Error loading basket items: $e");
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
    List<Map<String, dynamic>> orderItems = [];

    for (var item in _basketItems) {
      String productName = item['medicine']['medName'];
      double productPrice = (item['medicine']['medPrice'] is int)
          ? (item['medicine']['medPrice'] as int).toDouble()
          : item['medicine']['medPrice'] as double;
      int quantity = item['quantity'];

      orderItems.add({
        'productName': productName,
        'price': productPrice,
        'quantity': quantity,
      });
    }

    OrderController _orderController = new OrderController();

    try {
      await _orderController.createOrderWithMultipleItems(
        items: orderItems,
        paymentMethod: 'YourPaymentMethod', // Set your payment method
        note: 'Optional note here', // Optional note
      );

      // Optionally navigate to another page or show success message
    } catch (e) {
      // Handle any errors
      print("Error confirming purchase: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('GIỎ HÀNG CỦA BẠN'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _basketItems.isEmpty
              ? Center(child: Text('Bạn chưa thêm gì vào giỏ hàng!'))
              : ListView.builder(
                  itemCount: _basketItems.length,
                  itemBuilder: (context, index) {
                    var item = _basketItems[index];
                    var medicine = item['medicine'];
                    int quantity = item['quantity'];

                    // Safely getting the medSku and removing spaces
                    String medId = (medicine['medSku']
                            ?.toString()
                            .replaceAll(RegExp(r'\s+'), '') ??
                        '');

                    return Card(
                      child: ListTile(
                        title: Text(medicine['medName']),
                        subtitle: Text('Giá: ${medicine['medPrice']} VND'),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                if (quantity >= 1) {
                                  _updateQuantity(medId, quantity - 1);
                                }
                              },
                            ),
                            // Display the quantity here
                            Text(quantity.toString(),
                                style: TextStyle(fontSize: 16)),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                _updateQuantity(medId, quantity + 1);
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
      bottomNavigationBar: BottomAppBar(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Tổng giá: $_totalPrice VND'),
              ElevatedButton(
                onPressed: () {
                  _confirmPurchase();
                },
                child: Text('XÁC NHẬN MUA'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

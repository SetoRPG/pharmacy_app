import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Custom ID generator
  String _generateCustomId() {
    final now = DateTime.now();
    String datePart =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    String randomPart = (Random().nextInt(90) + 10)
        .toString(); // Generates a number between 10 and 99
    return "ORD$datePart$randomPart";
  }

  // Function to create an order
  Future<void> createOrder({
    required String productName,
    required double productPrice,
    required int quantity,
    required double totalPrice,
    required String paymentMethod,
    String? note,
  }) async {
    try {
      // Get the current user
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("No user is logged in.");
      }

      // Query Firestore to find the user document with the matching email
      QuerySnapshot userDocs = await _firestore
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (userDocs.docs.isEmpty) {
        throw Exception("User document not found.");
      }

      // Assuming there is only one document for the user
      String userId =
          userDocs.docs.first['id']; // Get the custom user ID from Firestore

      // Order details
      String orderId = _generateCustomId();
      Map<String, dynamic> orderData = {
        'orderId': orderId,
        'userId': userId, // Use the custom user ID
        'userEmail': user.email,
        'dateCreated': DateTime.now(),
        'totalPrice': totalPrice,
        'paymentMethod': paymentMethod,
        'note': note ?? '',
        'items': [
          {
            'productName': productName,
            'quantity': quantity,
            'price': productPrice,
          },
        ],
        'status': 1,
      };

      // Add order to Firestore
      await _firestore.collection('orders').doc(orderId).set(orderData);

      print("Order successfully created with ID: $orderId");
    } catch (e) {
      print("Failed to create order: $e");
      throw e;
    }
  }

  // Function to get all orders for the current user based on email
  Future<List<Map<String, dynamic>>> getOrdersForCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("No user is logged in.");
      }

      // Fetch orders where userEmail matches the current user's email
      QuerySnapshot orderDocs = await _firestore
          .collection('orders')
          .where('userEmail', isEqualTo: user.email)
          .get();

      // Convert the query results to a List of Map
      return orderDocs.docs.map((doc) {
        // Assuming 'status' is stored as a number, convert it to a string
        String statusText = doc['status'] == 1
            ? 'Đang xử lý'
            : 'Hoàn thành'; // Adjust based on your status codes

        // Calculate total price if needed; else you can directly use doc['totalPrice']
        double totalPrice = doc['totalPrice'] ?? 0.0; // Default to 0.0 if null

        return {
          'orderId': doc['orderId'],
          'status': statusText,
          'total': totalPrice.toStringAsFixed(2) +
              'đ', // Format price to 2 decimal places with currency
          'items': doc['items'] as List<
              dynamic>, // This will give you access to the items array if needed
        };
      }).toList();
    } catch (e) {
      print("Failed to get orders: $e");
      throw e;
    }
  }

  // Function to create an order with multiple items
  Future<void> createOrderWithMultipleItems({
    required List<Map<String, dynamic>> items, // List of items to order
    required String paymentMethod,
    String? note,
  }) async {
    try {
      // Get the current user
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("No user is logged in.");
      }

      // Query Firestore to find the user document with the matching email
      QuerySnapshot userDocs = await _firestore
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (userDocs.docs.isEmpty) {
        throw Exception("User document not found.");
      }

      // Assuming there is only one document for the user
      String userId =
          userDocs.docs.first['id']; // Get the custom user ID from Firestore

      // Order details
      String orderId = _generateCustomId();
      double totalPrice = 0.0; // Initialize total price

      // Prepare the items for the order and calculate total price
      List<Map<String, dynamic>> orderItems = [];
      for (var item in items) {
        String productName = item['productName'];
        double productPrice = (item['price'] is int)
            ? (item['price'] as int).toDouble()
            : item['price'] as double;
        int quantity = item['quantity'];

        orderItems.add({
          'productName': productName,
          'quantity': quantity,
          'price': productPrice,
        });

        totalPrice += productPrice * quantity; // Update total price
      }

      Map<String, dynamic> orderData = {
        'orderId': orderId,
        'userId': userId,
        'userEmail': user.email,
        'dateCreated': DateTime.now(),
        'totalPrice': totalPrice,
        'paymentMethod': paymentMethod,
        'note': note ?? '',
        'items': orderItems,
        'status': 1, // Set initial status
      };

      // Add order to Firestore
      await _firestore.collection('orders').doc(orderId).set(orderData);

      print("Order successfully created with ID: $orderId");
    } catch (e) {
      print("Failed to create order: $e");
      throw e;
    }
  }

  // Function to add/update product in user's Firestore basket
  Future<void> addToCart(String medId, int quantity) async {
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

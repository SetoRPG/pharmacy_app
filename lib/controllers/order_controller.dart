// ignore_for_file: empty_catches

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class OrderController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String _getImageUrl(String gsUrl) {
    const storageBaseUrl =
        "https://storage.googleapis.com/pharmadirect-a8570.appspot.com/";
    if (gsUrl.startsWith("gs://pharmadirect-a8570.appspot.com/")) {
      return gsUrl.replaceFirst(
          "gs://pharmadirect-a8570.appspot.com/", storageBaseUrl);
    }
    return gsUrl;
  }

  Future<String> getMedicinePicture(String id) async {
    QuerySnapshot medDocs = await _firestore
        .collection('medicines')
        .where('medSku', isEqualTo: id)
        .get();

    String medImg = medDocs.docs.first['medPrimaryImage'];

    return _getImageUrl(medImg);
  }

  // Custom ID generator
  String _generateCustomId() {
    final now = DateTime.now();
    String datePart =
        "${now.year}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}";
    String randomPart = (Random().nextInt(90) + 10)
        .toString(); // Generates a number between 10 and 99
    return "ORD$datePart$randomPart";
  }

  // Function to get all orders for the current user based on email
  Future<List<Map<String, dynamic>>> getOrdersForCurrentUser() async {
    try {
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("No user is logged in.");
      }

      // Step 1: Fetch the current user's data from the 'users' collection to get the userId
      QuerySnapshot userDocs = await _firestore
          .collection('users')
          .where('email', isEqualTo: user.email)
          .get();

      if (userDocs.docs.isEmpty) {
        throw Exception("User not found in 'users' collection.");
      }

      // Get the userId from the first document (assuming userEmail is unique)
      String userId = userDocs.docs.first['id'];

      // Step 2: Fetch orders from 'orders' collection where customer field matches the userId
      QuerySnapshot orderDocs = await _firestore
          .collection('orders')
          .where('customer', isEqualTo: userId)
          .get();

      // Step 3: Convert the query results to a List of Map with all required fields
      return orderDocs.docs.map((doc) {
        // Define status text based on status code
        String statusText = '';
        switch (doc['orderStatus']) {
          case 'PENDING':
            statusText = 'Đang Chờ Xử Lý'; // Pending
            break;
          case 'CONFIRMED':
            statusText = 'Đã Xác Nhận'; // Confirmed
            break;
          case 'SHIPPED':
            statusText = 'Đang Giao'; // Shipped
            break;
          case 'CANCELLED':
            statusText = 'Đã Hủy'; // Cancelled
            break;
          case 'COMPLETED':
            statusText = 'Đã Giao Hàng'; // Completed
            break;
          default:
            statusText = 'Trạng Thái Không Xác Định'; // Undefined status
            break;
        }

        // Extract items array and ensure each item is a map with required fields
        List<Map<String, dynamic>> items =
            (doc['orderItemList'] as List<dynamic>)
                .map((item) => {
                      'productId': item['productId'] ?? '',
                      'productName': item['productName'] ?? '',
                      'price': item['price'] ?? 0,
                      'quantity': item['quantity'] ?? 0,
                    })
                .toList();
        // Return the order data in the updated structure
        return {
          'location': doc['deliveryLocation'] ?? '',
          'note':
              doc['orderNote'] ?? '', // Assuming 'orderNote' is the new field
          'orderId': doc['orderId'] ?? '',
          'status': statusText,
          'total': doc['totalAmount']
              .toStringAsFixed(2), // Assuming 'totalAmount' is the new field
          'paymentStatus': doc['paymentStatus'] ?? '',
          'customer': doc['customer'] ?? '',
          'orderDate': (doc['orderDate'] as Timestamp).toDate(),
          'items': items, // List of items with detailed product info
        };
      }).toList();
    } catch (e) {
      rethrow;
    }
  }

  // Function to create an order with multiple items
  Future<void> createOrderWithMultipleItems({
    required List<Map<String, dynamic>> items, // List of items to order
    String? note,
    String? location,
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
        // Handle multiple possible keys for item properties
        String productName =
            item['medName'] ?? item['productName'] ?? 'Unknown Product';
        String productId = item['medId'] ?? item['productId'] ?? '';
        double productPrice =
            double.tryParse('${item['medPrice'] ?? item['price']}') ?? 0.0;
        int quantity = item['quantity'] ?? 0;

        orderItems.add({
          'productId': productId,
          'productName': productName,
          'quantity': quantity,
          'price': productPrice,
        });

        totalPrice += productPrice * quantity; // Update total price
      }

      Map<String, dynamic> orderData = {
        'orderId': orderId,
        'customer': userId,
        'deliveryLocation': location,
        'orderDate': DateTime.now(),
        'orderItemList': orderItems,
        'totalAmount': totalPrice,
        'orderNote': note ?? '',
        'orderStatus': 'PENDING', // Set initial order status
        'paymentStatus': 'UNPAID', // Set initial payment status
        'processBy': [], // Example processing steps
      };

      // Add order to Firestore
      await _firestore.collection('orders').doc(orderId).set(orderData);
    } catch (e) {
      rethrow;
    }
  }

  // Function to add/update product in user's Firestore basket
  Future<void> addToCart(String medId, int quantity) async {
    final FirebaseFirestore firestore = FirebaseFirestore.instance;
    final User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser == null) {
      return;
    }

    try {
      // Query Firestore for the user with the matching email
      QuerySnapshot userSnapshot = await firestore
          .collection('users')
          .where('email', isEqualTo: currentUser.email)
          .limit(1)
          .get();

      if (userSnapshot.docs.isEmpty) {
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
    } catch (e) {}
  }

// Delete order by ID
  Future<void> deleteOrder(String orderId) async {
    try {
      // Check if the current user is authenticated
      User? user = _auth.currentUser;
      if (user == null) {
        throw Exception("No user is logged in.");
      }

      // Delete the order document from Firestore
      await _firestore.collection('orders').doc(orderId).delete();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateOrderStatus(String orderId, String newStatus) async {
    try {
      await _firestore
          .collection('orders')
          .doc(orderId)
          .update({'orderStatus': newStatus});
    } catch (e) {
      rethrow;
    }
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pharmacy_app/core/widgets/custom_text_1.dart';
import 'package:pharmacy_app/screens/detail/instant_purchase.dart';
import 'package:pharmacy_app/screens/detail/medicine_detail.dart';

class FavoriteProductsScreen extends StatefulWidget {
  const FavoriteProductsScreen({super.key});

  @override
  _FavoriteProductsScreenState createState() => _FavoriteProductsScreenState();
}

class _FavoriteProductsScreenState extends State<FavoriteProductsScreen> {
  List<Map<String, dynamic>> _favoriteProducts = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteProducts();
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

  Future<void> _loadFavoriteProducts() async {
    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      FirebaseFirestore firestore = FirebaseFirestore.instance;
      User? user = auth.currentUser;

      if (user == null) {
        throw Exception("Người dùng chưa đăng nhập.");
      }

      String userEmail = user.email ?? "";
      QuerySnapshot snapshot = await firestore
          .collection("users")
          .where("email", isEqualTo: userEmail)
          .get();

      debugPrint("Number of user documents found: ${snapshot.docs.length}");
      if (snapshot.docs.isEmpty) {
        throw Exception("Không tìm thấy người dùng.");
      }

      QueryDocumentSnapshot userDoc = snapshot.docs.first;
      List<dynamic> favoriteIds = userDoc.get('favoriteList') ?? [];

      if (favoriteIds.isNotEmpty) {
        QuerySnapshot productSnapshot = await firestore
            .collection('medicines')
            .where(FieldPath.documentId, whereIn: favoriteIds)
            .get();

        setState(() {
          _favoriteProducts = productSnapshot.docs
              .map((doc) =>
                  {'id': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();
          _isLoading = false;
        });
      } else {
        setState(() {
          _favoriteProducts = [];
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Lỗi khi tải sản phẩm yêu thích: $e'),
      ));
    }
  }

  void _rePurchaseProduct(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PaymentPage(
          items: [product],
          totalPrice: product['price']?.toDouble() ?? 0.0,
        ),
      ),
    );
  }

  void _viewProductDetail(Map<String, dynamic> product) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChiTietSp(medicineId: product['id']),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 10,
        shadowColor: Colors.black,
        title: const CustomText(text: 'SẢN PHẨM ĐÃ YÊU THÍCH', size: 20),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF20B6E8), Color(0xFF16B2A5)],
            ),
          ),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFF16B2A5)),
            )
          : _favoriteProducts.isEmpty
              ? const Center(
                  child: Text(
                    'Không có sản phẩm yêu thích.',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: _favoriteProducts.length,
                  itemBuilder: (context, index) {
                    final product = _favoriteProducts[index];
                    return _buildFavoriteCard(product);
                  },
                ),
    );
  }

  Widget _buildFavoriteCard(Map<String, dynamic> product) {
    return Card(
      surfaceTintColor: Colors.transparent,
      shadowColor: Colors.black,
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: GestureDetector(
        onTap: () =>
            _viewProductDetail(product), // Navigate to detail page on tap
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Image on the left side
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  _getImageUrl(product['medPrimaryImage']),
                  height: 60,
                  width: 60,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['medName'] ?? 'Unknown Product',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                      overflow: TextOverflow.clip,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Giá: ${product['medPrice'].toStringAsFixed(0)} đ',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Row(
                      children: [
                        Icon(Icons.favorite, color: Colors.pink, size: 16),
                        SizedBox(width: 4),
                        Text(
                          'Yêu thích',
                          style: TextStyle(color: Colors.pink, fontSize: 14),
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
  }
}

import 'package:flutter/material.dart';
import 'package:pharmacy_app/screens/detail/xem_chi_tiet_sp.dart';

class ChiTietSp extends StatelessWidget {
  const ChiTietSp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.black),
            onPressed: () {},
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image Carousel
            Container(
              height: 300,
              child: PageView(
                children: [
                  Image.asset('assets/img2.jpg'),
                ],
              ),
            ),
            // Product Title
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Nước Súc Miệng LISTERINE Cool Mint Hơi Thở Thơm Mát (Chai 750ml)',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Brand and Price Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Thương hiệu: Listerine',
                    style: TextStyle(fontSize: 16, color: Colors.blueAccent),
                  ),
                  Text(
                    'P27816',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            ),
            // Price and Discount
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                children: [
                  Text(
                    '476.000 đ',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                  SizedBox(width: 8),
                  Text(
                    '560.000 đ',
                    style: TextStyle(
                      fontSize: 18,
                      decoration: TextDecoration.lineThrough,
                      color: Colors.grey,
                    ),
                  ),
                  SizedBox(width: 8),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '-15%',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            // Loyalty Points (Removed empty padding block)
            // Product Description Section
            Divider(thickness: 1, color: Colors.grey[300]),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Mô tả sản phẩm',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      // Handle the button press here
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => XemChiTietSp(),
                        ),
                      );
                    },
                    child: Text(
                      'Xem chi tiết',
                      style: TextStyle(color: Colors.blue, fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Danh mục',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('Nước súc miệng', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text(
                    'Công dụng',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold), 
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Nước súc miệng giúp làm sạch và làm thơm răng, miệng.',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 16),
                  Text(
                    'Nhà sản xuất',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('Johnson & Johnson', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text(
                    'Quy cách',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text('Chai 750ml', style: TextStyle(fontSize: 16)),
                  SizedBox(height: 16),
                  Text(
                    'Lưu ý',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Mọi thông tin trên đây chỉ mang tính chất tham khảo. Đọc kỹ hướng dẫn sử dụng trước khi dùng.',
                    style: TextStyle(fontSize: 16),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Similar Brand Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Chống nắng nâng tông',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      // Implement 'Xem thêm' (View more) functionality here
                    },
                    child: Text(
                      'Xem thêm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Horizontal List of Products
            Container(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildProductCard(
                    'Tinh Chất Chống Nắng SUNPLAY', 
                    'assets/img2.jpg', 
                    '169.150 đ'
                  ),
                  buildProductCard(
                    'Gel chống nắng Sunplay Skin Aqua', 
                    'assets/img2.jpg', 
                    '125.000 đ'
                  ),
                   buildProductCard(
                    'Gel chống nắng Sunplay Skin Aqua', 
                    'assets/img2.jpg', 
                    '125.000 đ'
                  ),
                   buildProductCard(
                    'Gel chống nắng Sunplay Skin Aqua', 
                    'assets/img2.jpg', 
                    '125.000 đ'
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Similar Brand Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sản phẩm cùng thương hiệu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: Text(
                      'Xem thêm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildProductCard(
                    'La Roche-Posay Effaclar', 
                    'assets/img2.jpg', 
                    '200.000 đ'
                    
                  ),
                  buildProductCard(
                    'La Roche-Posay Gel', 
                    'assets/img2.jpg', 
                    '150.000 đ'
                   
                  ),
                  buildProductCard(
                    'La Roche-Posay Gel', 
                    'assets/img2.jpg', 
                    '150.000 đ'
                   
                  ),
                  buildProductCard(
                    'La Roche-Posay Gel', 
                    'assets/img2.jpg', 
                    '150.000 đ'
                   
                  ),
                ],
              ),
            ),
SizedBox(height: 16),

            // Horizontal List of Products
            Container(
              height: 250,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildProductCard(
                    'Tinh Chất Chống Nắng SUNPLAY', 
                    'assets/img2.jpg', 
                    '169.150 đ'
                  ),
                  buildProductCard(
                    'Gel chống nắng Sunplay Skin Aqua', 
                    'assets/img2.jpg', 
                    '125.000 đ'
                  ),
                   buildProductCard(
                    'Gel chống nắng Sunplay Skin Aqua', 
                    'assets/img2.jpg', 
                    '125.000 đ'
                  ),
                   buildProductCard(
                    'Gel chống nắng Sunplay Skin Aqua', 
                    'assets/img2.jpg', 
                    '125.000 đ'
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            // Similar Brand Section
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Sản phẩm cùng thương hiệu',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      
                    },
                    child: Text(
                      'Xem thêm',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),

            Container(
              height: 200,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  buildProductCard(
                    'La Roche-Posay Effaclar', 
                    'assets/img2.jpg', 
                    '200.000 đ'
                    
                  ),
                  buildProductCard(
                    'La Roche-Posay Gel', 
                    'assets/img2.jpg', 
                    '150.000 đ'
                   
                  ),
                  buildProductCard(
                    'La Roche-Posay Gel', 
                    'assets/img2.jpg', 
                    '150.000 đ'
                   
                  ),
                  buildProductCard(
                    'La Roche-Posay Gel', 
                    'assets/img2.jpg', 
                    '150.000 đ'
                   
                  ),
                ],
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      side: BorderSide(color: Colors.blue),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text(
                      'Thêm vào giỏ',
                      style: TextStyle(color: Colors.blue),
                    ),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Implement buy now functionality here
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Mua ngay'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Helper method to build product cards
  Widget buildProductCard(
    String title, 
    String imagePath, 
    String price, 

  ) {
    return Container(
      width: 150,
      margin: EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(imagePath, height: 100, fit: BoxFit.cover),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 4),
          Text(
            price,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

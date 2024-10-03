import 'package:flutter/material.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh Mục Sản Phẩm'),
        centerTitle: true,
        backgroundColor: const Color(0xFF20B6E8),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView(
          children: [
            _buildCategorySection('Thuốc giảm đau', [
              _buildProductItem('Paracetamol', 'Thuốc giảm đau và hạ sốt',
                  'assets/paracetamol.jpg'),
              _buildProductItem(
                  'Ibuprofen', 'Giảm viêm và đau', 'assets/ibuprofen.jpg'),
            ]),
            const SizedBox(height: 20),
            _buildCategorySection('Vitamin & Thực phẩm chức năng', [
              _buildProductItem(
                  'Vitamin C', 'Tăng cường miễn dịch', 'assets/vitamin_c.jpg'),
              _buildProductItem(
                  'Omega-3', 'Tốt cho tim mạch', 'assets/omega3.jpg'),
            ]),
            const SizedBox(height: 20),
            _buildCategorySection('Dụng cụ y tế', [
              _buildProductItem(
                  'Băng cá nhân', 'Bảo vệ vết thương', 'assets/bandage.jpg'),
              _buildProductItem(
                  'Nhiệt kế', 'Đo nhiệt độ cơ thể', 'assets/thermometer.jpg'),
            ]),
          ],
        ),
      ),
      backgroundColor: Colors.white,
    );
  }

  Widget _buildCategorySection(String categoryName, List<Widget> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          categoryName,
          style: const TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 10),
        Column(
          children: products,
        ),
      ],
    );
  }

  Widget _buildProductItem(
      String productName, String productDescription, String imagePath) {
    return Card(
      elevation: 3,
      child: ListTile(
        leading:
            Image.asset(imagePath, width: 50, height: 50, fit: BoxFit.cover),
        title: Text(productName),
        subtitle: Text(productDescription),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {
            // Implement product adding logic here
          },
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';

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
        title: const Text('Danh Mục Sản Phẩm'),
        centerTitle: true,
        backgroundColor: const Color(0xFF20B6E8),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
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
        title: Text(product['medName']),
        subtitle: Text(product['medIndications']),
        trailing: IconButton(
          icon: const Icon(Icons.add_shopping_cart),
          onPressed: () {
            // Implement product adding logic here
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
}

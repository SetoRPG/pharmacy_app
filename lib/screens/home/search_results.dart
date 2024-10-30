import 'package:flutter/material.dart';
import 'package:pharmacy_app/controllers/medicine_controller.dart';
import 'package:pharmacy_app/screens/detail/medicine_detail.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage> {
  final MedicineController _medicineController = MedicineController();
  List<Map<String, dynamic>> _allMedicines = [];
  List<Map<String, dynamic>> _filteredMedicines = [];
  bool _isLoading = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAllMedicines();
    _searchController.addListener(_filterMedicines);
  }

  Future<void> _loadAllMedicines() async {
    final medicines = await _medicineController.getMedicines();
    setState(() {
      _allMedicines = medicines;
      _filteredMedicines = medicines;
      _isLoading = false;
    });
  }

  void _filterMedicines() {
    String query = _searchController.text.toLowerCase();
    setState(() {
      _filteredMedicines = _allMedicines.where((medicine) {
        final name = medicine['medName'].toString().toLowerCase();
        final indications = medicine['medIndications'].toString().toLowerCase();
        return name.contains(query) || indications.contains(query);
      }).toList();
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
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: TextField(
          style: const TextStyle(color: Colors.white),
          controller: _searchController,
          cursorColor: Colors.white,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Tìm kiếm thuốc...',
            border: InputBorder.none,
          ),
        ),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _filteredMedicines.isEmpty
              ? const Center(child: Text('Không tìm thấy kết quả.'))
              : Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: ListView.builder(
                    itemCount: _filteredMedicines.length,
                    itemBuilder: (context, index) {
                      final medicine = _filteredMedicines[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ChiTietSp(medicineId: medicine['id']),
                            ),
                          );
                        },
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 5,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Medicine Image
                              Container(
                                width: 60,
                                height: 60,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(8),
                                  image: DecorationImage(
                                    image: NetworkImage(_getImageUrl(
                                        medicine['medPrimaryImage'])),
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 16),
                              // Medicine Name
                              Expanded(
                                child: Text(
                                  medicine['medName'],
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
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

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }
}

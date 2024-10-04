import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Fetch medicines from Firestore
  Future<List<Map<String, dynamic>>> getMedicines() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('medicines').get();
      return snapshot.docs
          .map((doc) => doc.data() as Map<String, dynamic>)
          .toList();
    } catch (e) {
      print("Error fetching medicines: $e");
      return [];
    }
  }
}

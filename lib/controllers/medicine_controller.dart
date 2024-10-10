import 'package:cloud_firestore/cloud_firestore.dart';

class MedicineController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Fetch medicines from Firestore
  Future<List<Map<String, dynamic>>> getMedicines() async {
    try {
      QuerySnapshot snapshot = await _firestore.collection('medicines').get();
      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        data['id'] = doc.id; // Add the document ID to the map
        return data;
      }).toList();
    } catch (e) {
      print("Error fetching medicines: $e");
      return [];
    }
  }

  // Fetch medicine by ID from Firestore
  Future<Map<String, dynamic>?> getMedicineById(String id) async {
    try {
      DocumentSnapshot doc =
          await _firestore.collection('medicines').doc(id).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      } else {
        print("No medicine found for the given ID");
        return null;
      }
    } catch (e) {
      print("Error fetching medicine by ID: $e");
      return null;
    }
  }
}

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
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  Future<double> getMedicineDiscount(String medicineId) async {
    final firestore = FirebaseFirestore.instance;
    double highestDiscount = 0.0;

    try {
      // Step 1: Get the medicine price from the medicines collection
      final medicineDoc =
          await firestore.collection('medicines').doc(medicineId).get();

      if (!medicineDoc.exists) {
        // Medicine not found
        return 0;
      }

      final medPrice =
          medicineDoc.data()?['medOriginalPrice'] as double? ?? 0.0;

      // Step 2: Check each document in the promotions collection
      final promotionsSnapshot = await firestore.collection('promotions').get();
      final now = DateTime.now();

      for (var promoDoc in promotionsSnapshot.docs) {
        final promoData = promoDoc.data();

        final List<dynamic> promoMedicines = promoData['medicines'] ?? [];
        if (!promoMedicines.contains(medicineId)) {
          // If the medicine is not in the current promotion, skip
          continue;
        }

        final Timestamp startTimestamp = promoData['startDate'];
        final Timestamp endTimestamp = promoData['endDate'];

        final startDate = startTimestamp.toDate();
        final endDate = endTimestamp.toDate();

        if (now.isBefore(startDate) || now.isAfter(endDate)) {
          // If the current date is not within the promotion period, skip
          continue;
        }

        final double discountAmount =
            promoData['discountAmount'] as double? ?? 0.0;
        final double discountPercentage =
            promoData['discountPercentage'] as double? ?? 0.0;

        // Calculate the discount amount based on percentage if applicable
        final calculatedDiscount = discountPercentage > 0
            ? (medPrice / 100) * discountPercentage
            : 0.0;

        // Determine the maximum discount for this promotion
        final currentDiscount =
            discountAmount > 0 ? discountAmount : calculatedDiscount;

        // Update the highest discount if the current discount is greater
        if (currentDiscount > highestDiscount) {
          highestDiscount = currentDiscount;
        }
      }
    } catch (e) {
      return 0;
    }

    return highestDiscount.round().toDouble();
  }
}

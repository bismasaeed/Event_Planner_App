import 'package:cloud_firestore/cloud_firestore.dart';

class BookingService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> getBookingsForOrganizer(String organizerId) {
    return _firestore
        .collection('bookings')
        .where('organizerId', isEqualTo: organizerId)
        .snapshots();
  }

  Future<void> deleteBooking(String bookingId) async {
    await _firestore.collection('bookings').doc(bookingId).delete();
  }
}

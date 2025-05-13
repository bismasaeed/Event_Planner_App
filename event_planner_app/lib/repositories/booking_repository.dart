import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';

class BookingRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Create a booking request
  Future<void> createBooking(Booking booking) async {
    await _firestore.collection('bookings').add(booking.toMap());
  }

  // Get all bookings for the organizer
  Stream<List<Booking>> getBookingsForOrganizer(String organizerId) {
    return _firestore
        .collection('bookings')  // Make sure the collection name is 'bookings'
        .where('organizerId', isEqualTo: organizerId)
        .snapshots()
        .map(
          (snapshot) =>
          snapshot.docs
              .map((doc) => Booking.fromMap(doc.data(), doc.id))
              .toList(),
    );
  }

  // Update booking status (pending, accepted, rejected)
  Future<void> updateBookingStatus(String id, String newStatus) async {
    await _firestore.collection('bookings').doc(id).update({
      'status': newStatus,
    });
  }
}

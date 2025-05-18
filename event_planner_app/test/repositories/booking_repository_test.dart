import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_app/repositories/booking_repository.dart';
import 'package:event_app/models/booking_model.dart';

import 'booking_repository_test.mocks.dart';

@GenerateMocks([
  FirebaseFirestore,
  CollectionReference,
  DocumentReference,
  Query,
  QuerySnapshot,
  QueryDocumentSnapshot,
])
void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockCollectionReference<Map<String, dynamic>> mockCollection;
  late MockDocumentReference<Map<String, dynamic>> mockDocument;
  late MockQuery<Map<String, dynamic>> mockQuery;
  late MockQuerySnapshot<Map<String, dynamic>> mockQuerySnapshot;
  late MockQueryDocumentSnapshot<Map<String, dynamic>> mockDocSnapshot;

  late BookingRepository repository;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockCollection = MockCollectionReference<Map<String, dynamic>>();
    mockDocument = MockDocumentReference<Map<String, dynamic>>();
    mockQuery = MockQuery<Map<String, dynamic>>();
    mockQuerySnapshot = MockQuerySnapshot<Map<String, dynamic>>();
    mockDocSnapshot = MockQueryDocumentSnapshot<Map<String, dynamic>>();

    repository = BookingRepository(firestore: mockFirestore);
  });

  test('createBooking should call add with correct data', () async {
    final booking = Booking(
      id: 'id1',
      organizerId: 'org1',
      vendorId: 'ven1',
      vendorCategory: 'catering',
      vendorName: 'Vendor A',
      status: 'pending',
      selectedDateTime: DateTime.now(),
    );

    when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
    when(mockCollection.add(any)).thenAnswer((_) async => mockDocument);

    await repository.createBooking(booking);

    verify(mockCollection.add(argThat(
      containsPair('organizerId', 'org1'),
    ))).called(1);
  });

  test('updateBookingStatus should update document with new status', () async {
    const bookingId = 'id123';
    const newStatus = 'accepted';

    when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
    when(mockCollection.doc(bookingId)).thenReturn(mockDocument);
    when(mockDocument.update({'status': newStatus}))
        .thenAnswer((_) async => null);

    await repository.updateBookingStatus(bookingId, newStatus);

    verify(mockDocument.update({'status': newStatus})).called(1);
  });

  test('getBookingsForOrganizer should return a stream of bookings', () async {
    const organizerId = 'org123';
    final bookingData = {
      'organizerId': organizerId,
      'vendorId': 'v1',
      'vendorCategory': 'photography',
      'vendorName': 'SnapShots',
      'status': 'pending',
      'selectedDateTime': Timestamp.fromDate(DateTime(2024, 1, 1)),
    };

    when(mockFirestore.collection('bookings')).thenReturn(mockCollection);
    when(mockCollection.where('organizerId', isEqualTo: organizerId))
        .thenReturn(mockQuery);

    when(mockQuery.snapshots()).thenAnswer((_) => Stream.value(mockQuerySnapshot));
    when(mockQuerySnapshot.docs).thenReturn([mockDocSnapshot]);
    when(mockDocSnapshot.id).thenReturn('booking123');
    when(mockDocSnapshot.data()).thenReturn(bookingData);

    final bookingsStream = repository.getBookingsForOrganizer(organizerId);

    await expectLater(bookingsStream, emits(isA<List<Booking>>()));
  });
}

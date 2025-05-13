class Booking {
  final String id;
  final String organizerId;
  final String vendorId;
  final String vendorCategory;
  final String vendorName;
  final String status; // pending, accepted, declined

  Booking({
    required this.id,
    required this.organizerId,
    required this.vendorId,
    required this.vendorCategory,
    required this.vendorName,
    required this.status,
  });

  factory Booking.fromMap(Map<String, dynamic> data, String id) {
    return Booking(
      id: id,
      organizerId: data['organizerId'],
      vendorId: data['vendorId'],
      vendorCategory: data['vendorCategory'],
      vendorName: data['vendorName'],
      status: data['status'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'organizerId': organizerId,
      'vendorId': vendorId,
      'vendorCategory': vendorCategory,
      'vendorName': vendorName,
      'status': status,
    };
  }
}

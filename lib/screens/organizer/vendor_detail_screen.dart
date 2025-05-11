import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class VendorDetailScreen extends StatelessWidget {
  final String postId;
  final Map<String, dynamic> postData;

  const VendorDetailScreen({
    super.key,
    required this.postId,
    required this.postData,
  });

  void _bookVendor(BuildContext context) async {
    final currentUser = FirebaseAuth.instance.currentUser;
    if (currentUser == null) return;

    // Check if organizer is the vendor
    if (currentUser.uid == postData['user_id']) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ You cannot book your own vendor listing.")),
      );
      return;
    }

    // Save booking request
    await FirebaseFirestore.instance.collection('bookings').add({
      'organizerId': currentUser.uid,
      'vendorId': postData['user_id'],
      'postId': postId,
      'category': postData['category'],
      'vendorName': postData['business_name'],
      'status': 'pending',
      'timestamp': FieldValue.serverTimestamp(),
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('✅ Booking Request Sent (Pending Approval)')),
    );

    Navigator.pop(context);
  }


  @override
  Widget build(BuildContext context) {
    final imageUrl = postData['image_url'];
    final name = postData['venue_name'] ?? postData['business_name'] ?? 'Vendor Detail';

    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (imageUrl != null)
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  imageUrl,
                  width: double.infinity,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
            const SizedBox(height: 20),
            Text('Name: $name', style: const TextStyle(fontSize: 18)),
            Text('City: ${postData['city'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            Text('Address: ${postData['address'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            Text('Price: PKR ${postData['price'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            Text('Available Quantity: ${postData['quantity'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            Text('Contact Name: ${postData['contact_name'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            Text('Contact Phone: ${postData['contact_phone'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            Text('Email: ${postData['email'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            Text('Description: ${postData['description'] ?? 'N/A'}', style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            Center(
              child: ElevatedButton.icon(
                onPressed: () => _bookVendor(context),
                icon: const Icon(Icons.bookmark_add),
                label: const Text('Book Vendor'),
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
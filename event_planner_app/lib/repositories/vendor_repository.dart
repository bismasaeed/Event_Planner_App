import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class VendorRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  Future<void> uploadVendorData({
    required String category,
    required String name,
    required String contact,
    required String price,
    required String quantity,
    required String extraField1,
    required String extraField2,
    required File imageFile,
  }) async {
    final vendorId = const Uuid().v4();

    // Upload image to Firebase Storage
    final ref = _storage.ref().child('vendor_images/$vendorId.jpg');
    await ref.putFile(imageFile);
    final imageUrl = await ref.getDownloadURL();

    // Store data in Firestore
    await _firestore.collection('vendors').doc(vendorId).set({
      'id': vendorId,
      'category': category,
      'name': name,
      'contact': contact,
      'price': price,
      'quantity': quantity,
      'extraField1': extraField1,
      'extraField2': extraField2,
      'imageUrl': imageUrl,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }
}

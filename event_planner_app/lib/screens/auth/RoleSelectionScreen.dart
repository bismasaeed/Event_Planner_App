import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:event_planner_app/screens/vendor/vendor_home_page.dart';

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({super.key});

  Future<void> _handleRoleSelection(BuildContext context, String role) async {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'email': user.email,
        'role': role,
        'timestamp': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));

      if (role == 'vendor') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => VendorHomePage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Organizer module coming soon!'),
            backgroundColor: Colors.orange,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Select Your Role"),
        backgroundColor: const Color(0xff6351ec),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton.icon(
              onPressed: () => _handleRoleSelection(context, 'organizer'),
              icon: const Icon(Icons.event_available),
              label: const Text('I am an Organizer'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                backgroundColor: Colors.deepPurple,
              ),
            ),
            const SizedBox(height: 30),
            ElevatedButton.icon(
              onPressed: () => _handleRoleSelection(context, 'vendor'),
              icon: const Icon(Icons.store_mall_directory),
              label: const Text('I am a Vendor'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                backgroundColor: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

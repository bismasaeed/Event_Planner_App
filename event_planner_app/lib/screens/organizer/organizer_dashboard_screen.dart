import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';


import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_event.dart';
import '../../blocs/auth_bloc/auth_state.dart';
import '../auth/signup_screen.dart';
import 'category_listing_screen.dart';
import '../../models/user_model.dart';
import 'organizer_booking_screen.dart'; // Import CustomUser model (if required)

class OrganizerDashboardScreen extends StatelessWidget {
  final CustomUser user;

  const OrganizerDashboardScreen({Key? key, required this.user}) : super(key: key);

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());

    // Navigate back to SignUpScreen after logout
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) =>  SignupScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Organizer Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome, ${user.displayName ?? "User"} (Organizer)',  // Access displayName from CustomUser
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            const Text(
              'Explore Vendors by Category',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 24),
            _buildCategoryButton(context, 'Food'),
            const SizedBox(height: 12),
            _buildCategoryButton(context, 'Decor'),
            const SizedBox(height: 12),
            _buildCategoryButton(context, 'Venue'),

            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.event_note),
              label: const Text("See Bookings"),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => OrganizerBookingScreen(organizerId: user.uid),
                  ),
                );
              },
            ),

          ],
        ),
      ),
    );
  }

  Widget _buildCategoryButton(BuildContext context, String category) {
    return ElevatedButton.icon(
      icon: const Icon(Icons.category),
      label: Text(category),
      style: ElevatedButton.styleFrom(
        minimumSize: const Size.fromHeight(50),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CategoryListingScreen(category: category),
          ),
        );
      },
    );
  }
}

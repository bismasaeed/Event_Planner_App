import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_event.dart';
import '../../models/user_model.dart';
import '../auth/signup_screen.dart';
import 'vendor_form_screen.dart';
import 'vendor_items_screen.dart';
import 'vendor_requests_screen.dart'; // Add this import for the new screen
import '../../blocs/vendor/vendor_bloc.dart';
import '../../repositories/vendor_repository.dart'; // Required for context.read

class VendorDashboardScreen extends StatelessWidget {
  final CustomUser user;

  const VendorDashboardScreen({Key? key, required this.user}) : super(key: key);

  void _logout(BuildContext context) {
    context.read<AuthBloc>().add(LogoutRequested());
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => SignupScreen()),
          (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vendor Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _logout(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${user.displayName} (Vendor)',
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '“A perfect place to sell your services or products.”',
              style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.list),
              label: const Text('View My Uploaded Items'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => VendorItemsScreen(userId: user.uid),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.add_business),
              label: const Text('Upload New Item / Service'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => BlocProvider(
                      create: (_) => VendorBloc(
                        vendorRepository: context.read<VendorRepository>(),
                      ),
                      child: VendorFormScreen(userId: user.uid),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.bookmark),
              label: const Text('See Booking Requests'),
              style: ElevatedButton.styleFrom(minimumSize: const Size.fromHeight(50)),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const VendorRequestsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

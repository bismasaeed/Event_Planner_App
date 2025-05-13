import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../vendor/vendor_dashboard_screen.dart';
import '../organizer/organizer_dashboard_screen.dart';
import '../../blocs/auth_bloc/auth_state.dart'; // Ensure this import is present
import '../../models/user_model.dart'; // Import CustomUser model (if required)

class RoleSelectionScreen extends StatelessWidget {
  const RoleSelectionScreen({Key? key}) : super(key: key);

  void _navigateToDashboard(BuildContext context, String role) {
    // Get the user from the AuthBloc's state
    final user = (context.read<AuthBloc>().state as Authenticated).user;

    // Navigate based on the selected role
    if (role == 'vendor') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => VendorDashboardScreen(user: user),  // Passing CustomUser directly
        ),
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => OrganizerDashboardScreen(user: user),  // Passing CustomUser directly
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // Get the user from the AuthBloc's state
    final user = (context.read<AuthBloc>().state as Authenticated).user;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Your Role'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome, ${user.displayName}',  // Accessing displayName from CustomUser
              style: Theme.of(context).textTheme.bodyLarge,  // Use bodyLarge instead of bodyText1
            ),
            const SizedBox(height: 16),
            const Text(
              'Choose your role to continue:',
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 40),
            ElevatedButton.icon(
              icon: const Icon(Icons.storefront),
              label: const Text('Vendor'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => _navigateToDashboard(context, 'vendor'),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              icon: const Icon(Icons.event),
              label: const Text('Organizer'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
              ),
              onPressed: () => _navigateToDashboard(context, 'organizer'),
            ),
          ],
        ),
      ),
    );
  }
}

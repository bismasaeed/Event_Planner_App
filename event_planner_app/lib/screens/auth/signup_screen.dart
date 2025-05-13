import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../../blocs/auth_bloc/auth_event.dart';
import '../../blocs/auth_bloc/auth_state.dart';
import '../role_selection/role_selection_screen.dart';

class SignupScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            // Show success message when authentication is successful
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Registered Successfully"))
            );

            // Navigate to Role Selection Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
            );
          } else if (state is AuthError) {
            // Show error message if authentication fails
            ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message))
            );
          }
        },
        builder: (context, state) {
          if (state is AuthLoading) {
            // Show loading indicator while waiting for authentication response
            return Center(child: CircularProgressIndicator());
          }

          return Padding(
            padding: const EdgeInsets.all(30.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '“Plan events with ease, connect with the best.”',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20, color: Colors.deepPurple),
                ),
                SizedBox(height: 50),
                ElevatedButton.icon(
                  icon: Icon(Icons.login, color: Colors.white),
                  label: Text("Sign in with Google", style: TextStyle(color: Colors.white)),
                  onPressed: () {
                    print("Google Sign-In Button Pressed"); // Debug log for button press
                    context.read<AuthBloc>().add(GoogleSignInRequested());
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.deepPurple,
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                    textStyle: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

import 'package:event_planner_app/blocs/auth/auth_bloc.dart';
import 'package:event_planner_app/blocs/auth/auth_event.dart';
import 'package:event_planner_app/blocs/auth/auth_state.dart';
import 'package:event_planner_app/repositories/auth_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'RoleSelectionScreen.dart';

class Signup extends StatelessWidget {
  const Signup({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepo = RepositoryProvider.of<AuthRepository>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocListener<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is Authenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('✅ Successfully signed in with Google!'),
                backgroundColor: Colors.green,
              ),
            );

            // Navigate to RoleSelectionScreen after login
            Future.delayed(Duration.zero, () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
              );
            });
          }
          else if (state is Unauthenticated) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('❌ Sign-in cancelled or failed'),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            return Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    children: [
                      Image.asset("assets/first.PNG"),
                      const SizedBox(height: 10),
                      const Text(
                        "Unlock the Future of",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        "Event Booking App",
                        style: TextStyle(
                          color: Color(0xff6351ec),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Text(
                          "Discover, book and experience unforgettable moments effortlessly!",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.black45,
                            fontSize: 20,
                          ),
                        ),
                      ),
                      const SizedBox(height: 50),
                      GestureDetector(
                        onTap: () async {
                          context.read<AuthBloc>().emit(AuthLoading()); // Show loader
                          final user = await authRepo.signInWithGoogle();
                          if (user != null) {
                            context.read<AuthBloc>().add(LoggedIn());
                          } else {
                            context.read<AuthBloc>().emit(Unauthenticated()); // Reset state
                          }
                        },
                        child: Container(
                          height: 70,
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: const Color(0xff6351ec),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/google.PNG",
                                height: 50,
                                width: 50,
                                fit: BoxFit.cover,
                              ),
                              const SizedBox(width: 20),
                              const Text(
                                "Sign in with Google",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 23,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                // Show a loader over the UI when AuthLoading
                if (state is AuthLoading)
                  Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(child: CircularProgressIndicator()),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

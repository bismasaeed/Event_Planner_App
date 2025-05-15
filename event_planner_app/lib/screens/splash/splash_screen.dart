import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import "package:animated_text_kit/animated_text_kit.dart";
import '../../blocs/auth_bloc/auth_bloc.dart';
import '../auth/signup_screen.dart';
import '../../blocs/auth_bloc/auth_event.dart';
import '../../blocs/auth_bloc/auth_state.dart';
import '../role_selection/role_selection_screen.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 2800),
    );

    _scaleAnimation = Tween<double>(begin: 1.8, end: 2.3).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutBack),
    );

    _controller.forward();

    context.read<AuthBloc>().add(AppStarted());

    Timer(Duration(seconds: 6), () {
      final state = context.read<AuthBloc>().state;

      if (state is Authenticated) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => RoleSelectionScreen()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => SignupScreen()),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple.shade50,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _scaleAnimation,
              child: Transform.translate(
                offset: Offset(-15, 0), // Pushes image 15 pixels to the left
                child: Image.asset(
                  "assets/logo.png",
                  width: 160,
                  height: 160,
                ),
              ),
            ),

            SizedBox(height: 18),
            AnimatedTextKit(
              animatedTexts: [
                TypewriterAnimatedText(
                  'Event Planner App\nYour Event, Our Plan!',
                  textStyle: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurple.shade700,
                  ),
                  speed: Duration(milliseconds: 100),
                ),
              ],
              totalRepeatCount: 1,
            ),
            SizedBox(height: 30),
            CircularProgressIndicator(
              color: Colors.deepPurple,
              strokeWidth: 3,
            ),
          ],
        ),
      ),
    );
  }
}

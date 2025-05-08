import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'blocs/auth/auth_bloc.dart';
import 'blocs/auth/auth_event.dart';
import 'blocs/auth/auth_state.dart';
import 'repositories/auth_repository.dart';

import 'screens/auth/signup.dart';
import 'screens/splash.dart';
import 'screens/dashboard/home_screen.dart';
import 'screens/vendor/vendor_home_page.dart';
import 'screens/vendor/vendor_form_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final AuthRepository _authRepository = AuthRepository();

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider.value(
      value: _authRepository,
      child: BlocProvider(
        create: (context) =>
        AuthBloc(authRepository: _authRepository)..add(AppStarted()),
        child: MaterialApp(
          title: 'Event Planner App',
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          initialRoute: '/navigator',
          routes: {
            '/splash': (context) => SplashScreen(),
            '/signup': (context) => const Signup(),
            '/home': (context) =>  HomeScreen(),
            '/vendor-home': (context) => const VendorHomePage(),
            '/vendor-form': (context) => const VendorFormScreen(),
            '/navigator': (context) => AppNavigator(),
          },
        ),
      ),
    );
  }
}

class AppNavigator extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, state) {
        if (state is AuthLoading) {
          return SplashScreen();
        } else if (state is Authenticated) {
          return HomeScreen(); // Organizer or general home
        } else {
          return Signup();
        }
      },
    );
  }
}

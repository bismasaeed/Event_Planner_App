import 'package:bloc/bloc.dart';
import 'package:event_planner_app/blocs/auth/auth_event.dart';
import 'package:event_planner_app/blocs/auth/auth_state.dart';
import 'package:event_planner_app/repositories/auth_repository.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;

  AuthBloc({required this.authRepository}) : super(AuthInitial()) {  // Updated constructor with named parameter
    on<AppStarted>((event, emit) {
      final user = authRepository.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      } else {
        emit(Unauthenticated());
      }
    });

    on<LoggedIn>((event, emit) {
      final user = authRepository.currentUser;
      if (user != null) {
        emit(Authenticated(user));
      }
    });

    on<LoggedOut>((event, emit) async {
      await authRepository.signOut();
      emit(Unauthenticated());
    });
  }
}

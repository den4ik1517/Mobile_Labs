import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:test1/src/features/auth/auth_use_case.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthUseCase useCase;

  AuthCubit(this.useCase) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final success = await useCase.login(email, password);

    if (success) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailure("Login failed. Please check your credentials."));
    }
  }

  Future<void> register(String email, String password) async {
    emit(AuthLoading());

    final success = await useCase.register(email, password);

    if (success) {
      emit(AuthSuccess());
    } else {
      emit(AuthFailure("Registration failed."));
    }
  }
}

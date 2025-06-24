import 'package:test1/src/features/auth/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository;
  AuthUseCase(this.repository);

  Future<bool> login(String email, String password) {
    return repository.login(email, password);
  }

  Future<bool> register(String email, String password) {
    return repository.register(email, password);
  }
}

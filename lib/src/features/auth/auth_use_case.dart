import 'package:test1/src/features/auth/auth_repository.dart';

class AuthUseCase {
  final AuthRepository _repository = AuthRepository();

  Future<bool> login(String email, String password) {
    return _repository.login(email, password);
  }

  Future<bool> register(String email, String password) {
    return _repository.register(email, password);
  }
}

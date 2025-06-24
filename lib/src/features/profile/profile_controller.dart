import '../../data/user_repository.dart';

class ProfileController {
  final UserRepository _userRepository;

  ProfileController(this._userRepository);

  Future<String> getLogin() async {
    final login = await _userRepository.getLogin();
    return login ?? '';
  }

  Future<String> getEmail() async {
    final email = await _userRepository.getEmail();
    return email ?? '';
  }
}

import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/user_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final UserRepository repository;

  ProfileCubit(this.repository) : super(ProfileLoading());

  Future<void> loadProfile() async {
    try {
      final login = await repository.getLogin() ?? '';
      final email = await repository.getEmail() ?? '';
      emit(ProfileLoaded(login: login, email: email));
    } catch (e) {
      emit(ProfileError('Failed to load profile'));
    }
  }
}

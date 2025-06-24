part of 'profile_cubit.dart';

abstract class ProfileState {}

class ProfileLoading extends ProfileState {}

class ProfileLoaded extends ProfileState {
  final String login;
  final String email;

  ProfileLoaded({required this.login, required this.email});
}

class ProfileError extends ProfileState {
  final String message;
  ProfileError(this.message);
}

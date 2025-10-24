import '../../domain/entities/profile.dart';

class ProfileState {
  final bool loading;
  final Profile? profile;
  final String? error;

  const ProfileState({
    this.loading = false,
    this.profile,
    this.error,
  });

  ProfileState copyWith({
    bool? loading,
    Profile? profile,
    String? error,
  }) =>
      ProfileState(
        loading: loading ?? this.loading,
        profile: profile ?? this.profile,
        error: error ?? this.error,
      );
}

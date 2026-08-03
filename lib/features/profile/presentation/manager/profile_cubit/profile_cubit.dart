import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../domain/entities/profile_entity.dart';
import '../../../domain/repo/profile_repo.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._repo) : super(const ProfileInitial());

  final ProfileRepo _repo;

  Future<void> load() async {
    emit(const ProfileLoading());
    try {
      final profile = await _repo.getProfile();
      emit(ProfileLoaded(profile: profile, tab: ProfileTab.all));
    } catch (e) {
      emit(ProfileFailureState(e.toString()));
    }
  }

  void selectTab(ProfileTab tab) {
    final current = state;
    if (current is! ProfileLoaded) return;
    emit(current.copyWith(tab: tab));
  }
}

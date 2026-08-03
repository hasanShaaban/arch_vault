import 'package:equatable/equatable.dart';

import '../../../domain/entities/profile_entity.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();

  @override
  List<Object?> get props => [];
}

class ProfileInitial extends ProfileState {
  const ProfileInitial();
}

class ProfileLoading extends ProfileState {
  const ProfileLoading();
}

class ProfileLoaded extends ProfileState {
  const ProfileLoaded({
    required this.profile,
    required this.tab,
  });

  final ProfileEntity profile;
  final ProfileTab tab;

  List<ProfileAssetEntity> get visibleAssets {
    if (tab == ProfileTab.popular) {
      return profile.assets.where((a) => a.isPopular).toList();
    }
    return profile.assets;
  }

  @override
  List<Object?> get props => [profile.username, tab, profile.assets];

  ProfileLoaded copyWith({
    ProfileEntity? profile,
    ProfileTab? tab,
  }) {
    return ProfileLoaded(
      profile: profile ?? this.profile,
      tab: tab ?? this.tab,
    );
  }
}

class ProfileFailureState extends ProfileState {
  const ProfileFailureState(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}

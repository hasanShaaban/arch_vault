import '../../../../generated/assets.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<ProfileModel> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return const ProfileModel(
      username: 'studio_arch',
      displayName: 'Studio Arch',
      bio:
          'Architectural visualization studio focused on high-fidelity 3D assets for residential and civic projects.',
      modelsCount: 24,
      rating: 4.8,
      downloadsCount: 310,
      assets: [
        ProfileAssetModel(
          id: '1',
          title: 'Modern Villa Atrium',
          label: 'Residential',
          rating: 4.8,
          isPopular: true,
          image: Assets.imagesPreviewsVilla,
        ),
        ProfileAssetModel(
          id: '2',
          title: 'Glass Office Tower',
          label: 'Commercial',
          rating: 4.5,
          isPopular: true,
          image: Assets.imagesPreviewsTower,
        ),
        ProfileAssetModel(
          id: '5',
          title: 'Urban Mixed-Use Block',
          label: 'Commercial',
          rating: 4.6,
          isPopular: false,
          image: Assets.imagesPreviewsMixedUse,
        ),
        ProfileAssetModel(
          id: '7',
          title: 'Skyline Lobby',
          label: 'Commercial',
          rating: 4.3,
          isPopular: false,
          image: Assets.imagesPreviewsLobby,
        ),
      ],
    );
  }
}

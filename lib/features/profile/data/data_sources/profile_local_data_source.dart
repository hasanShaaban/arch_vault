import '../../../../core/constants/mock_preview_images.dart';
import '../models/profile_model.dart';

abstract class ProfileLocalDataSource {
  Future<ProfileModel> getProfile();
}

class ProfileLocalDataSourceImpl implements ProfileLocalDataSource {
  @override
  Future<ProfileModel> getProfile() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return ProfileModel(
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
          imageUrl: MockPreviewImages.forId('1'),
        ),
        ProfileAssetModel(
          id: '2',
          title: 'Glass Office Tower',
          label: 'Commercial',
          rating: 4.5,
          isPopular: true,
          imageUrl: MockPreviewImages.forId('2'),
        ),
        ProfileAssetModel(
          id: '5',
          title: 'Urban Mixed-Use Block',
          label: 'Commercial',
          rating: 4.6,
          isPopular: false,
          imageUrl: MockPreviewImages.forId('5'),
        ),
        ProfileAssetModel(
          id: '7',
          title: 'Skyline Lobby',
          label: 'Commercial',
          rating: 4.3,
          isPopular: false,
          imageUrl: MockPreviewImages.forId('7'),
        ),
      ],
    );
  }
}

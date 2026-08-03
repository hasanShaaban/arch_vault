import '../../domain/entities/profile_entity.dart';

class ProfileModel {
  const ProfileModel({
    required this.username,
    required this.displayName,
    required this.bio,
    required this.modelsCount,
    required this.rating,
    required this.downloadsCount,
    required this.assets,
  });

  final String username;
  final String displayName;
  final String bio;
  final int modelsCount;
  final double rating;
  final int downloadsCount;
  final List<ProfileAssetModel> assets;

  ProfileEntity toEntity() => ProfileEntity(
        username: username,
        displayName: displayName,
        bio: bio,
        modelsCount: modelsCount,
        rating: rating,
        downloadsCount: downloadsCount,
        assets: assets.map((a) => a.toEntity()).toList(),
      );
}

class ProfileAssetModel {
  const ProfileAssetModel({
    required this.id,
    required this.title,
    required this.label,
    required this.rating,
    required this.isPopular,
    required this.image,
  });

  final String id;
  final String title;
  final String label;
  final double rating;
  final bool isPopular;
  final String image;

  ProfileAssetEntity toEntity() => ProfileAssetEntity(
        id: id,
        title: title,
        label: label,
        rating: rating,
        isPopular: isPopular,
        image: image,
      );
}

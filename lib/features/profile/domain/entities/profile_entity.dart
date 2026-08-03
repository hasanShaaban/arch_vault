class ProfileEntity {
  const ProfileEntity({
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
  final List<ProfileAssetEntity> assets;
}

class ProfileAssetEntity {
  const ProfileAssetEntity({
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
}

enum ProfileTab { all, popular }

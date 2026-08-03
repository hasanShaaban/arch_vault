class ModelAssetEntity {
  const ModelAssetEntity({
    required this.id,
    required this.title,
    required this.label,
    required this.rating,
    required this.downloadCount,
    required this.image,
  });

  final String id;
  final String title;
  final String label;
  final double rating;
  final int downloadCount;

  /// Asset path or remote URL; UI treats it as opaque.
  final String image;
}

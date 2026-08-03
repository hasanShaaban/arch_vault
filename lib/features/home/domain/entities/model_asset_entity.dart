class ModelAssetEntity {
  const ModelAssetEntity({
    required this.id,
    required this.title,
    required this.label,
    required this.rating,
    required this.downloadCount,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String label;
  final double rating;
  final int downloadCount;
  final String? imageUrl;
}

class BrowseAssetEntity {
  const BrowseAssetEntity({
    required this.id,
    required this.title,
    required this.label,
    required this.fileFormat,
    required this.rating,
    required this.downloadCount,
    required this.image,
  });

  final String id;
  final String title;
  final String label;
  final String fileFormat;
  final double rating;
  final int downloadCount;
  final String image;
}

enum BrowseSortOption { topRated, mostDownloaded }

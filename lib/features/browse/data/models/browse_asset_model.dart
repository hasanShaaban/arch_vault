import '../../domain/entities/browse_asset_entity.dart';

class BrowseAssetModel {
  const BrowseAssetModel({
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

  BrowseAssetEntity toEntity() => BrowseAssetEntity(
        id: id,
        title: title,
        label: label,
        fileFormat: fileFormat,
        rating: rating,
        downloadCount: downloadCount,
        image: image,
      );
}

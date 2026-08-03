import '../../domain/entities/model_asset_entity.dart';

class ModelAssetModel {
  const ModelAssetModel({
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

  ModelAssetEntity toEntity() => ModelAssetEntity(
        id: id,
        title: title,
        label: label,
        rating: rating,
        downloadCount: downloadCount,
        imageUrl: imageUrl,
      );
}

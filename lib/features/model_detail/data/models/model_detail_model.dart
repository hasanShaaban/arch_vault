import '../../domain/entities/model_detail_entity.dart';

class ModelDetailModel {
  const ModelDetailModel({
    required this.id,
    required this.title,
    required this.label,
    required this.fileFormat,
    required this.rating,
    required this.downloadCount,
    required this.description,
    required this.polygonCount,
    required this.author,
    required this.similarIds,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String label;
  final String fileFormat;
  final double rating;
  final int downloadCount;
  final String description;
  final int polygonCount;
  final String author;
  final List<String> similarIds;
  final String? imageUrl;

  ModelDetailEntity toEntity() => ModelDetailEntity(
        id: id,
        title: title,
        label: label,
        fileFormat: fileFormat,
        rating: rating,
        downloadCount: downloadCount,
        description: description,
        polygonCount: polygonCount,
        author: author,
        similarIds: similarIds,
        imageUrl: imageUrl,
      );
}

class SimilarModelModel {
  const SimilarModelModel({
    required this.id,
    required this.title,
    required this.label,
    required this.rating,
    this.imageUrl,
  });

  final String id;
  final String title;
  final String label;
  final double rating;
  final String? imageUrl;

  SimilarModelEntity toEntity() => SimilarModelEntity(
        id: id,
        title: title,
        label: label,
        rating: rating,
        imageUrl: imageUrl,
      );
}

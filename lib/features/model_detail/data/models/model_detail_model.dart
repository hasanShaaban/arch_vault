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
    required this.image,
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
  final String image;

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
        image: image,
      );
}

class SimilarModelModel {
  const SimilarModelModel({
    required this.id,
    required this.title,
    required this.label,
    required this.rating,
    required this.image,
  });

  final String id;
  final String title;
  final String label;
  final double rating;
  final String image;

  SimilarModelEntity toEntity() => SimilarModelEntity(
        id: id,
        title: title,
        label: label,
        rating: rating,
        image: image,
      );
}

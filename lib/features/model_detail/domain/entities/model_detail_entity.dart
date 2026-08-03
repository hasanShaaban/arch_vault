class ModelDetailEntity {
  const ModelDetailEntity({
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
}

class SimilarModelEntity {
  const SimilarModelEntity({
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
}

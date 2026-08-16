class Model3dEntity {
  const Model3dEntity({
    required this.id,
    required this.sourceFile,
    required this.uploadedAt,
    required this.isActive,
    required this.viewsCount,
    required this.downloadsCount,
    required this.usageCount,
    required this.ratingScore,
    this.aiLabel,
    this.aiConfidence,
    this.category,
    this.tags = const [],
    this.vertices,
    this.faces,
  });

  final String id;
  final String sourceFile;
  final DateTime uploadedAt;
  final bool isActive;
  final String? aiLabel;
  final double? aiConfidence;
  final String? category;
  final List<String> tags;
  final int? vertices;
  final int? faces;
  final int viewsCount;
  final int downloadsCount;
  final int usageCount;
  final int ratingScore;
}

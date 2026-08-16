class LabelConfidenceEntity {
  const LabelConfidenceEntity({
    required this.label,
    required this.confidence,
  });

  final String label;
  final double confidence;
}

class ModelPredictionDataEntity {
  const ModelPredictionDataEntity({
    this.superCategory,
    this.objectCategory,
    this.styleClass = const [],
    this.materialsPrimary,
    this.materialsSecondary = const [],
    this.warnings = const [],
  });

  final LabelConfidenceEntity? superCategory;
  final LabelConfidenceEntity? objectCategory;
  final List<LabelConfidenceEntity> styleClass;
  final LabelConfidenceEntity? materialsPrimary;
  final List<LabelConfidenceEntity> materialsSecondary;
  final List<String> warnings;
}

class UploadedModelInfoEntity {
  const UploadedModelInfoEntity({
    required this.id,
    this.title,
    this.description,
    this.bannerUrl,
    this.modelUrl,
    required this.uploadedAt,
    required this.isActive,
    this.aiLabel,
    this.aiConfidence,
    this.category,
    this.tags = const [],
    this.vertices,
    this.faces,
    required this.viewsCount,
    required this.downloadsCount,
    required this.usageCount,
    required this.ratingScore,
  });

  final String id;
  final String? title;
  final String? description;
  final String? bannerUrl;
  final String? modelUrl;
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

class UploadModelResponseEntity {
  const UploadModelResponseEntity({
    this.model,
    required this.status,
    required this.predictionStatus,
    this.prediction,
    this.rendersDir,
  });

  final UploadedModelInfoEntity? model;
  final String status;
  final String predictionStatus;
  final ModelPredictionDataEntity? prediction;
  final String? rendersDir;

  String? get id => model?.id;
  String? get title => model?.title;
  String? get description => model?.description;
}

import '../../../../features/upload/domain/entities/upload_model_response_entity.dart';

class UploadedByEntity {
  const UploadedByEntity({
    required this.id,
    required this.email,
    required this.username,
    required this.role,
    required this.dateJoined,
  });

  final int id;
  final String email;
  final String username;
  final String role;
  final DateTime dateJoined;
}

class Model3dEntity {
  const Model3dEntity({
    required this.id,
    this.title,
    this.description,
    this.bannerUrl,
    this.modelUrl,
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
    this.predictions,
    this.uploadedBy,
    this.objectCategory,
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
  final ModelPredictionDataEntity? predictions;
  final UploadedByEntity? uploadedBy;
  final String? objectCategory;
}

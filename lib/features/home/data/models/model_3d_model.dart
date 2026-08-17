import '../../../../features/upload/data/models/upload_model_response_model.dart';
import '../../domain/entities/model_3d_entity.dart';

class UploadedByModel extends UploadedByEntity {
  const UploadedByModel({
    required super.id,
    required super.email,
    required super.username,
    required super.role,
    required super.dateJoined,
  });

  factory UploadedByModel.fromJson(Map<String, dynamic> json) =>
      UploadedByModel(
        id: json['id'] as int,
        email: json['email'] as String,
        username: json['username'] as String,
        role: json['role'] as String,
        dateJoined: DateTime.parse(json['date_joined'] as String),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'email': email,
        'username': username,
        'role': role,
        'date_joined': dateJoined.toIso8601String(),
      };
}

class Model3dModel extends Model3dEntity {
  const Model3dModel({
    required super.id,
    super.title,
    super.description,
    super.bannerUrl,
    super.modelUrl,
    required super.uploadedAt,
    required super.isActive,
    required super.viewsCount,
    required super.downloadsCount,
    required super.usageCount,
    required super.ratingScore,
    super.aiLabel,
    super.aiConfidence,
    super.category,
    super.tags,
    super.vertices,
    super.faces,
    super.predictions,
    super.uploadedBy,
    super.objectCategory,
  });

  factory Model3dModel.fromJson(Map<String, dynamic> json) => Model3dModel(
        id: json['id'] as String,
        title: json['title'] as String?,
        description: json['description'] as String?,
        bannerUrl: json['banner_url'] as String?,
        modelUrl: json['model_url'] as String?,
        uploadedAt: DateTime.parse(json['uploaded_at'] as String),
        isActive: json['is_active'] as bool? ?? true,
        aiLabel: json['ai_label'] as String?,
        aiConfidence: (json['ai_confidence'] as num?)?.toDouble(),
        category: json['category'] as String?,
        tags: (json['tags'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        vertices: json['vertices'] as int?,
        faces: json['faces'] as int?,
        viewsCount: json['views_count'] as int? ?? 0,
        downloadsCount: json['downloads_count'] as int? ?? 0,
        usageCount: json['usage_count'] as int? ?? 0,
        ratingScore: json['rating_score'] as int? ?? 0,
        predictions: json['prediction'] != null
            ? ModelPredictionDataModel.fromJson(
                json['prediction'] as Map<String, dynamic>)
            : null,
        uploadedBy: json['uploaded_by'] != null
            ? UploadedByModel.fromJson(
                json['uploaded_by'] as Map<String, dynamic>)
            : null,
        objectCategory: json['object_category'] as String?,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'description': description,
        'banner_url': bannerUrl,
        'model_url': modelUrl,
        'uploaded_at': uploadedAt.toIso8601String(),
        'is_active': isActive,
        'ai_label': aiLabel,
        'ai_confidence': aiConfidence,
        'category': category,
        'tags': tags,
        'vertices': vertices,
        'faces': faces,
        'views_count': viewsCount,
        'downloads_count': downloadsCount,
        'usage_count': usageCount,
        'rating_score': ratingScore,
        'prediction': predictions != null
            ? (predictions as ModelPredictionDataModel).toJson()
            : null,
        'uploaded_by': uploadedBy != null
            ? (uploadedBy as UploadedByModel).toJson()
            : null,
        'object_category': objectCategory,
      };
}

import '../../domain/entities/model_3d_entity.dart';

class Model3dModel extends Model3dEntity {
  const Model3dModel({
    required super.id,
    required super.sourceFile,
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
  });

  factory Model3dModel.fromJson(Map<String, dynamic> json) => Model3dModel(
        id: json['id'] as String,
        sourceFile: json['source_file'] as String,
        uploadedAt: DateTime.parse(json['uploaded_at'] as String),
        isActive: json['is_active'] as bool,
        aiLabel: json['ai_label'] as String?,
        aiConfidence: (json['ai_confidence'] as num?)?.toDouble(),
        category: json['category'] as String?,
        tags: (json['tags'] as List<dynamic>?)
                ?.map((e) => e as String)
                .toList() ??
            [],
        vertices: json['vertices'] as int?,
        faces: json['faces'] as int?,
        viewsCount: json['views_count'] as int,
        downloadsCount: json['downloads_count'] as int,
        usageCount: json['usage_count'] as int,
        ratingScore: json['rating_score'] as int,
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'source_file': sourceFile,
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
      };
}

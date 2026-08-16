import 'dart:convert';

import '../../domain/entities/upload_model_response_entity.dart';

class LabelConfidenceModel extends LabelConfidenceEntity {
  const LabelConfidenceModel({
    required super.label,
    required super.confidence,
  });

  factory LabelConfidenceModel.fromJson(Map<String, dynamic> json) {
    return LabelConfidenceModel(
      label: json['label'] as String? ?? '',
      confidence: (json['confidence'] as num?)?.toDouble() ?? 0.0,
    );
  }

  Map<String, dynamic> toJson() => {
        'label': label,
        'confidence': confidence,
      };
}

class ModelPredictionDataModel extends ModelPredictionDataEntity {
  const ModelPredictionDataModel({
    super.superCategory,
    super.objectCategory,
    super.styleClass = const [],
    super.materialsPrimary,
    super.materialsSecondary = const [],
    super.warnings = const [],
  });

  factory ModelPredictionDataModel.fromJson(Map<String, dynamic> json) {
    final predictionsJson =
        json['predictions'] as Map<String, dynamic>? ?? json;

    LabelConfidenceModel? parseLabelConfidence(dynamic item) {
      if (item is Map<String, dynamic>) {
        return LabelConfidenceModel.fromJson(item);
      }
      return null;
    }

    List<LabelConfidenceModel> parseLabelConfidenceList(dynamic list) {
      if (list is List) {
        return list
            .whereType<Map<String, dynamic>>()
            .map((e) => LabelConfidenceModel.fromJson(e))
            .toList();
      }
      return [];
    }

    List<String> parseStringList(dynamic list) {
      if (list is List) {
        return list.map((e) => e.toString()).toList();
      }
      return [];
    }

    return ModelPredictionDataModel(
      superCategory: parseLabelConfidence(predictionsJson['super_category']),
      objectCategory: parseLabelConfidence(predictionsJson['object_category']),
      styleClass: parseLabelConfidenceList(predictionsJson['style_class']),
      materialsPrimary:
          parseLabelConfidence(predictionsJson['materials_primary']),
      materialsSecondary:
          parseLabelConfidenceList(predictionsJson['materials_secondary']),
      warnings: parseStringList(json['warnings']),
    );
  }

  Map<String, dynamic> toJson() => {
        'predictions': {
          'super_category': (superCategory as LabelConfidenceModel?)?.toJson(),
          'object_category':
              (objectCategory as LabelConfidenceModel?)?.toJson(),
          'style_class': styleClass
              .map((e) => LabelConfidenceModel(
                    label: e.label,
                    confidence: e.confidence,
                  ).toJson())
              .toList(),
          'materials_primary':
              (materialsPrimary as LabelConfidenceModel?)?.toJson(),
          'materials_secondary': materialsSecondary
              .map((e) => LabelConfidenceModel(
                    label: e.label,
                    confidence: e.confidence,
                  ).toJson())
              .toList(),
        },
        'warnings': warnings,
      };
}

class UploadedModelInfoModel extends UploadedModelInfoEntity {
  const UploadedModelInfoModel({
    required super.id,
    super.title,
    super.description,
    super.bannerUrl,
    super.modelUrl,
    required super.uploadedAt,
    required super.isActive,
    super.aiLabel,
    super.aiConfidence,
    super.category,
    super.tags = const [],
    super.vertices,
    super.faces,
    required super.viewsCount,
    required super.downloadsCount,
    required super.usageCount,
    required super.ratingScore,
  });

  factory UploadedModelInfoModel.fromJson(Map<String, dynamic> json) {
    return UploadedModelInfoModel(
      id: json['id'] as String? ?? '',
      title: json['title'] as String?,
      description: json['description'] as String?,
      bannerUrl: json['banner_url'] as String?,
      modelUrl: json['model_url'] as String?,
      uploadedAt: json['uploaded_at'] != null
          ? DateTime.tryParse(json['uploaded_at'] as String) ?? DateTime.now()
          : DateTime.now(),
      isActive: json['is_active'] as bool? ?? true,
      aiLabel: json['ai_label'] as String?,
      aiConfidence: (json['ai_confidence'] as num?)?.toDouble(),
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)
              ?.map((e) => e.toString())
              .toList() ??
          [],
      vertices: json['vertices'] as int?,
      faces: json['faces'] as int?,
      viewsCount: json['views_count'] as int? ?? 0,
      downloadsCount: json['downloads_count'] as int? ?? 0,
      usageCount: json['usage_count'] as int? ?? 0,
      ratingScore: json['rating_score'] as int? ?? 0,
    );
  }

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
      };
}

class UploadModelResponseModel extends UploadModelResponseEntity {
  const UploadModelResponseModel({
    super.model,
    required super.status,
    required super.predictionStatus,
    super.prediction,
    super.rendersDir,
  });

  factory UploadModelResponseModel.fromJson(Map<String, dynamic> json) {
    ModelPredictionDataModel? parsedPrediction;
    final rawPrediction = json['prediction'];

    if (rawPrediction is String && rawPrediction.isNotEmpty) {
      try {
        final decoded = jsonDecode(rawPrediction);
        if (decoded is Map<String, dynamic>) {
          parsedPrediction = ModelPredictionDataModel.fromJson(decoded);
        }
      } catch (_) {}
    } else if (rawPrediction is Map<String, dynamic>) {
      parsedPrediction = ModelPredictionDataModel.fromJson(rawPrediction);
    }

    UploadedModelInfoModel? modelInfo;
    if (json['model'] is Map<String, dynamic>) {
      modelInfo = UploadedModelInfoModel.fromJson(
        json['model'] as Map<String, dynamic>,
      );
    }

    return UploadModelResponseModel(
      model: modelInfo,
      status: json['status'] as String? ?? '',
      predictionStatus: json['prediction_status'] as String? ?? '',
      prediction: parsedPrediction,
      rendersDir: json['renders_dir'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'model': model != null
            ? (model is UploadedModelInfoModel
                ? (model as UploadedModelInfoModel).toJson()
                : UploadedModelInfoModel(
                    id: model!.id,
                    title: model!.title,
                    description: model!.description,
                    bannerUrl: model!.bannerUrl,
                    modelUrl: model!.modelUrl,
                    uploadedAt: model!.uploadedAt,
                    isActive: model!.isActive,
                    aiLabel: model!.aiLabel,
                    aiConfidence: model!.aiConfidence,
                    category: model!.category,
                    tags: model!.tags,
                    vertices: model!.vertices,
                    faces: model!.faces,
                    viewsCount: model!.viewsCount,
                    downloadsCount: model!.downloadsCount,
                    usageCount: model!.usageCount,
                    ratingScore: model!.ratingScore,
                  ).toJson())
            : null,
        'status': status,
        'prediction_status': predictionStatus,
        'prediction': prediction != null
            ? jsonEncode(
                (prediction is ModelPredictionDataModel
                        ? (prediction as ModelPredictionDataModel)
                        : ModelPredictionDataModel(
                            superCategory: prediction!.superCategory,
                            objectCategory: prediction!.objectCategory,
                            styleClass: prediction!.styleClass,
                            materialsPrimary: prediction!.materialsPrimary,
                            materialsSecondary: prediction!.materialsSecondary,
                            warnings: prediction!.warnings,
                          ))
                    .toJson(),
              )
            : null,
        'renders_dir': rendersDir,
      };
}

import '../../domain/entities/label_review_entity.dart';

class LabelReviewModel {
  const LabelReviewModel({
    required this.modelId,
    required this.title,
    required this.currentLabel,
    required this.suggestedLabel,
    required this.image,
  });

  final String modelId;
  final String title;
  final String currentLabel;
  final String suggestedLabel;
  final String image;

  LabelReviewModel copyWith({String? currentLabel}) {
    return LabelReviewModel(
      modelId: modelId,
      title: title,
      currentLabel: currentLabel ?? this.currentLabel,
      suggestedLabel: suggestedLabel,
      image: image,
    );
  }

  LabelReviewEntity toEntity() => LabelReviewEntity(
        modelId: modelId,
        title: title,
        currentLabel: currentLabel,
        suggestedLabel: suggestedLabel,
        image: image,
      );
}

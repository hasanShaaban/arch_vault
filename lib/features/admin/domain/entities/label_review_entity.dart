class LabelReviewEntity {
  const LabelReviewEntity({
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
}

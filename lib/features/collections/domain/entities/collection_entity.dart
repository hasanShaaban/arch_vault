class CollectionEntity {
  const CollectionEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.modelCount,
    required this.previewLabels,
  });

  final String id;
  final String name;
  final String description;
  final int modelCount;
  final List<String> previewLabels;
}

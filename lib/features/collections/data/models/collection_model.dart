import '../../domain/entities/collection_entity.dart';

class CollectionModel {
  const CollectionModel({
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

  CollectionEntity toEntity() => CollectionEntity(
        id: id,
        name: name,
        description: description,
        modelCount: modelCount,
        previewLabels: previewLabels,
      );
}

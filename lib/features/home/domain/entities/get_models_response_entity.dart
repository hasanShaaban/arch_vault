import 'model_3d_entity.dart';

class GetModelsResponseEntity {
  const GetModelsResponseEntity({
    required this.count,
    required this.results,
    this.next,
    this.previous,
  });

  final int count;
  final String? next;
  final String? previous;
  final List<Model3dEntity> results;
}

import '../entities/model_detail_entity.dart';

abstract class ModelDetailRepo {
  Future<ModelDetailEntity> getById(String id);

  Future<List<SimilarModelEntity>> getSimilar(List<String> ids);

  Future<void> downloadModel(String id);

  Future<double> rateModel({required String id, required int stars});
}

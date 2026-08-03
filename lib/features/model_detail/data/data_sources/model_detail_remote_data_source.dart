import '../models/model_detail_model.dart';

abstract class ModelDetailRemoteDataSource {
  Future<ModelDetailModel> getById(String id);

  Future<List<SimilarModelModel>> getSimilar(List<String> ids);

  Future<void> downloadModel(String id);

  Future<double> rateModel({required String id, required int stars});
}

class ModelDetailRemoteDataSourceImpl implements ModelDetailRemoteDataSource {
  Never _notReady() =>
      throw UnimplementedError('Model detail remote API is not connected yet.');

  @override
  Future<ModelDetailModel> getById(String id) async => _notReady();

  @override
  Future<List<SimilarModelModel>> getSimilar(List<String> ids) async =>
      _notReady();

  @override
  Future<void> downloadModel(String id) async => _notReady();

  @override
  Future<double> rateModel({required String id, required int stars}) async =>
      _notReady();
}

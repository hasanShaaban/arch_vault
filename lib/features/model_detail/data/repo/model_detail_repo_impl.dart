import '../../../../core/errors/failures.dart';
import '../../domain/entities/model_detail_entity.dart';
import '../../domain/repo/model_detail_repo.dart';
import '../data_sources/model_detail_local_data_source.dart';

class ModelDetailRepoImpl implements ModelDetailRepo {
  ModelDetailRepoImpl(this._localDataSource);

  final ModelDetailLocalDataSource _localDataSource;

  @override
  Future<ModelDetailEntity> getById(String id) async {
    try {
      final model = await _localDataSource.getById(id);
      return model.toEntity();
    } on Failure {
      rethrow;
    } catch (_) {
      throw const Failure('Unexpected model detail error');
    }
  }

  @override
  Future<List<SimilarModelEntity>> getSimilar(List<String> ids) async {
    final models = await _localDataSource.getSimilar(ids);
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<void> downloadModel(String id) {
    return _localDataSource.downloadModel(id);
  }

  @override
  Future<double> rateModel({required String id, required int stars}) {
    return _localDataSource.rateModel(id: id, stars: stars);
  }
}

import '../../domain/entities/model_asset_entity.dart';
import '../../domain/repo/home_repo.dart';
import '../data_sources/home_local_data_source.dart';

class HomeRepoImpl implements HomeRepo {
  HomeRepoImpl(this._localDataSource);

  final HomeLocalDataSource _localDataSource;

  @override
  Future<List<ModelAssetEntity>> getFeaturedModels() async {
    final models = await _localDataSource.getFeaturedModels();
    return models.map((m) => m.toEntity()).toList();
  }
}

import '../../domain/entities/browse_asset_entity.dart';
import '../../domain/repo/browse_repo.dart';
import '../data_sources/browse_local_data_source.dart';

class BrowseRepoImpl implements BrowseRepo {
  BrowseRepoImpl(this._localDataSource);

  final BrowseLocalDataSource _localDataSource;

  @override
  Future<List<BrowseAssetEntity>> getAssets() async {
    final models = await _localDataSource.getAssets();
    return models.map((m) => m.toEntity()).toList();
  }
}

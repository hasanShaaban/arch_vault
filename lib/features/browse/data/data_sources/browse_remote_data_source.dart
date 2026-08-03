import '../models/browse_asset_model.dart';

/// Remote browse API contract. Wired when Django endpoints are available.
abstract class BrowseRemoteDataSource {
  Future<List<BrowseAssetModel>> getAssets();
}

class BrowseRemoteDataSourceImpl implements BrowseRemoteDataSource {
  Never _notReady() =>
      throw UnimplementedError('Browse remote API is not connected yet.');

  @override
  Future<List<BrowseAssetModel>> getAssets() async => _notReady();
}

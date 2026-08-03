import '../models/model_asset_model.dart';

/// Remote home API contract. Wired when Django endpoints are available.
abstract class HomeRemoteDataSource {
  Future<List<ModelAssetModel>> getFeaturedModels();
}

class HomeRemoteDataSourceImpl implements HomeRemoteDataSource {
  Never _notReady() =>
      throw UnimplementedError('Home remote API is not connected yet.');

  @override
  Future<List<ModelAssetModel>> getFeaturedModels() async => _notReady();
}

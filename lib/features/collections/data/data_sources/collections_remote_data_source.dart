import '../../../home/domain/entities/model_asset_entity.dart';
import '../models/collection_model.dart';

/// Remote collections API contract. Wired when Django endpoints are available.
abstract class CollectionsRemoteDataSource {
  Future<List<CollectionModel>> getCollections();

  Future<(CollectionModel, List<ModelAssetEntity>)> getCollectionDetail(
    String id,
  );

  Future<CollectionModel> createCollection({
    required String name,
    required String description,
  });

  Future<CollectionModel> updateCollection({
    required String id,
    required String name,
    required String description,
  });

  Future<void> deleteCollection(String id);
}

class CollectionsRemoteDataSourceImpl implements CollectionsRemoteDataSource {
  Never _notReady() =>
      throw UnimplementedError('Collections remote API is not connected yet.');

  @override
  Future<List<CollectionModel>> getCollections() async => _notReady();

  @override
  Future<(CollectionModel, List<ModelAssetEntity>)> getCollectionDetail(
    String id,
  ) async =>
      _notReady();

  @override
  Future<CollectionModel> createCollection({
    required String name,
    required String description,
  }) async =>
      _notReady();

  @override
  Future<CollectionModel> updateCollection({
    required String id,
    required String name,
    required String description,
  }) async =>
      _notReady();

  @override
  Future<void> deleteCollection(String id) async => _notReady();
}

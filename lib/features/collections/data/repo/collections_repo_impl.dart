import '../../domain/entities/collection_detail_entity.dart';
import '../../domain/entities/collection_entity.dart';
import '../../domain/repo/collections_repo.dart';
import '../data_sources/collections_local_data_source.dart';

class CollectionsRepoImpl implements CollectionsRepo {
  CollectionsRepoImpl(this._localDataSource);

  final CollectionsLocalDataSource _localDataSource;

  @override
  Future<List<CollectionEntity>> getCollections() async {
    final models = await _localDataSource.getCollections();
    return models.map((m) => m.toEntity()).toList();
  }

  @override
  Future<CollectionDetailEntity> getCollectionDetail(String id) async {
    final (collection, models) =
        await _localDataSource.getCollectionDetail(id);
    return CollectionDetailEntity(
      collection: collection.toEntity(),
      models: models,
    );
  }

  @override
  Future<CollectionEntity> createCollection({
    required String name,
    required String description,
  }) async {
    final model = await _localDataSource.createCollection(
      name: name,
      description: description,
    );
    return model.toEntity();
  }

  @override
  Future<CollectionEntity> updateCollection({
    required String id,
    required String name,
    required String description,
  }) async {
    final model = await _localDataSource.updateCollection(
      id: id,
      name: name,
      description: description,
    );
    return model.toEntity();
  }

  @override
  Future<void> deleteCollection(String id) {
    return _localDataSource.deleteCollection(id);
  }
}

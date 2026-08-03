import '../../../../generated/assets.dart';
import '../../../home/domain/entities/model_asset_entity.dart';
import '../models/collection_model.dart';

abstract class CollectionsLocalDataSource {
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

class CollectionsLocalDataSourceImpl implements CollectionsLocalDataSource {
  final List<CollectionModel> _collections = [
    const CollectionModel(
      id: 'c1',
      name: 'Residential Favorites',
      description: 'Villas and courtyard homes for concept boards.',
      modelCount: 12,
      previewLabels: ['Residential', 'Residential', 'Public'],
    ),
    const CollectionModel(
      id: 'c2',
      name: 'Commercial Towers',
      description: 'Office and mixed-use masses for urban studies.',
      modelCount: 8,
      previewLabels: ['Commercial', 'Commercial', 'Commercial'],
    ),
    const CollectionModel(
      id: 'c3',
      name: 'Civic & Public',
      description: 'Libraries, pavilions, and civic buildings.',
      modelCount: 6,
      previewLabels: ['Public', 'Public', 'Residential'],
    ),
    const CollectionModel(
      id: 'c4',
      name: 'Lobby Interiors',
      description: 'Interior lobby shells and reception zones.',
      modelCount: 5,
      previewLabels: ['Commercial', 'Public'],
    ),
  ];

  final Map<String, List<ModelAssetEntity>> _modelsByCollection = {
    'c1': const [
      ModelAssetEntity(
        id: '1',
        title: 'Modern Villa Atrium',
        label: 'Residential',
        rating: 4.8,
        downloadCount: 310,
        image: Assets.imagesPreviewsVilla,
      ),
      ModelAssetEntity(
        id: '4',
        title: 'Courtyard Residence',
        label: 'Residential',
        rating: 4.2,
        downloadCount: 97,
        image: Assets.imagesPreviewsCourtyard,
      ),
      ModelAssetEntity(
        id: '7',
        title: 'Hillside Townhouse',
        label: 'Residential',
        rating: 4.4,
        downloadCount: 142,
        image: Assets.imagesPreviewsLobby,
      ),
    ],
    'c2': const [
      ModelAssetEntity(
        id: '2',
        title: 'Glass Office Tower',
        label: 'Commercial',
        rating: 4.5,
        downloadCount: 188,
        image: Assets.imagesPreviewsTower,
      ),
      ModelAssetEntity(
        id: '5',
        title: 'Urban Mixed-Use Block',
        label: 'Commercial',
        rating: 4.6,
        downloadCount: 221,
        image: Assets.imagesPreviewsMixedUse,
      ),
      ModelAssetEntity(
        id: '8',
        title: 'Sky Lobby Tower',
        label: 'Commercial',
        rating: 4.3,
        downloadCount: 76,
        image: Assets.imagesPreviewsCourthouse,
      ),
    ],
    'c3': const [
      ModelAssetEntity(
        id: '3',
        title: 'Cultural Pavilion',
        label: 'Public',
        rating: 4.9,
        downloadCount: 412,
        image: Assets.imagesPreviewsPavilion,
      ),
      ModelAssetEntity(
        id: '6',
        title: 'Library Annex',
        label: 'Public',
        rating: 4.7,
        downloadCount: 156,
        image: Assets.imagesPreviewsLibrary,
      ),
      ModelAssetEntity(
        id: '9',
        title: 'Harbor Community Hall',
        label: 'Public',
        rating: 4.5,
        downloadCount: 89,
        image: Assets.imagesPreviewsHarbor,
      ),
    ],
    'c4': const [
      ModelAssetEntity(
        id: '10',
        title: 'Atrium Reception Shell',
        label: 'Commercial',
        rating: 4.1,
        downloadCount: 64,
        image: Assets.imagesPreviewsAtrium,
      ),
      ModelAssetEntity(
        id: '11',
        title: 'Gallery Lobby Sequence',
        label: 'Public',
        rating: 4.6,
        downloadCount: 118,
        image: Assets.imagesPreviewsGallery,
      ),
    ],
  };

  @override
  Future<List<CollectionModel>> getCollections() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List<CollectionModel>.unmodifiable(_collections);
  }

  @override
  Future<(CollectionModel, List<ModelAssetEntity>)> getCollectionDetail(
    String id,
  ) async {
    await Future<void>.delayed(const Duration(milliseconds: 280));
    final collection = _collections.where((c) => c.id == id).firstOrNull;
    if (collection == null) {
      throw Exception('Collection not found');
    }
    final models = _modelsByCollection[id] ?? const <ModelAssetEntity>[];
    return (collection, models);
  }

  @override
  Future<CollectionModel> createCollection({
    required String name,
    required String description,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final created = CollectionModel(
      id: 'c${DateTime.now().millisecondsSinceEpoch}',
      name: name.trim(),
      description: description.trim(),
      modelCount: 0,
      previewLabels: const [],
    );
    _collections.insert(0, created);
    _modelsByCollection[created.id] = [];
    return created;
  }

  @override
  Future<CollectionModel> updateCollection({
    required String id,
    required String name,
    required String description,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    final index = _collections.indexWhere((c) => c.id == id);
    if (index < 0) throw Exception('Collection not found');
    final existing = _collections[index];
    final updated = CollectionModel(
      id: existing.id,
      name: name.trim(),
      description: description.trim(),
      modelCount: existing.modelCount,
      previewLabels: existing.previewLabels,
    );
    _collections[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteCollection(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    _collections.removeWhere((c) => c.id == id);
    _modelsByCollection.remove(id);
  }
}

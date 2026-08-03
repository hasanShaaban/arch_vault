import '../../../../generated/assets.dart';
import '../models/browse_asset_model.dart';

abstract class BrowseLocalDataSource {
  Future<List<BrowseAssetModel>> getAssets();
}

class BrowseLocalDataSourceImpl implements BrowseLocalDataSource {
  @override
  Future<List<BrowseAssetModel>> getAssets() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return const [
      BrowseAssetModel(
        id: '1',
        title: 'Modern Villa Atrium',
        label: 'Residential',
        fileFormat: 'GLTF',
        rating: 4.8,
        downloadCount: 310,
        image: Assets.imagesPreviewsVilla,
      ),
      BrowseAssetModel(
        id: '2',
        title: 'Glass Office Tower',
        label: 'Commercial',
        fileFormat: 'FBX',
        rating: 4.5,
        downloadCount: 188,
        image: Assets.imagesPreviewsTower,
      ),
      BrowseAssetModel(
        id: '3',
        title: 'Cultural Pavilion',
        label: 'Public',
        fileFormat: 'OBJ',
        rating: 4.9,
        downloadCount: 412,
        image: Assets.imagesPreviewsPavilion,
      ),
      BrowseAssetModel(
        id: '4',
        title: 'Courtyard Residence',
        label: 'Residential',
        fileFormat: 'GLTF',
        rating: 4.2,
        downloadCount: 97,
        image: Assets.imagesPreviewsCourtyard,
      ),
      BrowseAssetModel(
        id: '5',
        title: 'Urban Mixed-Use Block',
        label: 'Commercial',
        fileFormat: 'FBX',
        rating: 4.6,
        downloadCount: 221,
        image: Assets.imagesPreviewsMixedUse,
      ),
      BrowseAssetModel(
        id: '6',
        title: 'Library Annex',
        label: 'Public',
        fileFormat: 'OBJ',
        rating: 4.7,
        downloadCount: 156,
        image: Assets.imagesPreviewsLibrary,
      ),
      BrowseAssetModel(
        id: '7',
        title: 'Skyline Lobby',
        label: 'Commercial',
        fileFormat: 'GLTF',
        rating: 4.3,
        downloadCount: 134,
        image: Assets.imagesPreviewsLobby,
      ),
      BrowseAssetModel(
        id: '8',
        title: 'Desert Courthouse',
        label: 'Public',
        fileFormat: 'FBX',
        rating: 4.1,
        downloadCount: 76,
        image: Assets.imagesPreviewsCourthouse,
      ),
    ];
  }
}

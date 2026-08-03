import '../../domain/entities/upload_draft_entity.dart';
import '../../domain/repo/upload_repo.dart';

class UploadLocalDataSource {
  final List<MyUploadEntity> _uploads = [
    MyUploadEntity(
      id: 'u1',
      title: 'Courtyard Villa',
      fileName: 'courtyard_villa.gltf',
      status: 'Published',
      category: 'Residential',
      uploadedAt: DateTime(2026, 6, 12),
    ),
    MyUploadEntity(
      id: 'u2',
      title: 'Glass Office Tower',
      fileName: 'office_tower.gltf',
      status: 'Under review',
      category: 'Commercial',
      uploadedAt: DateTime(2026, 7, 2),
    ),
    MyUploadEntity(
      id: 'u3',
      title: 'Harbor Pavilion',
      fileName: 'harbor_pavilion.obj',
      status: 'Draft',
      category: 'Public',
      uploadedAt: DateTime(2026, 7, 10),
    ),
  ];

  Future<List<AiLabelScore>> classifyMock({
    required String fileName,
    required String title,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 700));
    final seed = '${fileName.toLowerCase()} ${title.toLowerCase()}';
    if (seed.contains('office') || seed.contains('tower')) {
      return const [
        AiLabelScore(label: 'Commercial', confidence: 0.84),
        AiLabelScore(label: 'Public', confidence: 0.10),
        AiLabelScore(label: 'Residential', confidence: 0.06),
      ];
    }
    if (seed.contains('library') || seed.contains('pavilion')) {
      return const [
        AiLabelScore(label: 'Public', confidence: 0.81),
        AiLabelScore(label: 'Commercial', confidence: 0.12),
        AiLabelScore(label: 'Residential', confidence: 0.07),
      ];
    }
    return const [
      AiLabelScore(label: 'Residential', confidence: 0.87),
      AiLabelScore(label: 'Commercial', confidence: 0.09),
      AiLabelScore(label: 'Public', confidence: 0.04),
    ];
  }

  Future<void> submitUpload(UploadDraftEntity draft) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    final topLabel = draft.aiLabels.isNotEmpty
        ? draft.aiLabels.first.label
        : 'Uncategorized';
    _uploads.insert(
      0,
      MyUploadEntity(
        id: 'u${DateTime.now().millisecondsSinceEpoch}',
        title: draft.title,
        fileName: draft.fileName ?? 'model.gltf',
        status: 'Under review',
        category: topLabel,
        uploadedAt: DateTime.now(),
      ),
    );
  }

  Future<List<MyUploadEntity>> getMyUploads() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<MyUploadEntity>.unmodifiable(_uploads);
  }
}

class UploadRepoImpl implements UploadRepo {
  UploadRepoImpl(this._localDataSource);

  final UploadLocalDataSource _localDataSource;

  @override
  Future<List<AiLabelScore>> classifyMock({
    required String fileName,
    required String title,
  }) {
    return _localDataSource.classifyMock(fileName: fileName, title: title);
  }

  @override
  Future<void> submitUpload(UploadDraftEntity draft) {
    return _localDataSource.submitUpload(draft);
  }

  @override
  Future<List<MyUploadEntity>> getMyUploads() {
    return _localDataSource.getMyUploads();
  }
}

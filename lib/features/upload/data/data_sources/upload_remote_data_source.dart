import '../../domain/entities/upload_draft_entity.dart';

/// Remote upload API contract. Wired when Django endpoints are available.
abstract class UploadRemoteDataSource {
  Future<List<AiLabelScore>> classifyMock({
    required String fileName,
    required String title,
  });

  Future<void> submitUpload(UploadDraftEntity draft);

  Future<List<MyUploadEntity>> getMyUploads();
}

class UploadRemoteDataSourceImpl implements UploadRemoteDataSource {
  Never _notReady() =>
      throw UnimplementedError('Upload remote API is not connected yet.');

  @override
  Future<List<AiLabelScore>> classifyMock({
    required String fileName,
    required String title,
  }) async =>
      _notReady();

  @override
  Future<void> submitUpload(UploadDraftEntity draft) async => _notReady();

  @override
  Future<List<MyUploadEntity>> getMyUploads() async => _notReady();
}
